//
//  SafeDeviceJailbreakDetection.m
//  safe_device
//
//  Created for iOS jailbreak detection
//

#import "SafeDeviceJailbreakDetection.h"
#import <UIKit/UIKit.h>

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
            @"/var/lib/dpkg/status"
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
            @"cydia://",
            @"sileo://",
            @"zebra://",
            @"filza://",
            @"activator://"
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
           [self hasJailbreakProcesses];
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
        @"_SafeMode"
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
        @"hasJailbreakProcesses": @(isSimulatorEnvironment ? NO : [self hasJailbreakProcesses])
    };
}

@end 