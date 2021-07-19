package com.xamdesign.safe_device.MockLocationCheck;

import android.os.Build;
import android.content.Context;
import android.provider.Settings;

public class MockLocationCheck {
    /**
     * Checks if the device is rooted.
     *
     * @return <code>true</code> if the device is rooted, <code>false</code> otherwise.
     */
    public static boolean canMockLocation(Context context) {
        boolean check;

        if (Build.VERSION.SDK_INT >= 18) {
            check = checkEqualOrGreaterThan18(context);
        } else {
            check = checkLessThan18(context);
        }
        return check;
    }

    static boolean checkLessThan18(Context context) {
    	return !Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ALLOW_MOCK_LOCATION).equals("0");
    }

    // This doesn't really work. Should check each location.
    // 	return Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR2 && location != null && location.isFromMockProvider();
    static boolean checkEqualOrGreaterThan18(Context context) {
    	return !Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ALLOW_MOCK_LOCATION).equals("0");
    }
}

