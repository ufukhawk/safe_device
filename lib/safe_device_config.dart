class SafeDeviceConfig {
  final bool mockLocationCheckEnabled;

  const SafeDeviceConfig({this.mockLocationCheckEnabled = true});

  Map<String, dynamic> toMap() {
    return {
      'mockLocationCheckEnabled': mockLocationCheckEnabled,
    };
  }
}