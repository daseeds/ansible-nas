# 03: Prepare a Docker validation container

**What to build:** A future agent can use a repeatable Docker-based development environment to run Ansible and the repository's validation requirements against the current checkout, without manually provisioning a host toolchain.

**Blocked by:** None (can start immediately).

**Status:** ready-for-agent

- [ ] The container can install the repository's Ansible and Galaxy dependencies.
- [ ] It can run the repository's Ansible syntax/lint checks, YAML and Markdown linting, and website build.
- [ ] It can run existing Molecule tests using the host Docker daemon.
- [ ] The current working tree is available inside the container for validation.
- [ ] Remote Ansible checks can use the operator's SSH agent without baking private keys or tokens into the image.
- [ ] Usage and dependency-update instructions are documented.
- [ ] The container is a development/validation environment, not a runtime deployed to `athena`.
