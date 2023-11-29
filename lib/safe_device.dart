import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:trust_location/trust_location.dart';

class SafeDevice {
  static const MethodChannel _channel = const MethodChannel('safe_device');

  //Checks whether device JailBroken on iOS/Android?
  static Future<bool> get isJailBroken async {
    final bool isJailBroken = await _channel.invokeMethod('isJailBroken');
    return isJailBroken;
  }

  //Can this device mock location - no need to root!
  static Future<bool> get canMockLocation async {
    if (Platform.isAndroid) {
      return await TrustLocation.isMockLocation;
    } else {
      return !await isRealDevice || await isJailBroken;
    }
  }

  // Checks whether device is real or emulator
  static Future<bool> get isRealDevice async {
    final bool isRealDevice = await _channel.invokeMethod('isRealDevice');
    return isRealDevice;
  }

  // (ANDROID ONLY) Check if application is running on external storage
  static Future<bool> get isOnExternalStorage async {
    final bool isOnExternalStorage =
        await _channel.invokeMethod('isOnExternalStorage');
    return isOnExternalStorage;
  }

  // Check if device violates any of the above
  static Future<bool> get isSafeDevice async {
    final bool isJailBroken = await _channel.invokeMethod('isJailBroken');
    final bool isRealDevice = await _channel.invokeMethod('isRealDevice');
    final bool canMockLocation = await SafeDevice.canMockLocation;
    if (Platform.isAndroid) {
      final bool isOnExternalStorage =
          await _channel.invokeMethod('isOnExternalStorage');
      return isJailBroken ||
              canMockLocation ||
              !isRealDevice ||
              isOnExternalStorage == true
          ? false
          : true;
    } else {
      return isJailBroken || !isRealDevice || canMockLocation;
    }
  }

  // (ANDROID ONLY) Check if development Options is enable on device
  static Future<bool> get isDevelopmentModeEnable async {
    if (Platform.isIOS) return false;
    final bool isDevelopmentModeEnable =
        await _channel.invokeMethod('isDevelopmentModeEnable');
    return isDevelopmentModeEnable;
  }

  // (ANDROID ONLY) Check if development Options is enable on device
  static Future<bool> get usbDebuggingCheck async {
    if (Platform.isIOS) return false;
    final bool usbDebuggingCheck =
        await _channel.invokeMethod('usbDebuggingCheck');
    return usbDebuggingCheck;
  }
}
