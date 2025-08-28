### Demo

 [demo.mp4](demo.mp4)

<video src="demo.mp4" controls width="720" autoplay loop muted playsinline></video>

## MovToMp4 (macOS)

Ultra-light, zero/one-click converter: .mov → .mp4

### Install (users)

Option A — Download from Releases:
- Download `MovToMp4.zip` from the Releases page and unzip
- Move `MovToMp4.app` to `/Applications`
- Ensure `ffmpeg` is installed (recommended via Homebrew): `brew install ffmpeg`
- Use: Right‑click a `.mov` → Open With → `MovToMp4`

Notes:
- First launch may require right‑click → Open once (Gatekeeper)
- Requires `ffmpeg` (not bundled)

### Build (developers)

```bash
chmod +x build.sh
./build.sh
```

This compiles `MovToMp4.app` and registers it for “Open With” on `.mov`.

Requires `ffmpeg` (recommended via Homebrew):

```bash
brew install ffmpeg
```

### Use (user flow)

- Right-click a `.mov` → Open With → `MovToMp4` (recommended)
- Or drag `.mov` onto `MovToMp4.app`

Behavior:
- Silent: no dialogs, no notifications
- Output: writes `.mp4` next to source (auto `_1`, `_2` if name exists)
- Fast path: stream copy (`-c copy`), falls back to VideoToolbox H.264 + AAC with `+faststart`

### Distribute (maintainers)

1) Build artifacts
```bash
./release.sh
# outputs dist/MovToMp4.zip and dist/MovToMp4.zip.sha256
```

2) Create a GitHub Release
- Tag: `v1.0.0` (match `APP_VERSION` in `build.sh`)
- Upload `dist/MovToMp4.zip`

3) Homebrew tap (optional)
- Create a tap repo: `yourname/homebrew-movtomp4`
- Copy `HomebrewFormula/MovToMp4.rb` into the tap as `Formula/movtomp4.rb`
- Update in the formula:
  - `homepage` to your repo URL
  - `url` to your Release asset
  - `sha256` to the value from `dist/MovToMp4.zip.sha256`
- Commit and push

4) Notarization (optional, for smoother installs)
```bash
./notarize.sh <APPLE_ID> <TEAM_ID> <APP_SPECIFIC_PASSWORD>
```
Edit identity in `notarize.sh` to your Developer ID cert. Then re-run `./release.sh` to package the stapled app.

### App Store?

This AppleScript droplet shells out to `ffmpeg` and won’t meet App Store sandbox and licensing requirements. An App Store version would be a separate Swift app using `AVFoundation` (no external tools).

### License

MIT. See `LICENSE`.

Note: This app calls an external `ffmpeg` binary and does not bundle it. If you choose to redistribute a build that bundles `ffmpeg`, ensure you comply with `ffmpeg`'s license (LGPL/GPL depending on configuration) and include the required notices/source availability.
