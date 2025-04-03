class SafeDeviceConfig {
  const SafeDeviceConfig({
    this.locationUpdateEnabled = true,
  });

  final bool locationUpdateEnabled;

  Map<String, dynamic> toMap() => {
        'locationUpdateEnabled': locationUpdateEnabled,
      };
}
