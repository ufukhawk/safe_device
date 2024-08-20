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
        rootBeer.setLogging(false);
        String brand = Build.BRAND.toLowerCase();
        if(brand.contains(ONEPLUS) || brand.contains(MOTO) || brand.contains(XIAOMI) || brand.contains(LENOVO)) {
            return rootBeer.isRootedWithoutBusyBoxCheck();
        } else {
            return rootBeer.isRooted();
        }
    }
}

