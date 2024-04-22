# safe_device (Null-Safety)

<a href="https://pub.dev/packages/safe_device"><img src="https://img.shields.io/badge/pub-1.1.6-blue" alt="Safe Device" height="18"></a>
<img src="https://imgur.com/Vw4Z93n.png" alt="Safe Device">
Flutter (Null-Safety) Jailbroken, root, emulator and mock location detection.

## Getting Started

In your flutter project add the dependency:

```yml
dependencies:
...
  safe_device: ^1.1.7
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

<a href="https://codecanyon.net/item/flutter-puff-image-to-pdf/50878345"><img src="https://codecanyon.img.customer.envatousercontent.com/files/488429966/puffimagetopdf.png?auto=compress%2Cformat&q=80&fit=crop&crop=top&max-h=8000&max-w=590&s=08560417a799c30ac6acda7312f25dfb" alt="Flutter Puff Image to PDF" border="0" />
</a>

<a href="https://codecanyon.net/item/flutter-xam-shoe-pro-ecommerce-apple-watch/46897280"><img src="https://codecanyon.img.customer.envatousercontent.com/files/458084248/xamshoespro_main.png?auto=compress%2Cformat&q=80&fit=crop&crop=top&max-h=8000&max-w=590&s=57d3c96fde1fb475fd6708083e41f3d1c" alt="Flutter Xam Shoe Pro eCommerce + Apple Watch" border="0" /></a>

<a href="https://codecanyon.net/item/flutter-xam-shoe-commerce-app-flutter/46724667"><img src="https://codecanyon.img.customer.envatousercontent.com/files/456850008/xamshoes_main.png?auto=compress%2Cformat&q=80&fit=crop&crop=top&max-h=8000&max-w=590&s=67b35618901612d1d113f7eb91818adc" alt="Flutter Xam Shoe Commerce App - Flutter" border="0" />

<a href="https://codecanyon.net/item/flutter-fruit-market-app-in-flutter-mobilewebtablet/33060290"><img src="https://codecanyon.img.customer.envatousercontent.com/files/347934322/nova_main.png?auto=compress%2Cformat&q=80&fit=crop&crop=top&max-h=8000&max-w=590&s=af3e47818bfab193408bda2305bd9ed0.png" alt="Flutter Login Ui Kit in Flutter 2.0 (Desktop,Web, iOS, Android)" border="0" /></a>

<a href="https://codecanyon.net/item/flutter-login-ui-kit-in-flutter-20-ios-android-desktop-web/31406951"><img border="0" alt="Flutter Login Ui Kit in Flutter 2.0 (Desktop,Web, iOS, Android)" src="https://codecanyon.img.customer.envatousercontent.com/files/331910835/Flutter_login_ui_kit.png?auto=compress%2Cformat&q=80&fit=crop&crop=top&max-h=8000&max-w=590&s=b17534f543079295c3c8754fa4a5c9cf.png"></a>

<a href="https://codecanyon.net/item/flutter-govo-travel-app-in-flutter/29883635"><img border="0" alt="Govo Travel Application - Flutter (Android & iOS)" src="https://codecanyon.img.customer.envatousercontent.com/files/345338996/govo2.png?auto=compress%2Cformat&q=80&fit=crop&crop=top&max-h=8000&max-w=590&s=b43d49708656a7ba0a48c7fb5777b693.png"></a>

<a href="https://codecanyon.net/item/flutter-dellyshop-ecommerce-app/28804937"><img border="0" alt="DellyShop eCommerce Application - Flutter (Android & iOS)" src="https://codecanyon.img.customer.envatousercontent.com/files/308327237/DellyShopFlutterPromo.png?auto=compress%2Cformat&q=80&fit=crop&crop=top&max-h=8000&max-w=590&s=5447666419ae5503483811bec97d80dc.png"></a>

<a href="https://codecanyon.net/item/flutter-dellyshop-ecommerce-app/28804937"><img border="0" alt="Xamarin XamUI Login Pages UI Kit 2 | Xamarin Forms" src="https://codecanyon.img.customer.envatousercontent.com/files/312189232/wnvatopromo.png?auto=compress%2Cformat&q=80&fit=crop&crop=top&max-h=8000&max-w=590&s=a9d3331d604324ff0de0b6fa8b5ebcb1.png"></a>

<a href="https://codecanyon.net/item/flutter-dellyshop-ecommerce-app/28804937"><img border="0" alt="Xamarin XamUI Login Pages UI Kit 2 | Xamarin Forms" src="https://codecanyon.img.customer.envatousercontent.com/files/312189232/wnvatopromo.png?auto=compress%2Cformat&q=80&fit=crop&crop=top&max-h=8000&max-w=590&s=a9d3331d604324ff0de0b6fa8b5ebcb1.png"></a>


