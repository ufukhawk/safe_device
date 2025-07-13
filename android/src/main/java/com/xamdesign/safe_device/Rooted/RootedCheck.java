package com.xamdesign.safe_device.Rooted;

import android.content.Context;

import com.scottyab.rootbeer.RootBeer;
import android.os.Build;
import java.util.HashMap;
import java.util.Map;

public class RootedCheck {
    private static final String ONEPLUS = "oneplus";
    private static final String MOTO = "moto";
    private static final String XIAOMI = "xiaomi";
    private static final String LENOVO = "lenovo";
    private static final String SAMSUNG = "samsung";

    /**
     * Checks if the device is rooted with improved Samsung compatibility.
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

        // Check if this is a development environment
        boolean isDevelopmentEnvironment = isDevelopmentEnvironment();

        // Basic file system checks
        boolean basicRootCheck = check.checkRooted();

        // RootBeer library check
        boolean rootBeerResult = rootBeerCheck(context);

        // Enhanced detection for emulators
        boolean emulatorSpecificRoot = checkEmulatorSpecificRoot();

        // SU binary detection
        boolean suBinaryFound = checkSuBinary();

        // Dangerous properties check (more lenient for Samsung development devices)
        boolean dangerousProps = checkDangerousProps(isDevelopmentEnvironment);

        // Special handling for Xiaomi devices (including Redmi)
        String brand = Build.BRAND.toLowerCase();
        if (brand.contains("xiaomi") || brand.contains("redmi") || brand.contains("poco")) {
            // For Xiaomi devices, use only the most reliable detection methods
            // MIUI can cause false positives, so be more conservative
            return hasObviousRootSigns() ||
                    (basicRootCheck && suBinaryFound); // Need both basic check AND su binary
        }

        // In development environment, be more lenient
        if (isDevelopmentEnvironment) {
            // Only flag as rooted if we have obvious root signs
            return basicRootCheck || hasObviousRootSigns() || suBinaryFound;
        }

        // In production, use all checks
        return basicRootCheck ||
                rootBeerResult ||
                emulatorSpecificRoot ||
                suBinaryFound ||
                dangerousProps;
    }

    /**
     * Get detailed root detection results for debugging
     */
    public static Map<String, Object> getRootDetectionDetails(Context context) {
        Map<String, Object> details = new HashMap<>();

        CheckApiVersion check;
        if (Build.VERSION.SDK_INT >= 23) {
            check = new GreaterThan23();
        } else {
            check = new LessThan23();
        }

        // Device info
        details.put("brand", Build.BRAND.toLowerCase());
        details.put("model", Build.MODEL);
        details.put("apiLevel", Build.VERSION.SDK_INT);
        details.put("buildTags", Build.TAGS != null ? Build.TAGS : "null");
        details.put("buildType", Build.TYPE);
        details.put("isDebuggable", (Build.TYPE.equals("eng") || Build.TYPE.equals("userdebug")));

        // Development environment detection
        boolean isDevelopmentEnvironment = isDevelopmentEnvironment();
        details.put("isDevelopmentEnvironment", isDevelopmentEnvironment);

        // Individual detection methods
        details.put("basicRootCheck", check.checkRooted());
        details.put("rootBeerCheck", rootBeerCheck(context));
        details.put("emulatorSpecificRoot", checkEmulatorSpecificRoot());
        details.put("suBinaryFound", checkSuBinary());
        details.put("dangerousProps", checkDangerousProps(false)); // Always check for debugging
        details.put("hasObviousRootSigns", hasObviousRootSigns());

        // Build-specific checks
        details.put("hasTestKeys", checkTestKeys());
        details.put("buildTagsHasTestKeys", checkBuildTags());

        // System properties
        details.put("ro.debuggable", getSystemProperty("ro.debuggable"));
        details.put("ro.secure", getSystemProperty("ro.secure"));
        details.put("service.adb.root", getSystemProperty("service.adb.root"));
        details.put("ro.build.type", getSystemProperty("ro.build.type"));
        details.put("ro.build.tags", getSystemProperty("ro.build.tags"));

        // Final result
        details.put("isRooted", isJailBroken(context));

        return details;
    }

    /**
     * Check if this is a development environment
     */
    private static boolean isDevelopmentEnvironment() {
        // Check if this is a debug build
        boolean isDebuggable = (Build.TYPE.equals("eng") || Build.TYPE.equals("userdebug"));

        // Check for development-related build tags
        String buildTags = Build.TAGS;
        boolean hasDevTags = buildTags != null &&
                (buildTags.contains("dev-keys") || buildTags.contains("test-keys"));

        // Check for common development indicators regardless of brand
        String debuggable = getSystemProperty("ro.debuggable");
        boolean hasDebugProp = "1".equals(debuggable);

        // Consider it development environment if any development indicators are present
        return isDebuggable || hasDevTags || hasDebugProp;
    }

