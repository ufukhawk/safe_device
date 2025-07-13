package com.xamdesign.safe_device;

import android.content.Context;
import android.location.Location;

import androidx.annotation.NonNull;

import com.xamdesign.safe_device.DevelopmentMode.DevelopmentModeCheck;
import com.xamdesign.safe_device.Emulator.EmulatorCheck;
import com.xamdesign.safe_device.ExternalStorage.ExternalStorageCheck;
import com.xamdesign.safe_device.MockLocation.LocationAssistant;
import com.xamdesign.safe_device.Rooted.RootedCheck;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * SafeDevicePlugin
 */
public class SafeDevicePlugin implements FlutterPlugin, MethodChannel.MethodCallHandler {
    private Context context;
    private static LocationAssistantListener locationAssistantListener;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        this.context = binding.getApplicationContext();
        locationAssistantListener = new LocationAssistantListener(context);

        // Start location updates if needed
        locationAssistantListener.getAssistant().startLocationUpdates();

        final MethodChannel channel = new MethodChannel(
                binding.getBinaryMessenger(),
                "safe_device");
        channel.setMethodCallHandler(this);
    }

    public static void onStop() {
        if (locationAssistantListener != null) {
            // STOP location updates
            locationAssistantListener.getAssistant().stopLocationUpdates();
        }
    }

    public static void onStart() {
        if (locationAssistantListener != null) {
            // START location updates
            locationAssistantListener.getAssistant().startLocationUpdates();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        context = null;
    }

    @Override
    public void onMethodCall(MethodCall call, final MethodChannel.Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("isJailBroken")) {
            result.success(RootedCheck.isJailBroken(context));
        } else if (call.method.equals("isRealDevice")) {
            result.success(!EmulatorCheck.isEmulator());
        } else if (call.method.equals("isOnExternalStorage")) {
            result.success(ExternalStorageCheck.isOnExternalStorage(context));
        } else if (call.method.equals("isDevelopmentModeEnable")) {
            result.success(DevelopmentModeCheck.developmentModeCheck(context));
        } else if (call.method.equals("usbDebuggingCheck")) {
            result.success(DevelopmentModeCheck.usbDebuggingCheck(context));
        } else if (call.method.equals("isMockLocation")) {
            if (locationAssistantListener.isMockLocationsDetected()) {
                result.success(true);
            } else if (locationAssistantListener.getLatitude() != null
                    && locationAssistantListener.getLongitude() != null) {
                result.success(false);
            } else {
                // If we don't have location yet, we might say "can't confirm yet"
                // or simply return false, or start a new request...
                // For now, let's just say false
                result.success(false);
            }
        } else if (call.method.equals("rootDetectionDetails")) {
            result.success(RootedCheck.getRootDetectionDetails(context));
        } else {
            result.notImplemented();
        }
    }

}

class LocationAssistantListener implements LocationAssistant.Listener {
    private final LocationAssistant assistant;
    private boolean isMockLocationsDetected = false;
    private String latitude;
    private String longitude;

    public LocationAssistantListener(Context context) {
        // Adjust constructor call to match the actual LocationAssistant constructor
        assistant = new LocationAssistant(context, this);
    }

    // Provide access to the assistant
    public LocationAssistant getAssistant() {
        return assistant;
    }

    // Implement the interface methods properly
    @Override
    public void onNeedLocationPermission() {
        // You could request permission from Flutter side or do something else
        // For debugging, just log it:
        io.flutter.Log.i("LocationAssistant", "onNeedLocationPermission called");
    }

    @Override
    public void onExplainLocationPermission() {
        io.flutter.Log.i("LocationAssistant", "onExplainLocationPermission");
    }

    @Override
    public void onLocationPermissionPermanentlyDeclined() {
        io.flutter.Log.i("LocationAssistant", "onLocationPermissionPermanentlyDeclined");
    }

    @Override
    public void onNeedLocationSettingsChange() {
        io.flutter.Log.i("LocationAssistant", "onNeedLocationSettingsChange");
    }

    @Override
    public void onFallBackToSystemSettings() {
        io.flutter.Log.i("LocationAssistant", "onFallBackToSystemSettings");
    }

    @Override
    public void onNewLocationAvailable(Location location) {
        if (location == null)
            return;
        latitude = String.valueOf(location.getLatitude());
        longitude = String.valueOf(location.getLongitude());

        // In many detection strategies, if a location has the isFromMockProvider flag,
        // you might consider that a mock location. But in modern Android, that's not
        // reliable.
        // You could do something like:
        if (location.isFromMockProvider()) {
            isMockLocationsDetected = true;
        } else {
            isMockLocationsDetected = false;
        }
    }

    @Override
    public void onMockLocationsDetected() {
        isMockLocationsDetected = true;
    }

    @Override
    public void onError(String message) {
        io.flutter.Log.i("LocationAssistant", "Error: " + message);
    }

    public boolean isMockLocationsDetected() {
        return isMockLocationsDetected;
    }

    public String getLatitude() {
        return latitude;
    }

    public String getLongitude() {
        return longitude;
    }
}
