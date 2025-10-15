#import <Foundation/Foundation.h>

@protocol SafeDeviceConfigProtocol <NSObject>
@end

@interface SafeDeviceConfig : NSObject <SafeDeviceConfigProtocol>

@property (nonatomic, assign) BOOL mockLocationCheckEnabled;

- (instancetype)initWithMockLocationCheckEnabled:(BOOL)mockLocationCheckEnabled;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

@implementation SafeDeviceConfig

- (instancetype)initWithMockLocationCheckEnabled:(BOOL)mockLocationCheckEnabled {
    self = [super init];
    if (self) {
        _mockLocationCheckEnabled = mockLocationCheckEnabled;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        NSNumber *mockLocation = dict[@"mockLocationCheckEnabled"];
        if (mockLocation && [mockLocation isKindOfClass:[NSNumber class]]) {
            _mockLocationCheckEnabled = [mockLocation boolValue];
        } else {
            _mockLocationCheckEnabled = NO;
        }
    }
    return self;
}

@end
