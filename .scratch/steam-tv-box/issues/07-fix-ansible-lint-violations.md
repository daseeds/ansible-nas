# 07: Fix existing Ansible lint violations

**What to build:** Clean the existing lint findings from the canonical Ansible playbook and its roles without changing deployment behavior, so the repository validation workflow can proceed past Ansible lint.

**Blocked by:** None (can start immediately).

**Status:** ready-for-agent

- [ ] Fix the existing fatal `ansible-lint` findings listed below.
- [ ] Fix the Jinja spacing warning in `roles/zwavejs/tasks/main.yml`.
- [ ] `ansible-lint nas-reorder.yml` completes without violations.
- [ ] `yamllint .` passes.
- [ ] Ansible syntax check still passes and no task behavior changes are introduced.

## Baseline findings

Observed on 2026-11-25 using the validation image's `ansible-lint 6.14.6`:

- `nas-reorder.yml`: excess blank lines (line 411), trailing whitespace (455), comment indentation (502), and missing final newline (504).
- `roles/homepage/defaults/main.yml`: missing final newline (77).
- `roles/immich/tasks/main.yml`: trailing whitespace (30, 33, 44, 49, 54, 58, 62, 67, 75, 80).
- `roles/matter/tasks/main.yml`: task name casing (11).
- `roles/newt/defaults/main.yml`: excess blank line (11).
- `roles/nextcloud_aio/tasks/main.yml`: task name casing (26), comment spacing (39, 41), and trailing whitespace (49).
- `roles/qbittorrent/tasks/main.yml`: trailing whitespace (30).
- `roles/sonarr/tasks/main.yml`: trailing whitespace (37).
- `roles/zwavejs/tasks/main.yml`: task name casing (11); Jinja spacing warning (13).

There were 24 fatal violations and one warning. The canonical playbook's Ansible syntax check passed before lint ran. The validation script is fail-fast, so YAML/Markdown lint, website build, and Molecule tests were not reached in that validation attempt.

## Comments

Discovered while running `./devcontainer/run.sh` after enabling the Bazzite-DX rootless Podman API. This ticket is for the existing lint baseline, not a Podman or container startup failure.
