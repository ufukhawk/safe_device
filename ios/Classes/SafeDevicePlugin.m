#import "SafeDevicePlugin.h"
#import <DTTJailbreakDetection/DTTJailbreakDetection.h>

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
  }else if ([@"getJailbreakDetails" isEqualToString:call.method]) {
    result([self getJailbreakDetails]);
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

- (BOOL)isJailBroken{
    // Use both detection methods for enhanced reliability
    BOOL dtDetection = [DTTJailbreakDetection isJailbroken];
    BOOL customDetection = [self isJailBrokenCustom];
    return dtDetection || customDetection;
}

- (BOOL)isJailBrokenCustom{
    // Use runtime class resolution for Swift class
    Class swiftClass = NSClassFromString(@"SafeDeviceJailbreakDetection");
    if (swiftClass && [swiftClass respondsToSelector:@selector(isJailbroken)]) {
        return [swiftClass performSelector:@selector(isJailbroken)];
    }
    return NO;
}

- (NSDictionary*)getJailbreakDetails{
    // Get detailed breakdown of jailbreak detection methods
    Class swiftClass = NSClassFromString(@"SafeDeviceJailbreakDetection");
    if (swiftClass && [swiftClass respondsToSelector:@selector(getJailbreakDetails)]) {
        return [swiftClass performSelector:@selector(getJailbreakDetails)];
    }
    return @{};
}

- (BOOL) isRealDevice{
    return !TARGET_OS_SIMULATOR;
}
@end
