# TV endpoint

The `tv_endpoint` role is disabled by default. Set `tv_endpoint_enabled: true`
in the intended host inventory to install Ubuntu's `steam-installer` package and
start that APT-installed Steam client in Big Picture mode at the next login of
`tv_endpoint_user` (default: `tvuser`). The role does not reboot the host or
restart the active graphical session.

The role disables an installed Steam Snap without removing it or changing its
data. The APT installation starts with a fresh profile; no Snap data is
migrated. The autostart entry explicitly launches `/usr/games/steam`. Complete
Steam sign-in and Remote Play pairing interactively in the TV session.
