# 03: Add the opt-in Steam couch session

**What to build:** When enabled for `athena`, Ansible prepares the existing `tvuser` session to launch Steam Big Picture as the TV interface, while keeping NAS duties intact and leaving other hosts unchanged.

**Blocked by:** 02: Make athena manageable over SSH.

**Status:** ready-for-agent

- [ ] TV setup is disabled by default and enabled only for `athena`.
- [ ] The host uses Ubuntu's APT Steam installer rather than the Steam Snap.
- [ ] Existing Steam Snap data is left untouched; no data is purged or migrated.
- [ ] Steam Big Picture starts for `tvuser` after the next normal login.
- [ ] Applying the role does not automatically reboot the host or restart the active graphical session.
- [ ] Molecule verifies the disabled-by-default behavior and safe repeatability on Ubuntu 22.04.
- [ ] On `athena`, the TV session reaches Steam Big Picture without disrupting NAS services.
