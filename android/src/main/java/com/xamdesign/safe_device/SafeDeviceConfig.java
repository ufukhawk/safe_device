package com.xamdesign.safe_device;


import java.util.Map;

public class SafeDeviceConfig {
    private boolean mockLocationCheckEnabled;

    public SafeDeviceConfig(boolean mockLocationCheckEnabled) {
        this.mockLocationCheckEnabled = mockLocationCheckEnabled;
    }

    public SafeDeviceConfig(Map<String, Object> map) {
        this.mockLocationCheckEnabled = (boolean) map.get("mockLocationCheckEnabled");
    }   
    public boolean isMockLocationCheckEnabled() {
        return mockLocationCheckEnabled;
    }

}