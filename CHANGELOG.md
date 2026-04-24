## 1.3.9

* Resolved [#95](https://github.com/ufukhawk/safe_device/issues/95). Fixed `NullPointerException` crash when `isMockLocation` is called before the location listener is initialized (e.g. when `mockLocationCheckEnabled` is `false`).
* Resolved [#83](https://github.com/ufukhawk/safe_device/issues/83). Fixed GPS running continuously in background — location updates are now properly stopped when the plugin detaches from the Flutter engine.
* Resolved [#91](https://github.com/ufukhawk/safe_device/issues/91). Fixed false positive jailbreak detection on iPad apps running on macOS (Mac Catalyst). Detection now always returns `false` on Mac Catalyst.
* Resolved [#92](https://github.com/ufukhawk/safe_device/issues/92) and [#93](https://github.com/ufukhawk/safe_device/issues/93). Improved palera1n rootless jailbreak detection by adding specific indicator paths (`/var/jb/.installed_palera1n`, `/var/jb/usr/bin/su`, `/var/jb/usr/lib/apt`).
* Resolved [#85](https://github.com/ufukhawk/safe_device/issues/85). Added MuMu Player (NetEase) emulator detection.
* Resolved [#82](https://github.com/ufukhawk/safe_device/issues/82). Fixed false positive on Vivo Y11 — `isRealDevice` was incorrectly returning `false` due to an overly broad `Build.HOST` check; added Vivo and other common OEM manufacturers to the exclusion list. Applied conservative multi-indicator root detection for Vivo devices.
* Resolved [#80](https://github.com/ufukhawk/safe_device/issues/80). Fixed false positive `isJailBroken` on Samsung Galaxy Z Fold5 — Knox security system was triggering detection on non-rooted devices. Samsung devices now require multiple strong indicators before being flagged as rooted.
* iOS: Removed `/bin/sh` from jailbreak paths — this file is present on stock iOS 16+ devices and was causing false positives.
* Android: Fixed process leak in `canExecuteCommand` — `process.destroy()` is now always called.
* Android: Removed duplicate `checkTestKeys()` method (was identical to `checkBuildTags()`).
* Resolved [#86](https://github.com/ufukhawk/safe_device/issues/86). Fixed `SafeDeviceJailbreakDetection` not being called by `isJailBrokenCustom` nor `isJailBroken`.
* Resolved [#77](https://github.com/ufukhawk/safe_device/issues/77). Fixed `jailbreakDetails` method channel name.
* Added missing bool cast for `isSimulator` value in `jailbreakDetails`.

## 1.3.8
* iOS bug fix

## 1.3.6

* **Android Configurable Mock Location Detection**: The mock location check on Android is now conditional based on the configuration provided via the `init` method from Dart. If `mockLocationCheckEnabled` is set to `false`, mock location detection is disabled and location updates are not started. If no configuration is provided, the plugin behaves exactly as before for full backward compatibility.
* **iOS Config Support**: The iOS plugin now accepts and stores the configuration from Dart via the `init` method, mirroring the Android API. While iOS does not currently use the mock location flag, this enables future extensibility and API consistency.
* Bug fix for emulator.

### Technical Details
- Added `SafeDeviceConfig` class, served to both Platform to include `mockLocationCheckEnabled` and future possible configuration
- Added `init` method to both Android and iOS native plugins to receive and store configuration from Dart.
- Android: Location updates and mock location checks are only started if enabled in config.
- iOS: Configuration is stored for future use, since the only configuration available now is for mock location check which is not supported on iOS.

## 1.3.4 

- **CRITICAL**: Fixed false positive root detection on real Android devices (especially Xiaomi/Redmi devices)
- Removed normal Android system files from emulator root detection that were causing false positives
- Fixed `emulatorSpecificRoot` check to only apply to actual emulators, not real devices
- Improved Xiaomi/Redmi/POCO device support with more conservative root detection

### Changed
- Emulator-specific root checks now only run on actual emulators, not real devices
- Xiaomi/Redmi/POCO devices now use more conservative root detection methods
- Removed false positive triggers: `/system/bin/app_process32`, `/system/bin/debuggerd`, `/system/bin/debuggerd64`, `/system/bin/rild`, `/proc/1/maps`, `/system/recovery-from-boot.p`, `/system/etc/security/otacerts.zip`

### Technical Details
- Added `isLikelyEmulator()` method to properly identify emulators before applying emulator-specific checks
- Xiaomi devices now require multiple strong indicators (obvious root signs + basic check + su binary) before being flagged as rooted
- Better separation between emulator detection and real device root detection

## 1.3.3

* **CRITICAL iOS SECURITY FIX**: Resolved false positive jailbreak detection in development environment that affected real devices.
* **Development Environment Detection**: Added intelligent detection to distinguish between legitimate development variables and actual jailbreak indicators.
* **DYLD_INSERT_LIBRARIES Fix**: Fixed false positive caused by Apple's legitimate development environment variables (DYLD_INSERT_LIBRARIES).
* **Real Device Accuracy**: iPhone 16 Pro Max, iPhone SE, and other real devices now correctly return `false` for jailbreak detection during development.
* **Platform Consistency**: Resolved discrepancy where macOS development showed `true` while Windows development showed `false`.
* **Type Safety Fix**: Fixed `Map<Object?, Object?>` casting error in `jailbreakDetails` method.
* **Enhanced Debug Info**: Added comprehensive debugging information including development environment status, legitimate environment variables, and DTT library results.
* **Smart Filtering**: Added filtering for legitimate Apple framework paths in DYLD_INSERT_LIBRARIES.
* **Production Safety**: Maintains full jailbreak detection accuracy in production while being lenient in development.
* **API Change**: `jailbreakDetails` now returns `Map<String, dynamic>` instead of `Map<String, bool>` for better debugging info.

## 1.3.2

* **Major Architecture Change**: Converted iOS jailbreak detection from Swift to Objective-C for complete build stability.
* **Eliminated All Bridging Issues**: Removed all Swift-Objective-C bridging dependencies that caused compilation errors.
* **Simplified iOS Build**: No more Swift compiler requirements, bridging headers, or module configurations needed.
* **Complete Type Safety**: Direct Objective-C implementation eliminates type conversion issues between Swift and Dart.
* **Enhanced Compatibility**: Works across all iOS project configurations without custom build settings.
* **Performance Improvement**: Direct Objective-C calls eliminate runtime class resolution overhead.
* **Same Functionality**: All 20+ jailbreak detection methods preserved with identical behavior.
* **Bug Fix**: Permanently resolved all Swift-related build errors including bridging header and linker issues.

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


