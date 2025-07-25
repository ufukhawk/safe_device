# safe_device (Null-Safety)

<a href="https://pub.dev/packages/safe_device"><img src="https://img.shields.io/badge/pub-1.3.4-blue" alt="Safe Device" height="18"></a>
<img src="https://imgur.com/Vw4Z93n.png" alt="Safe Device">
Flutter (Null-Safety) Jailbroken, root, emulator and mock location detection.

## Getting Started

In your flutter project add the dependency:

```yml
dependencies:
...
  safe_device: ^1.3.4
```

## Usage

#### Importing package

```
import 'package:safe_device/safe_device.dart';
```

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

Can this device mock location - no need to root!

```
bool isMockLocation = await SafeDevice.isMockLocation;
```

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

The plugin now includes enhanced jailbreak detection for iOS with comprehensive path checking. The custom detection method checks for:

### Jailbreak Tool Paths
- Cydia and package managers (`/Applications/Cydia.app`, `/private/var/lib/apt`, etc.)
- System binaries commonly found on jailbroken devices (`/bin/bash`, `/usr/sbin/sshd`, etc.)
- MobileSubstrate files (`/Library/MobileSubstrate/MobileSubstrate.dylib`)
- APT package manager files (`/etc/apt`, `/var/lib/dpkg/status`)
- Launch daemons (`/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist`)

### Detection Methods
- **Path Existence**: Checks for files and directories commonly present on jailbroken devices
- **URL Scheme Detection**: Tests if jailbreak-related URL schemes can be opened
- **Sandbox Violation**: Attempts to write outside the app sandbox
- **Environment Variables**: Checks for jailbreak-related environment variables
- **Symbolic Link Detection**: Looks for suspicious symbolic links
- **Process Detection**: Checks for running jailbreak-related processes

### Usage Example

```dart
// Basic jailbreak detection (uses both DTTJailbreakDetection and custom detection)
bool isJailbroken = await SafeDevice.isJailBroken;

// Custom detection only (comprehensive path checking)
bool isJailbrokenCustom = await SafeDevice.isJailBrokenCustom;

// Detailed breakdown of detection methods
Map<String, bool> details = await SafeDevice.jailbreakDetails;
// Returns:
// {
//   "hasPaths": false,
//   "canOpenSchemes": false,
//   "canViolateSandbox": false,
//   "hasEnvironmentVariables": false,
//   "hasSuspiciousSymlinks": false,
//   "hasJailbreakProcesses": false
// }
```

# Note:

#### Mock location detection

* **Android** - Location permission needs to be granted in app in order to detect mock location
  properly
* **iOS** - For now we are checking if device is Jail Broken or if it's not real device. There is no
  strong detection of mock location in iOS *(Open the PR if you have better way for mock location
  detection in iOS)*

### DevelopmentMode

* -Development Options in emulator always is true for default

## ❗Since emulators are usually rooted, you might want to bypass these checks during development. Unless you're keen on constant false alarms ⏰
