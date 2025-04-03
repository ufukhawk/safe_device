import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:safe_device/safe_device_config.dart';

class SafeDevice {
  static const MethodChannel _channel = const MethodChannel('safe_device');

  static Future<void> init(SafeDeviceConfig config) async {
    try {
      await _channel.invokeMethod('init', config.toMap());
    } catch (e) {
      print('Error initializing SafeDevice: $e');
    }
  }

  // Checks whether device is JailBroken (iOS) or Rooted (Android)
  static Future<bool> get isJailBroken async {
    try {
      final bool isJailBroken = await _channel.invokeMethod('isJailBroken');
      return isJailBroken;
    } catch (e) {
      print('Error checking JailBroken status: $e');
      return false;
    }
  }

  // Can this device mock location - no need to root!
  static Future<bool> get isMockLocation async {
    try {
      if (Platform.isAndroid) {
        final bool isMockLocation =
            await _channel.invokeMethod('isMockLocation');
        return isMockLocation;
      } else {
        return !await isRealDevice || await isJailBroken;
      }
    } catch (e) {
      print('Error checking MockLocation status: $e');
      return false;
    }
  }

  // Checks whether the device is real or an emulator
  static Future<bool> get isRealDevice async {
    try {
      final bool isRealDevice = await _channel.invokeMethod('isRealDevice');
      return isRealDevice;
    } catch (e) {
      print('Error checking RealDevice status: $e');
      return false;
    }
  }

  // (ANDROID ONLY) Check if the application is running on external storage
  static Future<bool> get isOnExternalStorage async {
    if (Platform.isIOS) return false;
    try {
      final bool isOnExternalStorage =
          await _channel.invokeMethod('isOnExternalStorage');
      return isOnExternalStorage;
    } catch (e) {
      print('Error checking ExternalStorage status: $e');
      return false;
    }
  }

  // Check if device violates any of the above conditions
  static Future<bool> get isSafeDevice async {
    try {
      final bool jailBroken = await isJailBroken;
      final bool realDevice = await isRealDevice;
      final bool mockLocation = await isMockLocation;
      final bool onExternalStorage =
          Platform.isAndroid ? await isOnExternalStorage : false;

      return !(jailBroken || mockLocation || !realDevice || onExternalStorage);
    } catch (e) {
      print('Error checking SafeDevice status: $e');
      return false;
    }
  }

  // (ANDROID ONLY) Check if Development Options is enabled on the device
  static Future<bool> get isDevelopmentModeEnable async {
    if (Platform.isIOS) return false;
    try {
      final bool isDevModeEnabled =
          await _channel.invokeMethod('isDevelopmentModeEnable');
      return isDevModeEnabled;
    } catch (e) {
      print('Error checking DevelopmentMode status: $e');
      return false;
    }
  }

  // (ANDROID ONLY) Check if USB Debugging is enabled on the device
  static Future<bool> get isUsbDebuggingEnabled async {
    if (Platform.isIOS) return false;
    try {
      final bool usbDebuggingEnabled =
          await _channel.invokeMethod('usbDebuggingCheck');
      return usbDebuggingEnabled;
    } catch (e) {
      print('Error checking USB Debugging status: $e');
      return false;
    }
  }
}
