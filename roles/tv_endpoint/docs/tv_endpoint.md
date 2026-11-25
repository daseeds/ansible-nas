# TV endpoint

The `tv_endpoint` role is disabled by default. Set `tv_endpoint_enabled: true`
in the intended host inventory to install Ubuntu's `steam-installer` and
`steam-devices` packages and start that APT-installed Steam client in Big Picture
mode at the next login of `tv_endpoint_user` (default: `tvuser`). `steam-devices`
provides Steam's udev access rules for controllers, including Xbox-compatible
devices, the Switch Pro Controller, and Joy-Cons. The role does not reboot the
host or restart the active graphical session.

The role disables an installed Steam Snap without removing it or changing its
data. The APT installation starts with a fresh profile; no Snap data is
migrated. The autostart entry explicitly launches `/usr/games/steam`. Complete
Steam sign-in and Remote Play pairing interactively in the TV session.

## Controllers and Remote Play

Connect an Xbox-compatible controller by USB or pair it over Bluetooth using
Steam's **Pair New Device** flow. For a Switch Pro Controller, use the same flow
or connect it by USB. Put each Joy-Con into pairing mode and pair both from the
Steam Bluetooth pairing screen. In Steam's **Settings → Controller**, enable the
matching Steam Input support; for a Joy-Con pair, enable **Combine Joy-Con Pairs**
if that option is shown. A single Joy-Con can also be used on its own. Reconnect
controllers after the first installation so the new udev rules apply. Keep a
keyboard and mouse available for pairing and troubleshooting.

On the separate gaming PC, sign in to Steam and enable Remote Play. Sign in to
the same Steam account in Big Picture on the TV endpoint, choose a game from the
library, and select **Stream**. Test both controller types in a streamed game,
then exit the game and confirm Big Picture remains usable. Sign-in, Bluetooth
pairing, and Remote Play setup are manual; never put Steam credentials in
inventory or automation. Hardware recognition and streaming input must be
confirmed on the TV endpoint because the container tests cannot exercise
physical controllers or a remote gaming PC.

When enabled, the role also installs Google Chrome from Google's APT repository.
Chrome includes Widevine DRM support for providers that permit Linux browser
playback. Four per-user application launchers open Netflix, Max, Canal+, and
YouTube in Chrome app windows. They contain only provider URLs; sign in to each
service manually in the browser.

To make the launchers available in Steam Big Picture, open Steam's **Add a
Game** menu once in Desktop Mode and add the Netflix, Max, Canal+, and YouTube
applications from the non-Steam application list. If they are not listed, add
the launchers from `~/.local/share/applications/`: `netflix-tv.desktop`,
`max-tv.desktop`, `canal-plus-tv.desktop`, and `youtube-tv.desktop`. The
launchers are ordinary non-Steam applications, so closing a Chrome window
should return focus to the still-running Steam Big Picture session. Keep a
keyboard and mouse available for first-time sign-in and browser interactions.

Playback quality is controlled by provider DRM and Linux browser policies, not
by Ansible. For France/EU use, Netflix and ordinary YouTube are the strongest
Linux-browser matches for 1080p. Max may be limited to 720p; Canal+ and paid
YouTube titles may be lower quality or unsupported. These limits can change
with provider policy and should be checked on the TV endpoint.

On the endpoint, manually verify the four launchers appear in Steam Big Picture,
each opens its intended service, provider sign-in works without credentials in
Ansible, and closing Chrome returns to a usable Big Picture session.
