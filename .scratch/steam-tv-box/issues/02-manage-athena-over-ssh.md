# 02: Make athena manageable over SSH

**What to build:** The normal Ansible inventory targets `athena` over SSH as `daseeds`, so operators can verify connectivity and manage the network host instead of accidentally targeting localhost.

**Blocked by:** None (can start immediately).

**Status:** ready-for-agent

- [ ] Ansible connects to the host `athena` using the `daseeds` SSH account.
- [ ] The inventory no longer routes this host to a local connection.
- [ ] An Ansible connectivity check succeeds against `athena`.
- [ ] Existing host-specific NAS configuration remains intact.
