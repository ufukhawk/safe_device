package com.xamdesign.safe_device.Rooted;

import android.content.Context;

import com.scottyab.rootbeer.RootBeer;
import android.os.Build;

public class RootedCheck {
    private static final String ONEPLUS = "oneplus";
    private static final String MOTO = "moto";
    private static final String XIAOMI = "xiaomi";
    private static final String LENOVO = "lenovo";


    /**
     * Checks if the device is rooted.
     *
     * @return <code>true</code> if the device is rooted, <code>false</code> otherwise.
     */
    public static boolean isJailBroken(Context context) {
        CheckApiVersion check;

        if (Build.VERSION.SDK_INT >= 23) {
            check = new GreaterThan23();
        } else {
            check = new LessThan23();
        }
        return check.checkRooted() || rootBeerCheck(context);
    }

    private static Boolean rootBeerCheck(Context context) {
        RootBeer rootBeer = new RootBeer(context);
        boolean rv;

        if(Build.BRAND.toLowerCase().contains(ONEPLUS) || Build.BRAND.toLowerCase().contains(MOTO) || Build.BRAND.toLowerCase().contains(XIAOMI) || Build.BRAND.toLowerCase().contains(LENOVO)) {
            rv = rootBeer.isRootedWithoutBusyBoxCheck();
        } else {
            rv = rootBeer.isRooted();
        }
        return rv;
    }
}

