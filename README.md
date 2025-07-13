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

<p>
    <a href="https://codecanyon.net/item/flutter-puff-image-to-pdf/50878345">
        <img
            src="https://market-resized.envatousercontent.com/codecanyon.net/files/488429966/puffimagetopdf.png?auto=format&amp;q=94&amp;cf_fit=crop&amp;gravity=top&amp;h=8000&amp;w=590&amp;s=472d0ca2296e36cb0cfd0ac5d1013fbef09c33c1d0e8edc2917d06166bee7deb"
            alt="Flutter Puff Image to PDF"
            border="0"
        />
    </a>
    <a href="https://codecanyon.net/item/flutter-xam-shoe-pro-ecommerce-apple-watch/46897280">
        <img
            src="https://market-resized.envatousercontent.com/codecanyon.net/files/479757433/xamshoespro.png?auto=format&amp;q=94&amp;cf_fit=crop&amp;gravity=top&amp;h=8000&amp;w=590&amp;s=6083fab314fe2c660c1331d7e28d17df6c552d65b4fde325d33d4497f943d238"
            alt="Flutter Xam Shoe Pro eCommerce + Apple Watch"
            border="0"
        />
    </a>
    <a href="https://codecanyon.net/item/flutter-xam-shoe-commerce-app-flutter/46724667">
        <img
            src="https://market-resized.envatousercontent.com/codecanyon.net/files/479757459/xamshoes.png?auto=format&amp;q=94&amp;cf_fit=crop&amp;gravity=top&amp;h=8000&amp;w=590&amp;s=647f044cd3e37bc9b1475f3fbb105bc6feab7173dc913ebb08020127fd5589b6"
            alt="Flutter Xam Shoe Commerce App - Flutter"
            border="0"
        />
    </a>
    <a href="https://codecanyon.net/item/flutter-fruit-market-app-in-flutter-mobilewebtablet/33060290">
        <img
            src="https://market-resized.envatousercontent.com/codecanyon.net/files/479757499/nova.png?auto=format&amp;q=94&amp;cf_fit=crop&amp;gravity=top&amp;h=8000&amp;w=590&amp;s=c4232417f3bd678fafa5cb936030a35c3dfdc3d697e748c9c4466add67718879"
            border="0"
        />
    </a>
    <a href="https://codecanyon.net/item/flutter-govo-travel-app-in-flutter/29883635">
        <img
            src="https://market-resized.envatousercontent.com/codecanyon.net/files/479757536/govo.png?auto=format&amp;q=94&amp;cf_fit=crop&amp;gravity=top&amp;h=8000&amp;w=590&amp;s=62df117e21adfd060100ba9d77b201c8db63812c8686bb0a66b7204b47579b31"
            alt="Govo Travel Application - Flutter (Android &amp; iOS)"
            border="0"
        />
    </a>
    <a href="https://codecanyon.net/item/flutter-dellyshop-ecommerce-app/28804937">
        <img
            src="https://market-resized.envatousercontent.com/codecanyon.net/files/479757550/delly.png?auto=format&amp;q=94&amp;cf_fit=crop&amp;gravity=top&amp;h=8000&amp;w=590&amp;s=52e241eecfd1198ea9b666274d21b576434f8df30cfc2170eaf684d6e83dd15d"
            alt="DellyShop eCommerce Application - Flutter (Android &amp; iOS)"
            border="0"
        />
    </a>

</p>



