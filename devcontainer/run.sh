#!/usr/bin/env bash

set -Eeuo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
cd "$repo_root"

if ! command -v podman >/dev/null 2>&1; then
  echo 'Podman is required on the host.' >&2
  exit 1
fi

if [[ -z "${XDG_RUNTIME_DIR:-}" ]]; then
  echo 'XDG_RUNTIME_DIR is not set; run this from your Bazzite user session.' >&2
  exit 1
fi

podman_socket="$XDG_RUNTIME_DIR/podman/podman.sock"
systemctl --user start podman.socket
if [[ ! -S "$podman_socket" ]]; then
  echo "Podman API socket was not created at $podman_socket" >&2
  exit 1
fi

podman build --file .devcontainer/Containerfile --tag ansible-nas-validation:local .

molecule_config=$(mktemp)
trap 'rm -f "$molecule_config"' EXIT
sed "s|/var/run/docker.sock:/var/run/docker.sock|$podman_socket:/var/run/docker.sock|" \
  tests/molecule/base.yml >"$molecule_config"
if ! grep -Fq "$podman_socket:/var/run/docker.sock" "$molecule_config"; then
  echo 'Could not configure Molecule to mount the Podman API socket.' >&2
  exit 1
fi

podman_args=(
  run
  --rm
  --userns=keep-id
  --user "$(id -u):$(id -g)"
  --security-opt label=disable
  --workdir /workspace
  --volume "$repo_root:/workspace"
  --volume "$podman_socket:/var/run/docker.sock"
  --volume "$molecule_config:/workspace/tests/molecule/base.yml:ro"
  --env DOCKER_HOST=unix:///var/run/docker.sock
  --env HOME=/tmp
)

if [[ -n "${SSH_AUTH_SOCK:-}" ]]; then
  if [[ ! -S "$SSH_AUTH_SOCK" ]]; then
    echo "SSH_AUTH_SOCK is set but is not a socket: $SSH_AUTH_SOCK" >&2
    exit 1
  fi
  podman_args+=(--volume "$SSH_AUTH_SOCK:$SSH_AUTH_SOCK" --env "SSH_AUTH_SOCK=$SSH_AUTH_SOCK")
fi

podman "${podman_args[@]}" ansible-nas-validation:local ./devcontainer/validate.sh
