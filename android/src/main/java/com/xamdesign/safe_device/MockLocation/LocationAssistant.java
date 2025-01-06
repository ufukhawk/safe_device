package com.xamdesign.safe_device.MockLocation;

import android.Manifest;
import android.content.Context;
import android.content.IntentSender;
import android.content.pm.PackageManager;
import android.location.Location;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.location.LocationSettingsRequest;

public class LocationAssistant {

    public interface Listener {
        void onNeedLocationPermission();
        void onExplainLocationPermission();
        void onLocationPermissionPermanentlyDeclined();
        void onNeedLocationSettingsChange();
        void onFallBackToSystemSettings();
        void onNewLocationAvailable(Location location);
        void onMockLocationsDetected();
        void onError(String message);
    }

    private static final String TAG = "LocationAssistant";
    private final Context context;
    private final Listener listener;
    private final FusedLocationProviderClient fusedLocationProviderClient;
    private LocationRequest locationRequest;

    public LocationAssistant(Context context, Listener listener) {
        this.context = context;
        this.listener = listener;
        this.fusedLocationProviderClient = LocationServices.getFusedLocationProviderClient(context);
        configureLocationRequest();
    }

    private void configureLocationRequest() {
        locationRequest = LocationRequest.create();
        locationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
        locationRequest.setInterval(10000);
        locationRequest.setFastestInterval(5000);
    }

    public void checkLocationSettings() {
        LocationSettingsRequest.Builder builder = new LocationSettingsRequest.Builder()
                .addLocationRequest(locationRequest);

        LocationServices.getSettingsClient(context)
                .checkLocationSettings(builder.build())
                .addOnSuccessListener(locationSettingsResponse -> startLocationUpdates())
                .addOnFailureListener(e -> {
                    if (e instanceof IntentSender.SendIntentException) {
                        listener.onNeedLocationSettingsChange();
                    } else {
                        listener.onError("Location settings are not satisfied.");
                    }
                });
    }

    public void startLocationUpdates() {
        if (ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION)
                != PackageManager.PERMISSION_GRANTED) {
            listener.onNeedLocationPermission();
            return;
        }

        fusedLocationProviderClient.requestLocationUpdates(
                locationRequest,
                locationCallback,
                Looper.getMainLooper()
        );
    }

    public void stopLocationUpdates() {
        fusedLocationProviderClient.removeLocationUpdates(locationCallback);
    }

    public void getLastKnownLocation() {
        if (ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION)
                != PackageManager.PERMISSION_GRANTED) {
            listener.onNeedLocationPermission();
            return;
        }

        fusedLocationProviderClient.getLastLocation()
                .addOnSuccessListener(location -> {
                    if (location != null) {
                        listener.onNewLocationAvailable(location);
                    } else {
                        listener.onError("Last known location is not available.");
                    }
                })
                .addOnFailureListener(e ->
                        listener.onError("Error retrieving last known location: " + e.getMessage()));
    }

    private final LocationCallback locationCallback = new LocationCallback() {
        @Override
        public void onLocationResult(@NonNull LocationResult locationResult) {
            for (Location location : locationResult.getLocations()) {
                listener.onNewLocationAvailable(location);
            }
        }
    };
}
