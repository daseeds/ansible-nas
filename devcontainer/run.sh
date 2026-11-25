#!/usr/bin/env bash

set -Eeuo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
cd "$repo_root"

host_command=()
if [[ -n "${FLATPAK_ID:-}" ]] && command -v flatpak-spawn >/dev/null 2>&1; then
  host_command=(flatpak-spawn --host --directory="$repo_root")
  if ! "${host_command[@]}" true >/dev/null 2>&1; then
    echo 'OpenCode Flatpak is not allowed to run host commands.' >&2
    echo 'Either run this script from a host terminal, or grant the Flatpak host-spawn permission and restart OpenCode:' >&2
    echo '  flatpak override --user --talk-name=org.freedesktop.Flatpak ai.opencode.opencode' >&2
    exit 1
  fi
elif command -v podman >/dev/null 2>&1; then
  :
else
  echo 'Podman is required on the host.' >&2
  exit 1
fi

run_host() {
  if ((${#host_command[@]})); then
    "${host_command[@]}" "$@"
  else
    "$@"
  fi
}

if ((${#host_command[@]})); then
  runtime_dir=$(run_host printenv XDG_RUNTIME_DIR)
else
  runtime_dir=${XDG_RUNTIME_DIR:-}
fi

if [[ -z "$runtime_dir" ]]; then
  echo 'XDG_RUNTIME_DIR is not set; run this from your Bazzite user session.' >&2
  exit 1
fi

podman_socket="$runtime_dir/podman/podman.sock"
run_host systemctl --user start podman.socket
if ! run_host test -S "$podman_socket"; then
  echo "Podman API socket was not created at $podman_socket" >&2
  exit 1
fi

run_host podman build --file .devcontainer/Containerfile --tag ansible-nas-validation:local .

molecule_config=$(mktemp "$repo_root/.devcontainer/molecule-config.XXXXXX")
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
  if ! run_host test -S "$SSH_AUTH_SOCK"; then
    echo "SSH_AUTH_SOCK is set but is not a socket: $SSH_AUTH_SOCK" >&2
    exit 1
  fi
  podman_args+=(--volume "$SSH_AUTH_SOCK:$SSH_AUTH_SOCK" --env "SSH_AUTH_SOCK=$SSH_AUTH_SOCK")
fi

run_host podman "${podman_args[@]}" ansible-nas-validation:local ./devcontainer/validate.sh
