# 05: Add streaming browser shortcuts

**What to build:** From Steam Big Picture, the couch user can open Chrome shortcuts for Netflix, Max/HBO, Canal+, and YouTube, then sign in manually and use the services within their documented France/EU browser limits.

**Blocked by:** 04: Add the opt-in Steam couch session.

**Status:** ready-for-agent

- [ ] Chrome with DRM support is available to the `tvuser` session.
- [ ] Each requested streaming service can be launched from the couch interface.
- [ ] Provider sign-in remains manual; credentials are not stored in Ansible.
- [ ] Keyboard/mouse remains available as a fallback for sign-in and browser interactions.
- [ ] Documentation states that Netflix and ordinary YouTube are the strongest Linux-browser matches for 1080p, Max may be limited to 720p, and Canal+ or paid YouTube titles may be lower quality or unsupported.
- [ ] Shortcuts return the user to a usable Steam Big Picture session when the browser is closed.
