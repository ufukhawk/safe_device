//
//  SafeDeviceJailbreakDetection.m
//  safe_device
//
//  Created for iOS jailbreak detection
//

#import "SafeDeviceJailbreakDetection.h"
#import <UIKit/UIKit.h>
#import <sys/mount.h>
#import <sys/stat.h>

@implementation SafeDeviceJailbreakDetection

#pragma mark - Jailbreak Detection Paths

/// Common jailbreak tool and application paths
+ (NSArray<NSString *> *)jailbreakPaths {
    static NSArray<NSString *> *paths = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        paths = @[
            // Cydia and package managers
            @"/private/var/lib/apt",
            @"/Applications/Cydia.app",
            @"/Applications/RockApp.app",
            @"/Applications/Icy.app",
            @"/Applications/WinterBoard.app",
            @"/Applications/SBSettings.app",
            @"/Applications/blackra1n.app",
            @"/Applications/IntelliScreen.app",
            @"/Applications/Snoop-itConfig.app",
            
            // System binaries commonly found on jailbroken devices
            @"/bin/sh",
            @"/bin/bash",
            @"/usr/sbin/sshd",
            @"/usr/libexec/sftp-server",
            @"/usr/libexec/ssh-keysign",
            
            // MobileSubstrate and related files
            @"/Library/MobileSubstrate/MobileSubstrate.dylib",
            @"/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
            @"/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
            
            // APT package manager
            @"/etc/apt",
            
            // Launch daemons
            @"/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
            @"/System/Library/LaunchDaemons/com.ikey.bbot.plist",
            
            // Additional common jailbreak paths
            @"/usr/sbin/frida-server",
            @"/usr/bin/cycript",
            @"/usr/local/bin/cycript",
            @"/usr/lib/libcycript.dylib",
            @"/var/cache/apt",
            @"/var/lib/cydia",
            @"/var/log/syslog",
            @"/etc/ssh/sshd_config",
            @"/private/var/tmp/cydia.log",
            @"/Applications/Terminal.app",
            @"/Applications/iFile.app",
            @"/Applications/Filza.app",
            @"/private/var/lib/dpkg",
            @"/usr/bin/dpkg",
            @"/usr/sbin/dpkg",
            @"/var/lib/dpkg/status",
            
            // palera1n-specific paths
            @"/var/jb",
            @"/var/jb/usr/bin/apt",
            @"/var/jb/usr/bin/dpkg",
            @"/var/jb/usr/lib/libellekit.dylib",
            @"/var/jb/Library/LaunchDaemons/jb.plist",
            @"/var/jb/usr/share/procursus",
            @"/var/jb/usr/bin/sileo",
            @"/var/jb/usr/bin/palera1n",
            @"/var/jb/usr/share/jailbreak",
            @"/var/jb/Applications/Sileo.app",
            @"/var/jb/Applications/loader.app",
            @"/var/jb/usr/lib/libsubstrate.dylib",
            @"/var/jb/usr/lib/substrate",
            @"/var/jb/Library/MobileSubstrate",
            @"/var/jb/Library/dpkg",
            @"/var/jb/var/lib/dpkg/status",
            @"/var/jb/etc/apt",
            @"/var/jb/var/cache/apt",
            @"/var/jb/var/lib/apt",
            @"/var/jb/usr/share/bigboss",
            @"/var/jb/usr/share/entitlements",
            @"/var/jb/usr/include",
            @"/var/jb/Library/Frameworks/CydiaSubstrate.framework",
            @"/var/jb/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
            @"/var/jb/usr/libexec/ellekit",
            @"/var/jb/usr/lib/TweakInject",
            @"/var/jb/usr/lib/pspawn_payload-stg2.dylib",
            @"/var/jb/usr/lib/pspawn_payload.dylib",
            @"/var/jb/usr/share/zsh",
            @"/var/jb/usr/bin/zsh",
            @"/var/jb/usr/bin/killall",
            @"/var/jb/usr/bin/sbreload",
            @"/var/jb/usr/bin/uicache",
            @"/var/jb/usr/bin/ldrestart",
            @"/var/jb/usr/bin/jbctl",
            @"/var/jb/System/Library/CoreServices/SpringBoard.app/PaleLdr.dylib",
            @"/var/jb/basebin",
            @"/var/jb/usr/lib/libpam.dylib",
            @"/var/jb/usr/lib/libssl.dylib",
            @"/var/jb/usr/lib/libcrypto.dylib",
            
            // Sileo package manager (palera1n's default)
            @"/Applications/Sileo.app",
            @"/private/var/mobile/Library/Sileo",
            @"/var/mobile/Library/Sileo",
            @"/var/mobile/Library/Preferences/org.coolstar.SileoStore.plist",
            
            // Procursus bootstrap files
            @"/usr/share/procursus",
            @"/Library/dpkg/info/procursus-keyring.list",
            @"/Library/dpkg/info/procursus-keyring.md5sums",
            @"/var/lib/dpkg/info/procursus-keyring.list",
            @"/var/lib/dpkg/info/procursus-keyring.md5sums",
            
            // Additional rootless jailbreak libraries
            @"/usr/lib/libjailbreak.dylib",
            @"/usr/lib/libhooker.dylib",
            @"/usr/lib/libblackjack.dylib",
            @"/usr/lib/libiosexec.dylib",
            @"/usr/lib/libcolorpicker.dylib",
            @"/usr/lib/libactivator.dylib",
            @"/usr/lib/libapplist.dylib",
            @"/usr/lib/librocketbootstrap.dylib",
            @"/usr/lib/libsubstitute.dylib",
            @"/usr/lib/libdobby.dylib",
            @"/usr/lib/libellekit.dylib",
            @"/usr/lib/libopendirectory.dylib",
            @"/usr/lib/libsystem_jailbreak.dylib",
            
            // Environment files that indicate jailbreak
            @"/etc/profile",
            @"/etc/bashrc",
            @"/etc/zshrc",
            @"/private/etc/profile",
            @"/private/etc/bashrc",
            @"/private/etc/zshrc"
        ];
    });
    return paths;
}

