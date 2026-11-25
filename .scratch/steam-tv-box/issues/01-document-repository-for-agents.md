# 01: Document the repository for future agents

**What to build:** A future agent can understand the repository's layout, canonical deployment flow, testing conventions, and agreed NAS host / TV endpoint vocabulary without rediscovering them.

**Blocked by:** None (can start immediately).

**Status:** resolved

- [x] Explain the major repository areas and distinguish the canonical installation flow from the alternate playbook.
- [x] Document where inventory overrides, roles, application documentation, and tests belong.
- [x] Describe the established linting and Molecule workflows.
- [x] Define the agreed NAS host, TV endpoint, and Steam Remote Play client terms without implementation details.

## Comments

Implemented and reviewed. The repository guide, glossary, and install references now identify `nas-reorder.yml` as the install playbook; `nas.yml` is not used for installation. Commits: `661f8922`, `ecbfd9a4`, `a019591a`.
