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
     * @return <code>true</code> if the device is rooted, <code>false</code>
     *         otherwise.
     */
    public static boolean isJailBroken(Context context) {
        CheckApiVersion check;

        if (Build.VERSION.SDK_INT >= 23) {
            check = new GreaterThan23();
        } else {
            check = new LessThan23();
        }

        // Enhanced detection for emulators and rooted devices
        return check.checkRooted() ||
                rootBeerCheck(context) ||
                checkEmulatorSpecificRoot() ||
                checkSuBinary() ||
                checkDangerousProps();
    }

    private static Boolean rootBeerCheck(Context context) {
        RootBeer rootBeer = new RootBeer(context);
        rootBeer.setLogging(false);
        String brand = Build.BRAND.toLowerCase();
        if (brand.contains(ONEPLUS) || brand.contains(MOTO) || brand.contains(XIAOMI) || brand.contains(LENOVO)) {
            return rootBeer.isRootedWithoutBusyBoxCheck();
        } else {
            return rootBeer.isRooted();
        }
    }

    /**
     * Check for emulator-specific root indicators
     */
    private static boolean checkEmulatorSpecificRoot() {
        // LDPlayer and other emulators often have these characteristics when rooted
        return checkBuildTags() ||
                checkTestKeys() ||
                checkEmulatorRootFiles();
    }

    /**
     * Check build tags for test-keys or other suspicious indicators
     */
    private static boolean checkBuildTags() {
        String buildTags = Build.TAGS;
        if (buildTags != null && buildTags.contains("test-keys")) {
            return true;
        }
        return false;
    }

    /**
     * Check for test-keys in fingerprint
     */
    private static boolean checkTestKeys() {
        String buildTags = Build.TAGS;
        return buildTags != null && buildTags.contains("test-keys");
    }

    /**
     * Check for emulator-specific root files
     */
    private static boolean checkEmulatorRootFiles() {
        String[] emulatorRootPaths = {
                "/system/app/Superuser.apk",
                "/system/xbin/su",
                "/system/bin/su",
                "/sbin/su",
                "/data/local/su",
                "/data/local/bin/su",
                "/data/local/xbin/su",
                "/system/sd/xbin/su",
                "/system/bin/failsafe/su",
                "/system/app/SuperSU.apk",
                "/system/etc/init.d/99SuperSUDaemon",
                "/dev/com.koushikdutta.superuser.daemon/",
                "/system/xbin/daemonsu",
                "/system/etc/security/otacerts.zip",
                "/proc/1/maps",
                "/system/recovery-from-boot.p",
                "/system/bin/app_process32",
                "/system/bin/debuggerd",
                "/system/bin/debuggerd64",
                "/system/bin/rild",
                "/system/priv-app/SuperSU/SuperSU.apk"
        };

        for (String path : emulatorRootPaths) {
            if (new java.io.File(path).exists()) {
                return true;
            }
        }
        return false;
    }

    /**
     * Enhanced su binary detection
     */
    private static boolean checkSuBinary() {
        String[] suPaths = {
                "/sbin/su",
                "/system/bin/su",
                "/system/xbin/su",
                "/data/local/xbin/su",
                "/data/local/bin/su",
                "/system/sd/xbin/su",
                "/system/bin/failsafe/su",
                "/data/local/su",
                "/su/bin/su"
        };

        for (String path : suPaths) {
            if (new java.io.File(path).exists()) {
                return true;
            }
        }

        // Try to execute which command
        return canExecuteCommand("which su") ||
                canExecuteCommand("type su") ||
                canExecuteCommand("su --version");
    }

    /**
     * Check dangerous properties that might indicate root
     */
    private static boolean checkDangerousProps() {
        try {
            // Check for ro.debuggable
            String debuggable = getSystemProperty("ro.debuggable");
            if ("1".equals(debuggable)) {
                return true;
            }

            // Check for ro.secure
            String secure = getSystemProperty("ro.secure");
            if ("0".equals(secure)) {
                return true;
            }

            // Check for service.adb.root
            String adbRoot = getSystemProperty("service.adb.root");
            if ("1".equals(adbRoot)) {
                return true;
            }

        } catch (Exception e) {
            // Ignore exceptions
        }
        return false;
    }

    /**
     * Execute a command and check if it succeeds
     */
    private static boolean canExecuteCommand(String command) {
        try {
            Process process = Runtime.getRuntime().exec(command);
            java.io.BufferedReader in = new java.io.BufferedReader(
                    new java.io.InputStreamReader(process.getInputStream()));
            String line = in.readLine();
            in.close();
            return line != null;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Get system property using reflection
     */
    private static String getSystemProperty(String property) {
        try {
            Class<?> systemProperties = Class.forName("android.os.SystemProperties");
            java.lang.reflect.Method get = systemProperties.getMethod("get", String.class);
            return (String) get.invoke(systemProperties, property);
        } catch (Exception e) {
            return null;
        }
    }
}
