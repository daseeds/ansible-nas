# Repository Guide for Agents

This guide describes where changes belong and how to validate them. Use the terms in [`GLOSSARY.md`](../../GLOSSARY.md) consistently.

## Repository layout

| Path | Purpose |
| --- | --- |
| `nas-reorder.yml` | Canonical installation playbook. Use it to configure the host and apply the selected roles. |
| `nas.yml` | Do not use this playbook for installation; its role list differs materially from the canonical install playbook. |
| `group_vars/all.yml` | Shared defaults and configuration options. |
| `inventories/<name>/inventory` | Hosts and groups for one deployment. |
| `inventories/<name>/group_vars/nas.yml` | Per-deployment overrides for shared settings and application options. |
| `roles/<name>/` | Ansible roles, generally with `defaults/`, `tasks/`, optional `handlers/`, documentation, and tests. |
| `roles/<name>/docs/` | Application-specific usage and configuration documentation. |
| `roles/<name>/molecule/` | Molecule scenarios for role integration tests. |
| `tests/` | Shared Molecule configuration, integration-test helpers, and test inventories. |
| `website/docs/` | User-facing Docusaurus documentation. |
| `.github/workflows/` | CI, documentation, and integration workflow definitions. |

When adding an application, follow `roles/hello_world/` and `CONTRIBUTING.md`. Put role defaults and behavior in that role rather than adding application-specific settings to a deployment inventory. Operators select and override settings in their own inventory.

## Deployment flow

1. Create or choose an inventory directory under `inventories/`. The inventory file names the target hosts; `group_vars/nas.yml` overrides values from `group_vars/all.yml`.
2. Install the external Ansible dependencies with `ansible-galaxy install -r requirements.yml`.
3. Review the target inventory and variables, then run the **canonical** playbook, for example:

   ```sh
   ansible-playbook -i inventories/sample/inventory nas-reorder.yml -b -K
   ```

`nas-reorder.yml` is the correct installation playbook. Do not use `nas.yml` to install Ansible-NAS. The two files differ in their role sets and ordering, so a role must be included in `nas-reorder.yml` to be applied by the documented installation flow.

## Testing and linting

CI's lint job runs:

```sh
ansible-lint nas-reorder.yml
yamllint .
```

Markdown files are checked with Markdownlint (version `0.32.2` in CI). The documentation workflow also builds the website using Node 18:

```sh
cd website
npm ci
npm run build
```

Role integration tests use Molecule with a Docker-compatible container API and the shared configuration in `tests/molecule/base.yml`. A role scenario lives in `roles/<name>/molecule/`; `tests/github-test-matrix.sh` discovers roles with a `molecule/` directory for the integration workflow. If the API is available at `/var/run/docker.sock`, run one role's scenario from its directory:

```sh
cd roles/hello_world
molecule -c ../../tests/molecule/base.yml test
```

`tests/test.sh` runs the same Molecule command for every role with a scenario, so it is the broad local integration suite and requires Docker or Podman with its Docker-compatible API enabled. On Bazzite-DX, use `./devcontainer/run.sh`; it configures the rootless Podman socket for Molecule. These tests exercise application roles; they do not replace reviewing inventory changes or validating a deployment on its target host.

## Podman validation environment

`.devcontainer/Containerfile` and `devcontainer/run.sh` provide a repeatable environment for the checks above. On Bazzite-DX, enable the rootless Podman API socket and run the workflow from the repository root:

```sh
systemctl --user enable --now podman.socket
./devcontainer/run.sh
```

The wrapper builds the validation image with Podman and runs it as the current user, mounting the checkout at `/workspace` and the rootless Podman socket. Molecule's Docker driver uses Podman's Docker-compatible API; the wrapper also adjusts the shared Molecule config so test instances receive the correct host socket. The container runs with SELinux labeling disabled to access that socket without relabeling the checkout. When `SSH_AUTH_SOCK` is set on the host, its socket is mounted for remote Ansible checks; it is never copied into the image. Without an SSH agent, validation still runs, but authenticated remote checks are unavailable. Use the normal inventory and command for remote checks, for example `ansible -i inventories/daseeds/inventory all -m ping`.

When running OpenCode as a Flatpak, the sandbox normally blocks launching host commands. The safest option is to run `./devcontainer/run.sh` from a host terminal. To allow the OpenCode Flatpak to invoke host Podman, grant `org.freedesktop.Flatpak` access and restart OpenCode:

```sh
flatpak override --user --talk-name=org.freedesktop.Flatpak ai.opencode.opencode
```

This permission allows the app to spawn arbitrary host commands as your user, so only grant it if that broader host access is acceptable. The runner detects the Flatpak environment and uses `flatpak-spawn --host` when enabled.

The validation script installs Galaxy roles and collections from `requirements.yml`, then runs Ansible syntax and lint checks, YAML and Markdown lint, the Node 18 website build, and all discovered Molecule scenarios. It may take a while and requires network access for dependency installation and image pulls.

To update the environment, change the pinned Python tool versions or `markdownlint-cli` version in `.devcontainer/Containerfile`; update Ansible roles and collections in `requirements.yml` as usual. Some existing Galaxy entries do not pin a version and therefore resolve to the latest compatible release; pin them in `requirements.yml` when an immutable dependency snapshot is needed. Then rerun `./devcontainer/run.sh` to rebuild and validate. The website's Node version is supplied by the Debian Bookworm package set and should be checked against the required Node 18 build before changing the base image.

## Repository-specific cautions

- Keep deployment-specific values in the appropriate inventory; do not copy private inventory data into examples or documentation.
- Use `nas-reorder.yml` for installation; do not use `nas.yml` as the install playbook.
- Read [`GLOSSARY.md`](../../GLOSSARY.md) for the NAS host, TV endpoint, and Steam Remote Play client vocabulary.
