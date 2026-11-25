# 03: Prepare a Podman validation container

**What to build:** A future agent can use a repeatable Podman-based development environment to run Ansible and the repository's validation requirements against the current checkout, without manually provisioning a host toolchain.

**Blocked by:** None (can start immediately).

**Status:** resolved

- [x] The container can install the repository's Ansible and Galaxy dependencies.
- [x] It can run the repository's Ansible syntax/lint checks, YAML and Markdown linting, and website build.
- [x] It can run existing Molecule tests through the host Podman API's Docker-compatible interface.
- [x] The current working tree is available inside the container for validation.
- [x] Remote Ansible checks can use the operator's SSH agent without baking private keys or tokens into the image.
- [x] Usage and dependency-update instructions are documented.
- [x] The container is a development/validation environment, not a runtime deployed to `athena`.

## Comments

Implemented with the Podman host runner and documented in commits `111c9ad9`, `9083bc62`, `b8580e4c`, `fdd76cb8`, and `82fd3f2d`. Shell syntax and diff checks passed. Podman is not available inside this OpenCode Flatpak sandbox, so the container build and Molecule execution still need to be run on Bazzite-DX. The runner supports `flatpak-spawn --host` if the user explicitly grants that permission; otherwise run it from a host terminal.
