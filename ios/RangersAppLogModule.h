#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <RangersAppLog/RangersAppLog.h>

@interface RangersAppLogModule : RCTEventEmitter <RCTBridgeModule>
+ (void) initializeSDK:(id<BDAutoTrackAlinkRouting>)aLinkRoutingDelegate launchOptions:(NSDictionary *)launchOptions appId:(NSString *)appId appName:(NSString *)appName channel:(NSString *)channel;
+ (void)onAttributionData:(nullable NSDictionary *)routingInfo error:(nullable NSError *)error;
+ (void)onALinkData:(nullable NSDictionary *)routingInfo error:(nullable NSError *)error;
@end
