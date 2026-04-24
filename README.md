# safe_device (Null-Safety)

<a href="https://pub.dev/packages/safe_device"><img src="https://img.shields.io/badge/pub-1.3.9-blue" alt="Safe Device" height="18"></a>
<img src="https://imgur.com/Vw4Z93n.png" alt="Safe Device">
Flutter (Null-Safety) Jailbroken, root, emulator and mock location detection.

## Getting Started

In your flutter project add the dependency:

```yml
dependencies:
...
  safe_device: ^1.3.9
```

## Usage

#### Importing package

```
import 'package:safe_device/safe_device.dart';
```

#### Configuration

You can configure the plugin at startup using `SafeDevice.init` and `SafeDeviceConfig`. This is useful if you want to disable automatic check such as the mock location detection.

```dart
import 'package:safe_device/safe_device.dart';
import 'package:safe_device/safe_device_config.dart';

void main() async {
  SafeDevice.init(
    SafeDeviceConfig(mockLocationCheckEnabled: false), // disables mock location check on Android
  );
  // ...rest of your app
}
```

It's not mandatory to configure the plugin at the start, if not provided a default configuration with everything enable is provided automatically
#### Using it

Checks whether device JailBroken on iOS/Android?

```
bool isJailBroken = await SafeDevice.isJailBroken;
```

(iOS ONLY) Enhanced jailbreak detection with custom path checking

```
bool isJailBrokenCustom = await SafeDevice.isJailBrokenCustom;
```

(iOS ONLY) Get detailed breakdown of jailbreak detection methods

```
Map<String, bool> details = await SafeDevice.jailbreakDetails;
```

Checks whether device is real or emulator

```
bool isRealDevice = await SafeDevice.isRealDevice;
```

bool isMockLocation = await SafeDevice.isMockLocation;

```
bool isMockLocation = await SafeDevice.isMockLocation;
```

**Android:** If mock location check is disabled via config, the check always returns `false` and no location updates are started. If enabled (default), the check is active.

**iOS:** The config is stored for future use but does not affect current detection logic. Mock location detection on iOS is based on jailbreak/emulator status.

(ANDROID ONLY) Check if application is running on external storage

```
bool isOnExternalStorage = await SafeDevice.isOnExternalStorage;
```

Check if device violates any of the above

```
bool isSafeDevice = await SafeDevice.isSafeDevice;
```

(ANDROID ONLY) Check if development Options is enable on device

```
bool isDevelopmentModeEnable = await SafeDevice.isDevelopmentModeEnable;
```

(ANDROID ONLY) Get detailed breakdown of root detection methods for debugging

```
Map<String, dynamic> rootDetails = await SafeDevice.rootDetectionDetails;
```

## Enhanced iOS Jailbreak Detection

The plugin includes enhanced jailbreak detection for iOS with comprehensive path checking. The custom detection method checks for:

### Jailbreak Tool Paths
- Cydia and package managers (`/Applications/Cydia.app`, `/private/var/lib/apt`, etc.)
- System binaries commonly found on jailbroken devices (`/bin/bash`, `/usr/sbin/sshd`, etc.)
- MobileSubstrate files (`/Library/MobileSubstrate/MobileSubstrate.dylib`)
- APT package manager files (`/etc/apt`, `/var/lib/dpkg/status`)
- Launch daemons (`/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist`)
- Palera1n rootless jailbreak indicators (`/var/jb/.installed_palera1n`, etc.)

### Detection Methods
- **Path Existence**: Checks for files and directories commonly present on jailbroken devices
- **URL Scheme Detection**: Tests if jailbreak-related URL schemes can be opened (`cydia://`, `sileo://`, `zebra://`, etc.)
- **Sandbox Violation**: Attempts to write outside the app sandbox
- **Environment Variables**: Checks for jailbreak-related environment variables
- **Symbolic Link Detection**: Looks for suspicious symbolic links
- **Process Detection**: Checks for running jailbreak-related processes

### Platform Notes
- **Simulator**: Always returns `false` — no jailbreak detection runs on simulator
- **Mac Catalyst**: Always returns `false` — macOS filesystem structure differs from iOS

### Usage Example

```dart
// Basic jailbreak detection (uses both DTTJailbreakDetection and custom detection)
bool isJailbroken = await SafeDevice.isJailBroken;

// Custom detection only (comprehensive path checking)
bool isJailbrokenCustom = await SafeDevice.isJailBrokenCustom;

// Detailed breakdown of detection methods
Map<String, dynamic> details = await SafeDevice.jailbreakDetails;
// Returns:
// {
//   "isSimulator": false,
//   "isDevelopmentEnvironment": false,
//   "hasObviousJailbreakSigns": false,
//   "dttResult": false,
//   "customResult": false,
//   "finalResult": false
// }
```

## Android Emulator Detection

Detects a wide range of Android emulators including:
- Android SDK Emulator, Genymotion
- LDPlayer, MEmu, BlueStacks, MuMu Player (NetEase), Nox, Droid4X

## Known Limitations

Root and jailbreak detection is a best-effort approach. A determined attacker using tools such as Magisk Hide or Zygisk can bypass detection. This plugin is intended as a security layer — not a guarantee.

**Device-specific handling:** Some manufacturers (Samsung, Xiaomi, Vivo) ship with system properties or Knox security components that can cause false positives. The plugin applies conservative multi-indicator checks for these brands to balance accuracy and reliability.

# Notes

#### Mock location detection

* **Android** — Location permission is required to detect mock location. The check can be disabled at runtime via config.
* **iOS** — Mock location detection is based on jailbreak/emulator status.

#### Development Mode

* Development Options in emulator is always `true` by default.

## ❗Since emulators are usually rooted, you might want to bypass these checks during development. Unless you're keen on constant false alarms ⏰
