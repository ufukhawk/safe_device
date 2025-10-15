#import <Foundation/Foundation.h>

@protocol SafeDeviceConfigProtocol <NSObject>
@end

@interface SafeDeviceConfig : NSObject <SafeDeviceConfigProtocol>

@property (nonatomic, assign) BOOL mockLocationCheckEnabled;

- (instancetype)initWithMockLocationCheckEnabled:(BOOL)mockLocationCheckEnabled;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