    /**
     * Check for obvious root signs that are definitive
     */
    private static boolean hasObviousRootSigns() {
        String[] obviousRootPaths = {
                "/system/app/Superuser.apk",
                "/system/app/SuperSU.apk",
                "/system/priv-app/SuperSU/SuperSU.apk",
                "/system/xbin/daemonsu",
                "/data/local/tmp/supersu",
                "/dev/com.koushikdutta.superuser.daemon/"
        };

        for (String path : obviousRootPaths) {
            if (new java.io.File(path).exists()) {
                return true;
            }
        }
        return false;
    }

    private static Boolean rootBeerCheck(Context context) {
        RootBeer rootBeer = new RootBeer(context);
        rootBeer.setLogging(false);
        String brand = Build.BRAND.toLowerCase();

        // Use more conservative detection for brands known to have false positives
        if (brand.contains(ONEPLUS) || brand.contains(MOTO) || brand.contains(XIAOMI) ||
                brand.contains(LENOVO) || brand.contains(SAMSUNG)) {
            return rootBeer.isRootedWithoutBusyBoxCheck();
        } else {
            return rootBeer.isRooted();
        }
    }

    /**
     * Check for emulator-specific root indicators
     * This should only apply to actual emulators, not real devices
     */
    private static boolean checkEmulatorSpecificRoot() {
        // Only apply emulator-specific checks if this is actually an emulator
        if (!isLikelyEmulator()) {
            return false;
        }

        // LDPlayer and other emulators often have these characteristics when rooted
        return checkBuildTags() ||
                checkTestKeys() ||
                checkEmulatorRootFiles();
    }

    /**
     * Basic emulator detection for root checking context
     */
    private static boolean isLikelyEmulator() {
        return Build.FINGERPRINT.startsWith("generic")
                || Build.FINGERPRINT.startsWith("unknown")
                || Build.MODEL.contains("google_sdk")
                || Build.MODEL.contains("Emulator")
                || Build.MODEL.contains("Android SDK built for x86")
                || Build.MANUFACTURER.contains("Genymotion")
                || Build.MODEL.startsWith("sdk_")
                || Build.DEVICE.startsWith("emulator")
                || (Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic"))
                || "google_sdk".equals(Build.PRODUCT)
                || Build.HARDWARE.contains("goldfish")
                || Build.HARDWARE.contains("ranchu")
                || Build.PRODUCT.contains("vbox86p")
                || Build.PRODUCT.toLowerCase().contains("nox")
                || Build.BOARD.toLowerCase().contains("nox")
                || Build.HARDWARE.toLowerCase().contains("nox")
                || Build.MODEL.toLowerCase().contains("droid4x")
                || "vbox86".equals(Build.HARDWARE);
    }

    /**
     * Check build tags for test-keys or other suspicious indicators
     */
    private static boolean checkBuildTags() {
        String buildTags = Build.TAGS;
        if (buildTags != null && buildTags.contains("test-keys")) {
            // Don't flag any devices with test-keys as rooted in development environment
            if (isDevelopmentEnvironment()) {
                return false;
            }
            return true;
        }
        return false;
    }

    /**
     * Check for test-keys in fingerprint
     */
    private static boolean checkTestKeys() {
        String buildTags = Build.TAGS;
        if (buildTags != null && buildTags.contains("test-keys")) {
            // More lenient for any development devices, not just Samsung
            if (isDevelopmentEnvironment()) {
                return false;
            }
            return true;
        }
        return false;
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
                "/system/priv-app/SuperSU/SuperSU.apk"
                // Removed normal system files that are not root indicators:
                // "/system/etc/security/otacerts.zip" - Normal OTA certificate
                // "/proc/1/maps" - Normal proc filesystem
                // "/system/recovery-from-boot.p" - Normal recovery patch
                // "/system/bin/app_process32" - Normal system binary
                // "/system/bin/debuggerd" - Normal system binary
                // "/system/bin/debuggerd64" - Normal system binary
                // "/system/bin/rild" - Normal radio interface daemon
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
     * More lenient for development environments
     */
    private static boolean checkDangerousProps(boolean isDevelopmentEnvironment) {
        try {
            // Check for ro.debuggable
            String debuggable = getSystemProperty("ro.debuggable");
            if ("1".equals(debuggable) && !isDevelopmentEnvironment) {
                return true;
            }

            // Check for ro.secure
            String secure = getSystemProperty("ro.secure");
            if ("0".equals(secure)) {
                // Any development devices might have ro.secure=0, be more lenient
                if (isDevelopmentEnvironment) {
                    return false;
                }
                return true;
            }

            // Check for service.adb.root
            String adbRoot = getSystemProperty("service.adb.root");
            if ("1".equals(adbRoot) && !isDevelopmentEnvironment) {
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
