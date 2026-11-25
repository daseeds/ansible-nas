# Add opt-in Linux TV endpoint support to Ansible-NAS

Status: ready-for-agent

## Problem Statement

`athena` is an Ubuntu 22.04 NAS managed by Ansible-NAS. The owner wants to use it at the TV as a Steam Remote Play client for a separate Linux gaming PC and to watch Netflix, Max/HBO, Canal+, and YouTube. The host already has a local `tvuser` Wayland session and Steam installed as a Snap, but no browser was detected. The new TV setup must not disrupt its NAS duties.

Future agents also need documentation explaining the repository structure, deployment path, and testing conventions.

## Solution

Add an optional host-level TV role to the canonical Ansible deployment. It should remain disabled by default and be enabled only for `athena`. Reuse the existing GDM auto-login session and `tvuser`, start Steam Big Picture for couch use, install Chrome and create controller-friendly shortcuts for the streaming services, and support Xbox-compatible and Nintendo Switch controllers.

Replace the Steam Snap with Ubuntu's APT `steam-installer`, but leave Snap data untouched and use a fresh Steam profile. Keep Steam/provider sign-in and pairing manual; do not store credentials in Ansible. Keep the existing NAS setup intact, configure the inventory to manage `athena` over SSH as `daseeds`, and do not automatically reboot or restart the active graphical session.

Document the repository for future agents and set realistic France/EU playback expectations. Netflix and ordinary YouTube are the strongest Linux-browser matches for 1080p; Max may be limited to 720p, while Canal+ and paid YouTube titles may be lower quality or unsupported.

## User Stories

1. As the owner, I want `athena` to remain a NAS while serving as a TV endpoint, so that adding TV use does not replace its existing NAS services.
2. As an Ansible operator, I want TV setup disabled by default, so that other NAS hosts are unaffected.
3. As an Ansible operator, I want to enable TV setup only for `athena`, so that the feature follows host-specific inventory configuration.
4. As a future maintainer, I want the TV setup behind one clear Ansible role interface, so that its behavior can be understood and tested in one place.
5. As a future maintainer, I want a repository guide describing major directories, the deployment flow, and validation, so that I can orient myself without rediscovering the project.
6. As a future maintainer, I want the guide to distinguish the canonical installation playbook from the alternate playbook, so that I do not deploy the wrong set of roles.
7. As an Ansible operator, I want the `daseeds` inventory to connect to `athena` over SSH as `daseeds`, so that deployment targets the network host rather than localhost.
8. As a couch user, I want the existing `tvuser` session to remain the local TV account, so that TV use stays separate from SSH and administration.
9. As a couch user, I want Steam Big Picture to start automatically after login, so that I can use the TV interface without navigating a desktop first.
10. As a gamer, I want Steam on `athena` to act as a Remote Play client for a separate Linux gaming PC, so that games run on the gaming PC and stream to the TV.
11. As a couch user, I want streaming-service shortcuts accessible from Steam Big Picture, so that I can launch playback without navigating a conventional desktop.
12. As a viewer, I want Chrome installed with DRM support, so that I can use providers that support Linux browser playback.
13. As a viewer, I want to sign in to streaming providers manually, so that my account credentials are not stored in Ansible.
14. As a controller user, I want Xbox-compatible controller support, so that I can navigate and play from the couch.
15. As a controller user, I want Nintendo Switch controller support, so that I can use the controllers I already own.
16. As a couch user, I want keyboard and mouse available as a fallback, so that first-time sign-in and browser interactions remain manageable.
17. As the owner, I want the Steam Snap data left untouched during package replacement, so that existing settings or game data are not accidentally deleted.
18. As a Steam user, I want the APT Steam client to start with a fresh profile, so that installation does not depend on inaccessible Snap data.
19. As a viewer, I want documented expectations for each provider's Linux playback quality, so that I know which services may not meet 1080p.
20. As an operator, I want the Ansible role to be safe to rerun, so that future configuration changes can be applied predictably.
21. As an operator, I want deployments limited to `athena`, so that TV configuration cannot be applied accidentally to other hosts.
22. As a user at the TV, I want to complete account sign-in, Steam pairing, and playback checks interactively, so that credentials stay private and actual device behavior is verified.
23. As an operator, I want deployment to avoid automatic reboot or forced restart of the active graphical session, so that it does not unexpectedly interrupt NAS or TV use.
24. As a future agent, I want the repository guide to explain where variables, roles, and tests belong, so that new changes follow project conventions.
25. As a future agent, I want agreed terms such as NAS host, TV endpoint, and Steam Remote Play client defined consistently, so that design discussions and documentation use the same vocabulary.
26. As a maintainer, I want documentation to distinguish provider limitations from Ansible limitations, so that unsupported HD playback is not misdiagnosed as a deployment defect.
27. As the owner, I want to test the setup with both controllers and the separate gaming PC, so that the intended couch workflow is checked end to end.

