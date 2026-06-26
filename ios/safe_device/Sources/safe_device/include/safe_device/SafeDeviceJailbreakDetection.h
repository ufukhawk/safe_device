//
//  SafeDeviceJailbreakDetection.h
//  safe_device
//
//  Created for iOS jailbreak detection
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SafeDeviceJailbreakDetection : NSObject

/// Main jailbreak detection method
+ (BOOL)isJailbroken;

/// Get detailed breakdown of jailbreak detection methods
+ (NSDictionary<NSString *, NSNumber *> *)getJailbreakDetails;

@end

NS_ASSUME_NONNULL_END 