/// URL schemes commonly used by jailbreak tools
+ (NSArray<NSString *> *)jailbreakSchemes {
    static NSArray<NSString *> *schemes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        schemes = @[
            // Package managers
            @"cydia://",
            @"sileo://",
            @"zebra://",
            @"installer://",
            
            // Jailbreak tools
            @"checkra1n://",
            @"palera1n://",
            @"undecimus://",
            @"unc0ver://",
            @"taurine://",
            @"odyssey://",
            @"odysseyra1n://",
            @"chimera://",
            @"electra://",
            @"h3lix://",
            @"meridian://",
            @"phoenix://",
            @"doublehelix://",
            @"evasion://",
            @"evasi0n://",
            @"pangu://",
            @"taig://",
            @"limera1n://",
            @"blackra1n://",
            @"greenpois0n://",
            @"redsn0w://",
            @"sn0wbreeze://",
            @"pwnagetool://",
            @"p0sixspwn://",
            @"absinthe://",
            @"spirit://",
            @"jailbreakme://",
            @"jailbreakme3://",
            
            // File managers
            @"filza://",
            @"icleaner://",
            
            // Tweak frameworks
            @"substitute://",
            @"substrate://",
            @"ellekit://",
            @"mobilesubstrate://",
            @"substrate-safe-mode://",
            @"safemode://",
            
            // Theming
            @"winterboard://",
            @"anemone://",
            @"snowboard://",
            
            // Utilities
            @"activator://",
            @"sbsettings://",
            @"flex://",
            @"liberty://",
            @"unsub://",
            @"flyjb://",
            @"shadow://",
            @"vnodebypass://",
            @"kernbypass://",
            @"choicy://",
            @"tsprotector://",
            @"xcon://",
            
            // App modifications
            @"phantom://",
            @"watusi://",
            @"crackerxi://",
            @"appstore++://",
            
            // Support libraries
            @"preferenceloader://",
            @"rocketbootstrap://",
            @"applist://",
            @"libactivator://",
            @"flipswitch://"
        ];
    });
    return schemes;
}

#pragma mark - Simulator Detection

