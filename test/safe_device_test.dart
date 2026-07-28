import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_device/safe_device.dart';

void main() {
  const MethodChannel channel = MethodChannel('safe_device');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    final binaryMessenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    binaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    final binaryMessenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    binaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    //expect(await SafeDevice.platformVersion, '42');
  });

  test('isVpnEnabled forwards the platform call', () async {
    final binaryMessenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    binaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'init') {
        return null;
      }
      if (methodCall.method == 'isVpnEnabled') {
        return true;
      }
      return null;
    });

    expect(await SafeDevice.isVpnEnabled(), isTrue);
  });
}
