# safe_device (Null-Safety)

<a href="https://pub.dev/packages/safe_device"><img src="https://img.shields.io/badge/pub-1.1.9-blue" alt="Safe Device" height="18"></a>
<img src="https://imgur.com/Vw4Z93n.png" alt="Safe Device">
Flutter (Null-Safety) Jailbroken, root, emulator and mock location detection.

## Getting Started

In your flutter project add the dependency:

```yml
dependencies:
...
  safe_device: ^1.1.9
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

<a href="https://codecanyon.net/item/flutter-puff-image-to-pdf/50878345"><img src="https://market-resized.envatousercontent.com/codecanyon.net/files/488429966/puffimagetopdf.png?auto=format&q=94&cf_fit=crop&gravity=top&h=8000&w=590&s=da4085a658c9566524df2de171d65f19fcf1d3457226bce78b8b0f7cd7f5602f" alt="Flutter Puff Image to PDF" border="0" />
</a>

<a href="https://codecanyon.net/item/flutter-xam-shoe-pro-ecommerce-apple-watch/46897280"><img src="https://market-resized.envatousercontent.com/codecanyon.net/files/479757433/xamshoespro.png?auto=format&q=94&cf_fit=crop&gravity=top&h=8000&w=590&s=3df71ce9635eee6a94ac96a83a57d97795e85d93ba42d910c01267993cd43048" alt="Flutter Xam Shoe Pro eCommerce + Apple Watch" border="0" /></a>

<a href="https://codecanyon.net/item/flutter-xam-shoe-commerce-app-flutter/46724667"><img src="https://market-resized.envatousercontent.com/codecanyon.net/files/479757459/xamshoes.png?auto=format&q=94&cf_fit=crop&gravity=top&h=8000&w=590&s=99c0e1f800b3683e88bf420c747ef0ee25af1e27d15894cc83b6098d00025daa" alt="Flutter Xam Shoe Commerce App - Flutter" border="0" />

<a href="https://codecanyon.net/item/flutter-fruit-market-app-in-flutter-mobilewebtablet/33060290"><img src="https://market-resized.envatousercontent.com/codecanyon.net/files/479757499/nova.png?auto=format&q=94&cf_fit=crop&gravity=top&h=8000&w=590&s=6481b0a45fd7200dd3c5e74161d26362ea268ea8f694e060ba2cb5e3e95b8fba" alt="Flutter Login Ui Kit in Flutter 2.0 (Desktop,Web, iOS, Android)" border="0" /></a>

<a href="https://codecanyon.net/item/flutter-login-ui-kit-in-flutter-20-ios-android-desktop-web/31406951"><img border="0" alt="Flutter Login Ui Kit in Flutter 2.0 (Desktop,Web, iOS, Android)" src="https://market-resized.envatousercontent.com/codecanyon.net/files/331910835/Flutter_login_ui_kit.png?auto=format&q=94&cf_fit=crop&gravity=top&h=8000&w=590&s=4a35293b78a28766e8453025c40cd67ddd0204407e315034258e9b1d29e5e73d"></a>

<a href="https://codecanyon.net/item/flutter-govo-travel-app-in-flutter/29883635"><img border="0" alt="Govo Travel Application - Flutter (Android & iOS)" src="https://market-resized.envatousercontent.com/codecanyon.net/files/479757536/govo.png?auto=format&q=94&cf_fit=crop&gravity=top&h=8000&w=590&s=2bfa9d1be94fb4cd42199131c8bc5d5cffb51dee97c18ebf5641f04a7413dcad"></a>

<a href="https://codecanyon.net/item/flutter-dellyshop-ecommerce-app/28804937"><img border="0" alt="DellyShop eCommerce Application - Flutter (Android & iOS)" src="https://market-resized.envatousercontent.com/codecanyon.net/files/479757550/delly.png?auto=format&q=94&cf_fit=crop&gravity=top&h=8000&w=590&s=66e1394c870530ebace5f734c58e479693c2c5b3fb8980a856a797c49a7c3f89"></a>

<a href="https://codecanyon.net/item/flutter-dellyshop-ecommerce-app/28804937"><img border="0" alt="Xamarin XamUI Login Pages UI Kit 2 | Xamarin Forms" src="https://codecanyon.img.customer.envatousercontent.com/files/312189232/wnvatopromo.png?auto=compress%2Cformat&q=80&fit=crop&crop=top&max-h=8000&max-w=590&s=a9d3331d604324ff0de0b6fa8b5ebcb1.png"></a>

<a href="https://codecanyon.net/item/flutter-dellyshop-ecommerce-app/28804937"><img border="0" alt="Xamarin XamUI Login Pages UI Kit 2 | Xamarin Forms" src="https://codecanyon.img.customer.envatousercontent.com/files/312189232/wnvatopromo.png?auto=compress%2Cformat&q=80&fit=crop&crop=top&max-h=8000&max-w=590&s=a9d3331d604324ff0de0b6fa8b5ebcb1.png"></a>


