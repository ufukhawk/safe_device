# Contributing to safe_device

Thank you for taking the time to contribute! Here's everything you need to get started.

## Reporting Issues

Before opening an issue, please search existing issues to avoid duplicates.

When reporting a bug, include:
- Device model and Android/iOS version
- Package version
- Minimal code to reproduce the problem
- Expected vs actual behavior

For false positive/negative detection issues, include the output of `SafeDevice.rootDetectionDetails` (Android) or `SafeDevice.jailbreakDetails` (iOS).

## Pull Requests

### Important: Do not open PRs from a fork

Due to GitHub Actions permission limitations, PRs opened from forked repositories cannot be automatically reviewed by Claude. Please request write access to the repository and open your branch directly here.

### Workflow

1. Create a branch from `main`:
   ```bash
   git checkout -b fix/your-fix-description
   ```
2. Make your changes
3. Open a PR against `main`

### Guidelines

- Keep PRs focused — one fix or feature per PR
- Update `CHANGELOG.md` under an `## Unreleased` section
- Do not bump the version in `pubspec.yaml` — maintainers handle releases
- Test on a real device when possible, especially for root/jailbreak detection changes

## Local Development

### Requirements

- Flutter SDK
- Android Studio / Xcode
- A physical Android and/or iOS device (emulators are intentionally detected)

### Setup

```bash
git clone https://github.com/ufukhawk/safe_device.git
cd safe_device
flutter pub get
cd example
flutter pub get
```

### Running the example app

```bash
cd example
flutter run
```

### Android

Native code is in `android/src/main/java/com/xamdesign/safe_device/`. Key classes:

| Class | Responsibility |
|---|---|
| `RootedCheck` | Root detection logic |
| `EmulatorCheck` | Emulator detection |
| `MockLocation/LocationAssistant` | Mock location detection |
| `DevelopmentModeCheck` | Developer options detection |

### iOS

Native code is in `ios/Classes/`. Key files:

| File | Responsibility |
|---|---|
| `SafeDeviceJailbreakDetection.m` | Jailbreak detection logic |
| `SafeDevicePlugin.m` | Flutter method channel handler |

## Device-Specific Considerations

Some manufacturers require special handling to avoid false positives:

- **Samsung** — Knox security system can trigger root detection on stock devices. Changes affecting Samsung detection must be tested on a real Samsung device.
- **Xiaomi / Redmi / POCO** — MIUI system properties can mimic root indicators. Conservative multi-indicator checks apply.
- **Vivo** — Certain models report suspicious `Build.HOST` values on stock firmware.

When fixing a false positive, include the exact device model and build fingerprint in your PR description.

## Questions

Open a [GitHub Discussion](https://github.com/ufukhawk/safe_device/discussions) for general questions or ideas.
