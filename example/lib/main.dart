import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safe_device/safe_device.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isJailBroken = false;
  bool isMockLocation = false;
  bool isRealDevice = false;
  bool isOnExternalStorage = false;
  bool isSafeDevice = false;
  bool isDevelopmentModeEnable = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    try {
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }
      isJailBroken = await SafeDevice.isJailBroken;
      isMockLocation = await SafeDevice.isMockLocation;
      isRealDevice = await SafeDevice.isRealDevice;
      isOnExternalStorage = await SafeDevice.isOnExternalStorage;
      isSafeDevice = await SafeDevice.isSafeDevice;
      isDevelopmentModeEnable = await SafeDevice.isDevelopmentModeEnable;
      setState(() {});
    } catch (error) {
      print(error);
    }
  }

  Widget buildInfoRow(String label, bool value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('$label:'),
        SizedBox(width: 8),
        Text(
          value ? "Yes" : "No",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Device Safe Check'),
        ),
        body: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  buildInfoRow('isJailBroken()', isJailBroken),
                  SizedBox(height: 8),
                  buildInfoRow('isMockLocation()', isMockLocation),
                  SizedBox(height: 8),
                  buildInfoRow('isRealDevice()', isRealDevice),
                  SizedBox(height: 8),
                  buildInfoRow('isOnExternalStorage()', isOnExternalStorage),
                  SizedBox(height: 8),
                  buildInfoRow('isSafeDevice()', isSafeDevice),
                  SizedBox(height: 8),
                  buildInfoRow(
                      'isDevelopmentModeEnable()', isDevelopmentModeEnable),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
