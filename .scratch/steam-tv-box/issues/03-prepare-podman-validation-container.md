# 03: Prepare a Podman validation container

**What to build:** A future agent can use a repeatable Podman-based development environment to run Ansible and the repository's validation requirements against the current checkout, without manually provisioning a host toolchain.

**Blocked by:** None (can start immediately).

**Status:** ready-for-human

- [x] The container can install the repository's Ansible and Galaxy dependencies.
- [ ] It can run the repository's Ansible syntax/lint checks, YAML and Markdown linting, and website build.
- [ ] It can run existing Molecule tests through the host Podman API's Docker-compatible interface.
- [x] The current working tree is available inside the container for validation.
- [x] Remote Ansible checks can use the operator's SSH agent without baking private keys or tokens into the image.
- [x] Usage and dependency-update instructions are documented.
- [x] The container is a development/validation environment, not a runtime deployed to `athena`.

## Comments

Implemented with the Podman host runner and documented in commits `111c9ad9`, `9083bc62`, `b8580e4c`, `fdd76cb8`, `82fd3f2d`, `cd4e1133`, and `15ed2ad2`. Podman 6.2.0 and its rootless API socket are now reachable through the OpenCode Flatpak host-spawn permission. The validation image built, Galaxy role/collection installation succeeded, and Ansible syntax passed. Ansible-lint then stopped the workflow on 24 existing repository violations, so YAML/Markdown lint, website build, and Molecule remain unverified. The first dependency check is complete; remaining acceptance checks stay pending.
