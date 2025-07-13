import 'dart:async';
import 'dart:io';

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
  bool isJailBrokenCustom = false;
  bool isMockLocation = false;
  bool isRealDevice = false;
  bool isOnExternalStorage = false;
  bool isSafeDevice = false;
  bool isDevelopmentModeEnable = false;
  Map<String, dynamic> jailbreakDetails = {};
  Map<String, dynamic> rootDetectionDetails = {};

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;

    setState(() {
      isJailBroken = false;
      isJailBrokenCustom = false;
      isMockLocation = false;
      isRealDevice = false;
      isOnExternalStorage = false;
      isSafeDevice = false;
      isDevelopmentModeEnable = false;
      jailbreakDetails = {};
      rootDetectionDetails = {};
    });

    isJailBroken = await SafeDevice.isJailBroken;
    isMockLocation = await SafeDevice.isMockLocation;
    isRealDevice = await SafeDevice.isRealDevice;
    isOnExternalStorage = await SafeDevice.isOnExternalStorage;
    isSafeDevice = await SafeDevice.isSafeDevice;
    isDevelopmentModeEnable = await SafeDevice.isDevelopmentModeEnable;

    // iOS-specific enhanced jailbreak detection
    if (Platform.isIOS) {
      isJailBrokenCustom = await SafeDevice.isJailBrokenCustom;
      jailbreakDetails = await SafeDevice.jailbreakDetails;
    }

    // Android-specific enhanced root detection debugging
    if (Platform.isAndroid) {
      rootDetectionDetails = await SafeDevice.rootDetectionDetails;
    }

    setState(() {
      this.isJailBroken = isJailBroken;
      this.isJailBrokenCustom = isJailBrokenCustom;
      this.isMockLocation = isMockLocation;
      this.isRealDevice = isRealDevice;
      this.isOnExternalStorage = isOnExternalStorage;
      this.isSafeDevice = isSafeDevice;
      this.isDevelopmentModeEnable = isDevelopmentModeEnable;
      this.jailbreakDetails = jailbreakDetails;
      this.rootDetectionDetails = rootDetectionDetails;
    });
  }

  Widget buildInfoRow(String key, bool value) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              key,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Text(
            value.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: value ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildJailbreakDetailsSection() {
    if (jailbreakDetails.isEmpty) return Container();

    return Column(
      children: [
        Divider(),
        Text(
          'Jailbreak Detection Details (iOS)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        if (jailbreakDetails.containsKey('isSimulator'))
          Card(
            color: jailbreakDetails['isSimulator'] == true
                ? Colors.blue.shade50
                : null,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: buildInfoRow(
                  'isSimulator', jailbreakDetails['isSimulator'] ?? false),
            ),
          ),
        ...jailbreakDetails.entries
            .where((entry) => entry.key != 'isSimulator')
            .map((entry) => buildInfoRow(
                '${entry.key}', entry.value is bool ? entry.value : false))
            .toList(),
      ],
    );
  }

  Widget buildRootDetectionDetailsSection() {
    if (rootDetectionDetails.isEmpty) return Container();

    return Column(
      children: [
        Divider(),
        Text(
          'Root Detection Details (Android)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        // Device information
        if (rootDetectionDetails.containsKey('brand'))
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Device Info:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Brand: ${rootDetectionDetails['brand']}'),
                  Text('Model: ${rootDetectionDetails['model']}'),
                  Text('API Level: ${rootDetectionDetails['apiLevel']}'),
                  Text('Build Type: ${rootDetectionDetails['buildType']}'),
                  Text('Build Tags: ${rootDetectionDetails['buildTags']}'),
                ],
              ),
            ),
          ),
        SizedBox(height: 8),
        // Detection results
        ...rootDetectionDetails.entries
            .where((entry) => entry.value is bool)
            .map((entry) => buildInfoRow('${entry.key}', entry.value))
            .toList(),
        // System properties
        if (rootDetectionDetails.containsKey('ro.debuggable'))
          Card(
            color: Colors.orange.shade50,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('System Properties:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                      'ro.debuggable: ${rootDetectionDetails['ro.debuggable']}'),
                  Text('ro.secure: ${rootDetectionDetails['ro.secure']}'),
                  Text(
                      'service.adb.root: ${rootDetectionDetails['service.adb.root']}'),
                  Text(
                      'ro.build.type: ${rootDetectionDetails['ro.build.type']}'),
                  Text(
                      'ro.build.tags: ${rootDetectionDetails['ro.build.tags']}'),
                ],
              ),
            ),
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
        body: SingleChildScrollView(
          child: Center(
            child: Card(
              margin: EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    buildInfoRow('isJailBroken()', isJailBroken),
                    if (Platform.isIOS) ...[
                      buildInfoRow('isJailBrokenCustom()', isJailBrokenCustom),
                    ],
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
                    if (Platform.isIOS) buildJailbreakDetailsSection(),
                    if (Platform.isAndroid) buildRootDetectionDetailsSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
