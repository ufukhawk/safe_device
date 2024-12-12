package com.xamdesign.safe_device.DevelopmentMode;

import android.content.Context;
import android.os.Build;
import android.provider.Settings;

public class DevelopmentModeCheck {

    public static boolean developmentModeCheck(Context context) {
        if(Integer.valueOf(Build.VERSION.SDK_INT) == 16) {
            return android.provider.Settings.Secure.getInt(context.getContentResolver(),
                    android.provider.Settings.Secure.DEVELOPMENT_SETTINGS_ENABLED , 0) != 0;
        } else if (Integer.valueOf(Build.VERSION.SDK_INT) >= 17) {
            return android.provider.Settings.Global.getInt(context.getContentResolver(),
                    android.provider.Settings.Global.DEVELOPMENT_SETTINGS_ENABLED , 0) != 0;
        } else return false;
    }

    public static boolean usbDebuggingCheck(Context context) {
        if(Integer.valueOf(Build.VERSION.SDK_INT) == 16) {
            return android.provider.Settings.Secure.getInt(context.getContentResolver(),
                    android.provider.Settings.Secure.ADB_ENABLED , 0) != 0;
        } else if (Integer.valueOf(Build.VERSION.SDK_INT) >= 17) {
            return android.provider.Settings.Global.getInt(context.getContentResolver(),
                    android.provider.Settings.Global.ADB_ENABLED , 0) != 0;
        } else return false;
    }
}

