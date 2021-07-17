#import "RangersAppLogModule.h"
#import <React/RCTLog.h>
#import <RangersAppLog/RangersAppLog.h>

@implementation RangersAppLogModule {
    NSString *appIdGlobal;
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
+ (BOOL) requiresMainQueueSetup {
    return YES;
}

RCT_EXPORT_MODULE(RangersAppLogModule)

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleOpenURL:)
                                                     name:@"RCTOpenURLNotification"
                                                   object:nil];
    }
    return self;
}

- (void)handleOpenURL:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    NSString *url = userInfo[@"url"];
    NSURL *URL = [NSURL URLWithString:url];
    if (![appIdGlobal isEqual: @""]) {
        [[BDAutoTrackSchemeHandler sharedHandler] handleURL:URL appID: appIdGlobal scene:nil];
    }
}

RCT_EXPORT_METHOD(init:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString *appId = @"";
    appIdGlobal = @"";
    NSString *appName = @"";
    NSString *channel = @"App Store";
    BOOL abEnable = YES;
    NSString *abEnableStr = @"true";
    BOOL showDebugLog = NO;
    NSString *showDebugLogStr = @"false";
    BOOL logNeedEncrypt = YES;
    NSString *logNeedEncryptStr = @"true";
  
    if ((NSString *)params[@"appId"] != nil) {
        appId = (NSString *)params[@"appId"];
        appIdGlobal = appId;
    }
    
    if ((NSString *)params[@"appName"] != nil) {
        appName = (NSString *)params[@"appName"];
    }
    
    if ((NSString *)params[@"channel"] != nil) {
        channel = (NSString *)params[@"channel"];
    }
    
    if ((NSString *)params[@"abEnable"] != nil) {
        abEnableStr = (NSString *)params[@"abEnable"];
        if([abEnableStr isEqual: @"true"]){
            abEnable = YES;
        } else {
            abEnable = NO;
        }
    }
    
    if ((NSString *)params[@"showDebugLog"] != nil) {
        showDebugLogStr = (NSString *)params[@"showDebugLog"];
        if([showDebugLogStr isEqual: @"true"]){
            showDebugLog = YES;
        } else {
            showDebugLog = NO;
        }
    }
    
    if ((NSString *)params[@"logNeedEncrypt"] != nil) {
        logNeedEncryptStr = (NSString *)params[@"logNeedEncrypt"];
        if([logNeedEncryptStr isEqual: @"true"]){
            logNeedEncrypt = YES;
        } else {
            logNeedEncrypt = NO;
        }
    }
    if (![appId isEqual: @""]) {
        BDAutoTrackConfig *config = [BDAutoTrackConfig configWithAppID: appId]; //如不清楚请联系专属客户成功经理
        /* 数据上报*/
        config.serviceVendor = BDAutoTrackServiceVendorCN;
        config.appName = appName; // 与您申请 APPID 时的 app_name 一致
        config.channel = channel; // iOS 一般默认 App Store
        config.abEnable = abEnable; //开启 ab 测试，默认为 YES
        config.showDebugLog = showDebugLog; // 是否在控制台输出日志，仅调试使用。release 版本请 设置为 NO
        config.logger = ^(NSString * _Nullable log) { NSLog(@"%@",log);};
        config.logNeedEncrypt = logNeedEncrypt; // 是否加密日志，默认加密。release 版本请设置为 YES
        [BDAutoTrack startTrackWithConfig:config];
    }
}

RCT_EXPORT_METHOD(onEventV3:(NSString *)event params:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  RCTLogInfo(@"%s", __func__);
  [BDAutoTrack eventV3:event params:params];
}

RCT_EXPORT_METHOD(setHeaderInfo:(NSDictionary *)customHeader resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  for (NSString *key in customHeader) {
      if ([key isKindOfClass:NSString.class]) {
          NSObject *val = customHeader[key];
          [BDAutoTrack setCustomHeaderValue:val forKey:key];
      }
  }
}

RCT_EXPORT_METHOD(setUserUniqueId:(NSString *)userUniqueID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  [BDAutoTrack setCurrentUserUniqueID:userUniqueID];
  resolve(userUniqueID);
}

RCT_REMAP_METHOD(getAbSdkVersion, getAbSdkVersionWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  NSString *allAbVids = [BDAutoTrack allAbVids];
  resolve(allAbVids);
}

RCT_REMAP_METHOD(getAllAbSdkVersion, getAllAbSdkVersionWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  NSString *allAbVids = [BDAutoTrack allAbVids];
  resolve(allAbVids);
}

RCT_REMAP_METHOD(getABTestConfigValueForKey, getABTestConfigValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  id ret = [BDAutoTrack ABTestConfigValueForKey:key defaultValue:defaultValue];
  resolve(ret);
}

RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(getABTestConfigValueForKeySync:(NSString *)key defaultValue:(NSString *)defaultValue) {
    return [BDAutoTrack ABTestConfigValueForKey:key defaultValue:defaultValue];
}

RCT_REMAP_METHOD(getDeviceID, getDeviceIDWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  // RCTLogInfo(@"[Native]: %s", __func__);
  NSString *did = [BDAutoTrack rangersDeviceID];
  // RCTLogInfo(@"[Native]: %@", did);
  resolve(did);
}

RCT_REMAP_METHOD(getUserUniqueID, getUserUniqueIDWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  // RCTLogInfo(@"[Native]: %s", __func__);
  NSString *did = [BDAutoTrack userUniqueID];
  // RCTLogInfo(@"[Native]: %@", did);
  resolve(did);
}

RCT_REMAP_METHOD(getSsid, getSsidWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  // RCTLogInfo(@"[Native]: %s", __func__);
  NSString *did = [BDAutoTrack ssID];
  // RCTLogInfo(@"[Native]: %@", did);
  resolve(did);
}

// Example method
// See // https://reactnative.dev/docs/native-modules-ios
RCT_REMAP_METHOD(multiply,
                 multiplyWithA:(nonnull NSNumber*)a withB:(nonnull NSNumber*)b
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)
{
  NSNumber *result = @([a floatValue] * [b floatValue]);

  resolve(result);
}

@end
