package com.xamdesign.safe_device;

public class SafeDeviceConfig {
    private boolean locationUpdateEnabled;

    public SafeDeviceConfig(boolean locationUpdateEnabled) {
        this.locationUpdateEnabled = locationUpdateEnabled;
    }

    public boolean isLocationUpdateEnabled() {
        return locationUpdateEnabled;
    }
}
