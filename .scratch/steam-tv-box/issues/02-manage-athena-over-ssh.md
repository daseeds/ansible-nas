# 02: Make athena manageable over SSH

**What to build:** The normal Ansible inventory targets `athena` over SSH as `daseeds`, so operators can verify connectivity and manage the network host instead of accidentally targeting localhost.

**Blocked by:** None (can start immediately).

**Status:** resolved

- [ ] Ansible connects to the host `athena` using the `daseeds` SSH account.
- [x] The inventory no longer routes this host to a local connection.
- [ ] An Ansible connectivity check succeeds against `athena`.
- [x] Existing host-specific NAS configuration remains intact.

## Comments

- Implemented in commits `4719633c`, `d337394d`, `68f2d34f`, and `7bc3e3d1`. The inventory targets `athena` over SSH as `daseeds`; the SSH alias uses `192.168.1.99` and `~/.ssh/daseeds` from the controller's SSH config.
- `ssh athena true` succeeded. The Ansible CLI is unavailable in this environment, so the Ansible-specific connectivity check was not run.
