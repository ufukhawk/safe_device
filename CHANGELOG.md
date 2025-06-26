## 1.3.1

* **iOS Build Fix**: Resolved Swift bridging header compilation issues that caused build failures.
* **Swift Integration Improvement**: Replaced compile-time Swift header imports with runtime class resolution for better compatibility.
* **Podspec Optimization**: Simplified iOS podspec configuration to prevent bridging header path conflicts.
* **Enhanced Swift-Objective-C Interoperability**: Added `@objcMembers` annotation for automatic method exposure.
* **Bug Fix**: Fixed "Build input file cannot be found: safe_device-Bridging-Header.h" error.
* **Bug Fix**: Resolved "Undefined symbol: _OBJC_CLASS_$_SafeDeviceJailbreakDetection" linker error.

## 1.3.0

* **Enhanced Android Emulator Detection**: Improved detection for popular Android emulators including LDPlayer, MEmu, BlueStacks.
* **LDPlayer Detection**: Added specific detection for LDPlayer emulator with brand, model, and file-based checks.
* **Enhanced Root Detection**: Improved root detection for emulators with additional checks for:
  - Test-keys in build tags
  - Emulator-specific root files
  - Enhanced su binary detection
  - Dangerous system properties (ro.debuggable, ro.secure, service.adb.root)
* **Architecture Detection**: Added enhanced x86/i686 architecture detection for emulator identification.
* **Bug Fix**: Resolved issue where rooted LDPlayer was not properly detected as both emulator and rooted device.
* **Enhanced iOS Jailbreak Detection**: Implemented comprehensive custom jailbreak detection for iOS.
* **New Swift Implementation**: Added `SafeDeviceJailbreakDetection` class with advanced detection methods.
* **Expanded Path Checking**: Added detection for 20+ additional jailbreak-related paths including:
  - Cydia and package managers (`/Applications/Cydia.app`, `/private/var/lib/apt`, etc.)
  - System binaries (`/bin/bash`, `/usr/sbin/sshd`, `/usr/libexec/ssh-keysign`, etc.)
  - MobileSubstrate files (`/Library/MobileSubstrate/MobileSubstrate.dylib`)
  - Launch daemons (`/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist`)
* **Multiple Detection Methods**: Added URL scheme detection, sandbox violation testing, environment variable checking, and symbolic link detection.
* **New API Methods**:
  - `isJailBrokenCustom`: iOS-only method using custom detection algorithm
  - `jailbreakDetails`: Returns detailed breakdown of detection methods
* **Improved Reliability**: Enhanced main `isJailBroken` method now combines DTTJailbreakDetection with custom detection.
* **Swift 5.0 Support**: Updated podspec to support modern Swift development.
* **Updated Example App**: Enhanced example to demonstrate new jailbreak detection features.
* **Bug Fix**: Resolved Swift pod integration issue by adding modular headers support for DTTJailbreakDetection dependency.
* **Bug Fix**: Fixed iOS Simulator false positive detection - custom jailbreak detection now correctly returns false on simulator environment.

## 1.2.1

* Upgraded rootbeer-lib dependency from version 0.1.0 to 0.1.1.
* Corrected the activity name in AndroidManifest.xml from 'MainActivityvvvv' to 'MainActivity'.

## 1.2.0

* Updated android code for better performance.
* Bug Fixes.

## 1.1.9

* Removed the Permission Handler package.
* Updated the example code.
* Upgraded the iOS platform version.
* Updated the Dart version.
* Added location permission request for iOS.
* Integrated Geolocator package for handling location permissions.

## 1.1.8

* Disable RootBear logs
* Sony devices bug fix.

## 1.1.7

* upload build.gradle file for Gradle 8

## 1.1.6

* Update Readme
* Downgrade min dart version
* format code

## 1.1.5

* Removed trust_location package.
* Updated Flutter and Dart version.
* Updated Gradle version.

## 1.1.4

* Bug Fix

## 1.1.3

* Updated Flutter and Dart version.
* Changed location permission request package.

## 1.1.1

* Added development mode for Android.

## 1.1.0

* Android detect root bug fix.

## 1.0.9

* Android mock location error solved.

## 1.0.8

* Android v2 error solved.

## 1.0.7

* Emulator detection error solved.

## 1.0.6

* Mock Location detection error solved.

## 1.0.5

* 'Example' codes in the project have been edited and location permission request has been added for
  Mock Location control.

## 1.0.4

* Small Changes.

## 1.0.3

* iOS bug fix.

## 1.0.2

* iOS bug fix.

## 1.0.1

* Small Changes.

## 1.0.0

* Flutter Jailbroken, root, emulator and mock location detection.