## Implementation Decisions

- Use one host-level Ansible role as the main module and test seam, included in the canonical deployment and controlled by a default-off opt-in setting.
- Enable TV support only for `athena` through host inventory; keep the existing NAS roles and services intact.
- Reuse the existing GDM auto-login session and `tvuser` account.
- Install Chrome and Ubuntu's APT `steam-installer`; replace the Steam Snap without purging, copying, or migrating its protected data.
- Start Steam Big Picture for the couch session and provide browser shortcuts for streaming services.
- Keep Steam/provider sign-in and pairing manual. Do not put account credentials in inventory or automation.
- Target Xbox-compatible and Nintendo Switch controllers, with keyboard/mouse as fallback.
- Manage `athena` over SSH as `daseeds`.
- Do not automatically reboot the host or restart the active graphical session. Changes requiring a new session should take effect at the next login unless the owner separately approves an interruption.
- Add a future-agent repository guide and record the agreed domain terms in the single-context glossary.

## Testing Decisions

- Good tests cross the Ansible role interface and verify observable behavior, rather than asserting task names or internal implementation details.
- Verify that the default-off configuration leaves non-TV hosts unchanged.
- Exercise the enabled role on Ubuntu 22.04 using the repository's Molecule conventions, checking the resulting host behavior and safe repeatability.
- Use acceptance checks on `athena` for couch-session login, Steam Big Picture startup, browser shortcuts, and both controller types.
- With the separate Linux gaming PC available, test Remote Play end to end, including pairing and returning from browser use.
- Manually verify provider sign-in and playback at the TV. DRM and provider policies make playback quality unsuitable for a deterministic automated test.
- Run relevant Ansible syntax/lint checks and Markdown documentation checks.
- Existing prior art includes Molecule scenarios for application roles and repository CI for Ansible and Markdown checks. The project has no direct prior example of a graphical host-level TV role.

## Out of Scope

- Replacing or disabling NAS services, Docker, or the existing NAS deployment.
- Running games locally on `athena`; it is a Steam Remote Play client, not the gaming host.
- Migrating Steam Snap games, settings, or account data into the APT installation.
- Storing Steam or streaming-service passwords in Ansible.
- Bypassing DRM, regional restrictions, or provider-imposed browser limitations.
- Guaranteeing 1080p for every service, 4K/HDR playback, or native streaming applications.
- Automatically rebooting the host or forcibly restarting the active desktop session.

## Further Notes

- The correct installation playbook is `nas-reorder.yml`; do not use `nas.yml` to install. Their role sets and ordering differ materially.
- `athena` is x86_64 with AMD Renoir integrated graphics, GDM, a Wayland session, and `tvuser`. Steam is currently installed as a Snap; its display, joystick, and `uinput` interfaces were connected when inspected.
- The current `daseeds` inventory defines `athena` as a local Ansible connection. The agreed setup changes it to SSH for `daseeds@athena`.
- Steam Big Picture is designed for TV/controller use, but browser shortcuts and Remote Play with non-Steam entries are not guaranteed; test the complete flow on the target.
- France/EU provider guidance checked for this spec:
  - [Netflix browser requirements](https://help.netflix.com/en/node/30081) list Linux browsers up to Full HD, while warning that Linux configurations are not guaranteed.
  - [Max France browser troubleshooting](https://help.max.com/fr-fr/Answer/Detail/000002521) states a 720p browser ceiling; Linux support is not explicit.
  - [CANAL+ technical requirements](https://canal-assistance.canalplus.com/fr/articles/utilisation/quelles-sont-les-conditions-techniques-daccs-canal/66d03d6643ac055ee49e12cb) do not list Linux. Its [support material](https://canal-assistance.canalplus.com/fr/conversations/services-a-la-demande/qualit-limite-960540-widevine-l3-sous-linux-aucune-solution-1080p/6ab69b58f77b6f97cd10d190) describes an HD DRM limitation on Linux.
  - [YouTube browser quality guidance](https://support.google.com/youtube/answer/6322658?hl=en) supports high-quality formats in Chrome, but paid movie playback may not provide HD in Linux browsers.
