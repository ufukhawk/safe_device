import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:safe_device/safe_device.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isJailBroken = false;
  bool canMockLocation = false;
  bool isRealDevice = true;
  bool isOnExternalStorage = false;
  bool isSafeDevice = false;
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    PermissionStatus permission =
        await LocationPermissions().requestPermissions();

    if (!mounted) return;
    try {
      isJailBroken = await SafeDevice.isJailBroken;
      canMockLocation = await SafeDevice.canMockLocation;
      isRealDevice = await SafeDevice.isRealDevice;
      isOnExternalStorage = await SafeDevice.isOnExternalStorage;
      isSafeDevice = await SafeDevice.isSafeDevice;
    } catch (error) {
      print(error);
    }

    setState(() {
      isJailBroken = isJailBroken;
      canMockLocation = canMockLocation;
      isRealDevice = isRealDevice;
      isOnExternalStorage = isOnExternalStorage;
      isSafeDevice = isSafeDevice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Device Safe check'),
        ),
        body: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('isJailBroken():'),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '${isJailBroken ? "Yes" : "No"}',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('canMockLocation():'),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '${canMockLocation ? "Yes" : "No"}',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('isRealDevice():'),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '${isRealDevice ? "Yes" : "No"}',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('isOnExternalStorage():'),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '${isOnExternalStorage ? "Yes" : "No"}',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('isSafeDevice():'),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '${isSafeDevice ? "Yes" : "False"}',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
