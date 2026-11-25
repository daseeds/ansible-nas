# Repository Guide for Agents

This guide describes where changes belong and how to validate them. Use the terms in [`GLOSSARY.md`](../../GLOSSARY.md) consistently.

## Repository layout

| Path | Purpose |
| --- | --- |
| `nas.yml` | Canonical Ansible-NAS playbook. It configures the host and applies the selected roles. |
| `nas-reorder.yml` | Alternate playbook with a reordered and materially different role list. It is not the default installation path. |
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
   ansible-playbook -i inventories/sample/inventory nas.yml -b -K
   ```

`nas.yml` is the installation path documented for operators. `nas-reorder.yml` is an alternate playbook whose role set and ordering differ; do not substitute it for `nas.yml` unless intentionally working with that variant. A role must be included in the playbook to be applied by it.

## Testing and linting

CI's lint job runs:

```sh
ansible-lint nas.yml
yamllint .
```

Markdown files are checked with Markdownlint (version `0.32.2` in CI). The documentation workflow also builds the website using Node 18:

```sh
cd website
npm ci
npm run build
```

Role integration tests use Molecule with Docker and the shared configuration in `tests/molecule/base.yml`. A role scenario lives in `roles/<name>/molecule/`; `tests/github-test-matrix.sh` discovers roles with a `molecule/` directory for the integration workflow. Run one role's scenario from its directory:

```sh
cd roles/hello_world
molecule -c ../../tests/molecule/base.yml test
```

`tests/test.sh` runs the same Molecule command for every role with a scenario, so it is the broad local integration suite and requires Docker. These tests exercise application roles; they do not replace reviewing inventory changes or validating a deployment on its target host.

## Repository-specific cautions

- Keep deployment-specific values in the appropriate inventory; do not copy private inventory data into examples or documentation.
- Prefer the documented canonical playbook unless a change explicitly targets the alternate `nas-reorder.yml`.
- Read [`GLOSSARY.md`](../../GLOSSARY.md) for the NAS host, TV endpoint, and Steam Remote Play client vocabulary.
