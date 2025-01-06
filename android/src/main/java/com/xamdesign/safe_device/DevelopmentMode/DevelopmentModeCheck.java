package com.xamdesign.safe_device.DevelopmentMode;

import android.content.Context;
import android.os.Build;
import android.provider.Settings;

public class DevelopmentModeCheck {

    public static boolean developmentModeCheck(Context context) {
        if (Build.VERSION.SDK_INT == 16) {
            return Settings.Secure.getInt(context.getContentResolver(),
                    Settings.Secure.DEVELOPMENT_SETTINGS_ENABLED, 0) != 0;
        } else if (Build.VERSION.SDK_INT >= 17) {
            return Settings.Global.getInt(context.getContentResolver(),
                    Settings.Global.DEVELOPMENT_SETTINGS_ENABLED, 0) != 0;
        }
        return false;
    }

    public static boolean usbDebuggingCheck(Context context) {
        if (Build.VERSION.SDK_INT == 16) {
            return Settings.Secure.getInt(context.getContentResolver(),
                    Settings.Secure.ADB_ENABLED, 0) != 0;
        } else if (Build.VERSION.SDK_INT >= 17) {
            return Settings.Global.getInt(context.getContentResolver(),
                    Settings.Global.ADB_ENABLED, 0) != 0;
        }
        return false;
    }

}
