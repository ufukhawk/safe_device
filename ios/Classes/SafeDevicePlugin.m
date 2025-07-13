#import "SafeDevicePlugin.h"
#import <DTTJailbreakDetection/DTTJailbreakDetection.h>
#import "SafeDeviceJailbreakDetection.h"

@implementation SafeDevicePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"safe_device"
            binaryMessenger:[registrar messenger]];
  SafeDevicePlugin* instance = [[SafeDevicePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }else if ([@"isJailBroken" isEqualToString:call.method]) {
    result([NSNumber numberWithBool:[self isJailBroken]]);
  }else if ([@"isJailBrokenCustom" isEqualToString:call.method]) {
    result([NSNumber numberWithBool:[self isJailBrokenCustom]]);
  }else if ([@"jailbreakDetails" isEqualToString:call.method]) {
    result([SafeDeviceJailbreakDetection getJailbreakDetails]);
  }else if ([@"canMockLocation" isEqualToString:call.method]) {
    //For now we have returned if device is Jail Broken or if it's not real device. There is no
    //strong detection of Mock location in iOS
    result([NSNumber numberWithBool:([self isJailBroken] || ![self isRealDevice])]);
  }else if ([@"isRealDevice" isEqualToString:call.method]) {
    result([NSNumber numberWithBool:[self isRealDevice]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (BOOL)isDevelopmentEnvironment {
    // Check if running under Xcode or development environment
    
    // Check for Xcode debugging
    if (isatty(STDERR_FILENO)) {
        return YES;
    }
    
    // Check for debug build
    #ifdef DEBUG
    return YES;
    #endif
    
    // Check simulator
    #if TARGET_OS_SIMULATOR
    return YES;
    #endif
    
    // Check for development team ID in embedded.mobileprovision
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *provisionPath = [bundlePath stringByAppendingPathComponent:@"embedded.mobileprovision"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:provisionPath]) {
        // Development builds typically have embedded.mobileprovision
        return YES;
    }
    
    return NO;
}

- (BOOL)hasLegitimateEnvironmentVariables {
    // Check if DYLD_INSERT_LIBRARIES contains legitimate Apple frameworks
    const char* dylibPath = getenv("DYLD_INSERT_LIBRARIES");
    if (dylibPath == NULL) {
        return NO;
    }
    
    NSString *dylibString = [NSString stringWithUTF8String:dylibPath];
    
    // Legitimate Apple system paths
    NSArray *legitimatePaths = @[
        @"/System/Library/PrivateFrameworks/",
        @"/usr/lib/system/",
        @"/System/Library/Frameworks/",
        @"/Developer/",
        @"/Applications/Xcode.app/",
        @"libBacktraceRecording.dylib",
        @"libMainThreadChecker.dylib",
        @"IDEBundleInjection"
    ];
    
    for (NSString *legitimatePath in legitimatePaths) {
        if ([dylibString containsString:legitimatePath]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isJailBroken {
    // If we're in development environment, be more lenient
    if ([self isDevelopmentEnvironment]) {
        // Only check for obvious jailbreak signs, ignore environment variables
        return [self hasObviousJailbreakSigns];
    }
    
    // Use enhanced detection that includes palera1n support
    BOOL enhancedResult = [SafeDeviceJailbreakDetection isJailbroken];
    
    // If enhanced detection says jailbroken, double-check environment variables
    if (enhancedResult && [self hasLegitimateEnvironmentVariables]) {
        // Probably false positive from development environment
        return [self hasObviousJailbreakSigns];
    }
    
    // Fall back to DTT if enhanced detection doesn't detect anything
    if (!enhancedResult) {
        BOOL dttResult = [DTTJailbreakDetection isJailbroken];
        
        // If DTT says jailbroken, double-check environment variables
        if (dttResult && [self hasLegitimateEnvironmentVariables]) {
            // Probably false positive from development environment
            return [self hasObviousJailbreakSigns];
        }
        
        return dttResult;
    }
    
    return enhancedResult;
}

- (BOOL)hasObviousJailbreakSigns {
    // Check for obvious jailbreak files
    NSArray *jailbreakPaths = @[
        @"/Applications/Cydia.app",
        @"/Applications/Sileo.app",
        @"/Library/MobileSubstrate/MobileSubstrate.dylib",
        @"/bin/bash",
        @"/usr/sbin/sshd",
        @"/etc/apt",
        @"/private/var/lib/apt/",
        @"/var/jb",
        @"/var/jb/usr/bin/apt",
        @"/var/jb/usr/bin/sileo",
        @"/var/jb/usr/bin/palera1n"
    ];
    
    for (NSString *path in jailbreakPaths) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            return YES;
        }
    }
    
    // Check for URL schemes
    NSArray *schemes = @[@"cydia://", @"sileo://", @"palera1n://"];
    for (NSString *scheme in schemes) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:scheme]]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isJailBrokenCustom {
    // Use enhanced detection that includes palera1n support
    return [SafeDeviceJailbreakDetection isJailbroken];
}

- (NSDictionary*)getJailbreakDetails {
    BOOL isDev = [self isDevelopmentEnvironment];
    BOOL hasLegitEnvVars = [self hasLegitimateEnvironmentVariables];
    BOOL obviousJailbreak = [self hasObviousJailbreakSigns];
    
    // Get detailed detection results from enhanced detection
    NSDictionary *enhancedDetails = [SafeDeviceJailbreakDetection getJailbreakDetails];
    
    // Create combined result
    NSMutableDictionary *combinedResult = [NSMutableDictionary dictionaryWithDictionary:enhancedDetails];
    
    // Add legacy information for backward compatibility
    [combinedResult setObject:@(isDev) forKey:@"isDevelopmentEnvironment"];
    [combinedResult setObject:@(hasLegitEnvVars) forKey:@"hasLegitimateEnvironmentVariables"];
    [combinedResult setObject:@(obviousJailbreak) forKey:@"hasObviousJailbreakSigns"];
    [combinedResult setObject:@([DTTJailbreakDetection isJailbroken]) forKey:@"dttResult"];
    [combinedResult setObject:@([self isJailBroken]) forKey:@"finalResult"];
    
    return [combinedResult copy];
}

- (BOOL) isRealDevice{
    return !TARGET_OS_SIMULATOR;
}
@end