/// Checks if the app is running on iOS Simulator
+ (BOOL)isSimulator {
#if TARGET_OS_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

#pragma mark - Main Detection Method

+ (BOOL)isJailbroken {
    // Return NO immediately if running on simulator
    if ([self isSimulator]) {
        return NO;
    }
    
    return [self hasJailbreakPaths] ||
           [self canOpenJailbreakSchemes] ||
           [self canViolateSandbox] ||
           [self hasJailbreakEnvironmentVariables] ||
           [self hasSuspiciousSymlinks] ||
           [self hasJailbreakProcesses] ||
           [self hasPalera1nRootlessBootstrap] ||
           [self hasJailbreakMountPoints];
}

#pragma mark - Path-based Detection

/// Checks for the existence of common jailbreak-related files and directories
+ (BOOL)hasJailbreakPaths {
    // Skip path checking on simulator
    if ([self isSimulator]) {
        return NO;
    }
    
    NSArray<NSString *> *paths = [self jailbreakPaths];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    for (NSString *path in paths) {
        if ([fileManager fileExistsAtPath:path]) {
            return YES;
        }
        
        // Additional check for path accessibility
        if ([self canAccessPath:path]) {
            return YES;
        }
    }
    return NO;
}

/// Attempts to access a path to determine if it exists
+ (BOOL)canAccessPath:(NSString *)path {
    // Skip on simulator
    if ([self isSimulator]) {
        return NO;
    }
    
    FILE *file = fopen([path UTF8String], "r");
    if (file != NULL) {
        fclose(file);
        return YES;
    }
    return NO;
}

#pragma mark - URL Scheme Detection

/// Checks if the device can open URLs associated with jailbreak tools
+ (BOOL)canOpenJailbreakSchemes {
    // Skip on simulator
    if ([self isSimulator]) {
        return NO;
    }
    
    UIApplication *application = [UIApplication sharedApplication];
    if (!application) {
        return NO;
    }
    
    NSArray<NSString *> *schemes = [self jailbreakSchemes];
    for (NSString *scheme in schemes) {
        NSURL *url = [NSURL URLWithString:scheme];
        if (url && [application canOpenURL:url]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Sandbox Violation Detection

/// Attempts to write to locations outside the app sandbox
+ (BOOL)canViolateSandbox {
    // Skip on simulator as it has different sandbox behavior
    if ([self isSimulator]) {
        return NO;
    }
    
    NSArray<NSString *> *testPaths = @[
        @"/private/jailbreak_test.txt",
        @"/private/var/mobile/jailbreak_test.txt",
        @"/var/tmp/jailbreak_test.txt"
    ];
    
    for (NSString *path in testPaths) {
        NSError *error = nil;
        NSString *testString = @"jailbreak_test";
        
        BOOL success = [testString writeToFile:path
                                    atomically:YES
                                      encoding:NSUTF8StringEncoding
                                         error:&error];
        
        if (success && !error) {
            // Clean up the test file
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            return YES;
        }
    }
    return NO;
}

#pragma mark - Environment Variable Detection

/// Checks for environment variables that may indicate jailbreak
+ (BOOL)hasJailbreakEnvironmentVariables {
    // Skip on simulator
    if ([self isSimulator]) {
        return NO;
    }
    
    NSArray<NSString *> *suspiciousVariables = @[
        @"DYLD_INSERT_LIBRARIES",
        @"_MSSafeMode",
        @"_SafeMode",
        @"JB_ROOT_PATH",
        @"JB_BINPACK_PATH",
        @"PALERA1N_ROOTLESS",
        @"PALERA1N_JBROOT",
        @"ELLEKIT_INSERTED",
        @"SUBSTITUTE_INSERTED",
        @"SUBSTRATE_INSERTED",
        @"TWEAKINJECT_INSERTED",
        @"PSPAWN_PAYLOAD_INSERTED",
        @"ROOTLESS_BOOTSTRAP_PATH",
        @"PROCURSUS_ROOT",
        @"SILEO_INSTALLED",
        @"MOBILESUBSTRATE_INSERTED",
        @"CYCRIPT_INSERTED",
        @"FRIDA_INSERTED",
        @"FLEXBE_INSERTED",
        @"SPRINGBOARD_HOOKED",
        @"LAUNCHD_HOOKED",
        @"AMFID_PAYLOAD_INSERTED",
        @"KERNBYPASS_INSERTED",
        @"LIBERTY_INSERTED",
        @"SHADOW_INSERTED",
        @"FLYJB_INSERTED",
        @"VNODEBYPASS_INSERTED",
        @"JAILBREAK_DETECTION_BYPASS",
        @"CHOICY_INSERTED",
        @"TSPROTECTOR_INSERTED",
        @"XCON_INSERTED",
        @"UNSUB_INSERTED",
        @"HIDDENJB_INSERTED",
        @"KERNBYPASS_INSERTED",
        @"AKERNELBYPASS_INSERTED",
        @"BKERNELBYPASS_INSERTED"
    ];
    
    for (NSString *variable in suspiciousVariables) {
        if (getenv([variable UTF8String]) != NULL) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Symbolic Link Detection

/// Checks for symbolic links that shouldn't exist on non-jailbroken devices
+ (BOOL)hasSuspiciousSymlinks {
    // Skip on simulator
    if ([self isSimulator]) {
        return NO;
    }
    
    NSArray<NSString *> *suspiciousLinks = @[
        @"/Applications",
        @"/Library/Ringtones",
        @"/Library/Wallpaper",
        @"/usr/include",
        @"/usr/libexec",
        @"/usr/share"
    ];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    for (NSString *link in suspiciousLinks) {
        BOOL isDirectory = NO;
        if ([fileManager fileExistsAtPath:link isDirectory:&isDirectory]) {
            NSError *error = nil;
            NSDictionary *attributes = [fileManager attributesOfItemAtPath:link error:&error];
            
            if (!error && attributes) {
                NSString *fileType = attributes[NSFileType];
                if ([fileType isEqualToString:NSFileTypeSymbolicLink]) {
                    return YES;
                }
            }
        }
    }
    return NO;
}

#pragma mark - Process Detection

/// Checks for running processes that indicate jailbreak
+ (BOOL)hasJailbreakProcesses {
    // Skip on simulator
    if ([self isSimulator]) {
        return NO;
    }
    
    // Note: This method has limitations on modern iOS versions due to security restrictions
    // but may still work in some cases
    
    // This is a simplified check - more sophisticated methods would be needed
    // for reliable process detection on modern iOS
    return NO;
}

#pragma mark - Additional Helper Methods

#pragma mark - Palera1n-specific Detection

/// Checks for palera1n rootless bootstrap installation
+ (BOOL)hasPalera1nRootlessBootstrap {
    // Skip on simulator
    if ([self isSimulator]) {
        return NO;
    }
    
    // Check for /var/jb directory structure
    NSArray<NSString *> *palera1nPaths = @[
        @"/var/jb",
        @"/var/jb/usr",
        @"/var/jb/usr/bin",
        @"/var/jb/usr/lib",
        @"/var/jb/Library",
        @"/var/jb/Applications"
    ];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (NSString *path in palera1nPaths) {
        if ([fileManager fileExistsAtPath:path]) {
            return YES;
        }
    }
    
    // Check for palera1n-specific binaries
    NSArray<NSString *> *palera1nBinaries = @[
        @"/var/jb/usr/bin/palera1n",
        @"/var/jb/usr/bin/sileo",
        @"/var/jb/usr/bin/apt",
        @"/var/jb/usr/bin/dpkg",
        @"/var/jb/usr/bin/jbctl"
    ];
    
    for (NSString *binary in palera1nBinaries) {
        if ([fileManager fileExistsAtPath:binary]) {
            return YES;
        }
    }
    
    // Check for ElleKit (palera1n's hooking framework)
    NSArray<NSString *> *ellekitPaths = @[
        @"/var/jb/usr/lib/libellekit.dylib",
        @"/var/jb/usr/libexec/ellekit"
    ];
    
    for (NSString *path in ellekitPaths) {
        if ([fileManager fileExistsAtPath:path]) {
            return YES;
        }
    }
    
    return NO;
}

/// Checks for suspicious mount points that indicate jailbreak
+ (BOOL)hasJailbreakMountPoints {
    // Skip on simulator
    if ([self isSimulator]) {
        return NO;
    }
    
    // Check for /var/jb mount point (rootless bootstrap)
    struct statfs fs;
    if (statfs("/var/jb", &fs) == 0) {
        return YES;
    }
    
    // Check for other suspicious mount points
    NSArray<NSString *> *suspiciousMounts = @[
        @"/Developer",
        @"/var/stash",
        @"/var/db/stash",
        @"/var/mobile/Library/Cydia",
        @"/var/mobile/Library/Sileo",
        @"/var/mobile/Library/SBSettings",
        @"/var/mobile/Library/Preferences/com.saurik.Cydia.plist",
        @"/var/mobile/Library/Preferences/org.coolstar.SileoStore.plist"
    ];
    
    for (NSString *mount in suspiciousMounts) {
        if (statfs([mount UTF8String], &fs) == 0) {
            return YES;
        }
    }
    
    return NO;
}

/// Combines multiple detection methods for enhanced reliability
+ (NSDictionary<NSString *, NSNumber *> *)getJailbreakDetails {
    BOOL isSimulatorEnvironment = [self isSimulator];
    
    return @{
        @"isSimulator": @(isSimulatorEnvironment),
        @"hasPaths": @(isSimulatorEnvironment ? NO : [self hasJailbreakPaths]),
        @"canOpenSchemes": @(isSimulatorEnvironment ? NO : [self canOpenJailbreakSchemes]),
        @"canViolateSandbox": @(isSimulatorEnvironment ? NO : [self canViolateSandbox]),
        @"hasEnvironmentVariables": @(isSimulatorEnvironment ? NO : [self hasJailbreakEnvironmentVariables]),
        @"hasSuspiciousSymlinks": @(isSimulatorEnvironment ? NO : [self hasSuspiciousSymlinks]),
        @"hasJailbreakProcesses": @(isSimulatorEnvironment ? NO : [self hasJailbreakProcesses]),
        @"hasPalera1nRootlessBootstrap": @(isSimulatorEnvironment ? NO : [self hasPalera1nRootlessBootstrap]),
        @"hasJailbreakMountPoints": @(isSimulatorEnvironment ? NO : [self hasJailbreakMountPoints])
    };
}

@end 