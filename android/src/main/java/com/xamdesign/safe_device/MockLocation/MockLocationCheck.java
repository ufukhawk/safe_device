package com.xamdesign.safe_device.MockLocationCheck;

import java.util.List;
import android.os.Build;
import android.content.Context;
import android.provider.Settings;
import android.content.pm.PackageManager;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.util.Log;
import java.lang.Exception;

public class MockLocationCheck {
    /**
     * Checks if the device can mock location.
     *
     * @return <code>true</code> if the device can mock locaktion, <code>false</code> otherwise.
     */
    public static boolean canMockLocation(Context context) {
        return checkSettings(context) || areThereMockPermissionApps(context);
    }

    static boolean checkSettings(Context context) {
    	return !Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ALLOW_MOCK_LOCATION).equals("0");
    }

    static boolean areThereMockPermissionApps(Context context) {
        int count = 0;

        PackageManager pm = context.getPackageManager();
        List<ApplicationInfo> packages =
            pm.getInstalledApplications(PackageManager.GET_META_DATA);

        for (ApplicationInfo applicationInfo : packages) {
            try {
                PackageInfo packageInfo = pm.getPackageInfo(applicationInfo.packageName,
                                                            PackageManager.GET_PERMISSIONS);

                // Get Permissions
                String[] requestedPermissions = packageInfo.requestedPermissions;

                if (requestedPermissions != null) {
                    for (int i = 0; i < requestedPermissions.length; i++) {
                        if (requestedPermissions[i]
                            .equals("android.permission.ACCESS_MOCK_LOCATION")
                            && !applicationInfo.packageName.equals(context.getPackageName())) {
                            count++;
                        }
                    }
                }
            } catch (Exception e) {
                Log.v("Exception looking for MockPermissionApps" , e.getMessage());
            }
        }

        if (count > 0)
            return true;

        return false;
    }
}

