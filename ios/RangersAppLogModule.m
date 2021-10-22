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

/**
 初始化SDK
 params
 {
     appId
     appName
     channel
     abEnable
     showDebugLog
     logNeedEncrypt
     host
     autoStart
 }
 */
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
    NSString *host = @"";
    BOOL autoStart = YES;
    NSString *autoStartStr = @"true";
  
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
        BDAutoTrackConfig *config;
        if ([BDAutoTrackConfig respondsToSelector:@selector(configWithAppID:launchOptions:)]) {
            config = [BDAutoTrackConfig configWithAppID:appId launchOptions:nil];
        } else {
            config = [BDAutoTrackConfig configWithAppID:appId];
        }
        /* 数据上报*/
        config.serviceVendor = BDAutoTrackServiceVendorCN;
        config.appName = appName; // 与您申请 APPID 时的 app_name 一致
        config.channel = channel; // iOS 一般默认 App Store
        config.abEnable = abEnable; //开启 ab 测试，默认为 YES
        config.showDebugLog = showDebugLog; // 是否在控制台输出日志，仅调试使用。release 版本请 设置为 NO
        config.logger = ^(NSString * _Nullable log) { NSLog(@"%@",log);};
        config.logNeedEncrypt = logNeedEncrypt; // 是否加密日志，默认加密。release 版本请设置为 YES
        [BDAutoTrack startTrackWithConfig:config];
        
        if ((NSString *)params[@"host"] != nil) {
            host = (NSString *)params[@"host"];
        }
        
        if ((NSString *)params[@"autoStart"] != nil) {
            autoStartStr = (NSString *)params[@"autoStart"];
            if([autoStartStr isEqual: @"false"]){
                autoStart = NO;
            } else {
                autoStart = YES;
            }
        }
        
        // 设置回调url
        if (host && host.length) {
            [[BDAutoTrack sharedTrack] setRequestHostBlock:^NSString * _Nullable(BDAutoTrackServiceVendor  _Nonnull vendor, BDAutoTrackRequestURLType requestURLType) {
                return host;
            }];
        }
        
        // 设置是否纪录，如果为false，请调用start，默认为true
        if (autoStart) {
            [[BDAutoTrack sharedTrack] startTrack];
        }
    }
}

/**
 设置是否自启动，如果用户已经授权的情况下设为true，否则设为false
 false的情况下必须在用户同意隐私弹窗后调用，否则不会存储和上报事件
 */
RCT_EXPORT_METHOD(start)
{
  [[BDAutoTrack sharedTrack] startTrack];
}

/**
 统计事件埋点
 */
RCT_EXPORT_METHOD(onEventV3:(NSString *)event params:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  RCTLogInfo(@"%s", __func__);
  [BDAutoTrack eventV3:event params:params];
}

/**
 设置事件公共属性
 */
RCT_EXPORT_METHOD(setHeaderInfo:(NSDictionary *)customHeader resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  for (NSString *key in customHeader) {
      if ([key isKindOfClass:NSString.class]) {
          NSObject *val = customHeader[key];
          [BDAutoTrack setCustomHeaderValue:val forKey:key];
      }
  }
}

/**
 移除事件公共属性
 */
RCT_EXPORT_METHOD(removeHeaderInfo:(NSString *)customKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  [BDAutoTrack removeCustomHeaderValueForKey: customKey];
}

/**
 用户属性
 设置用户属性，存在则覆盖，不存在则创建
 */
RCT_EXPORT_METHOD(profileSet:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [BDAutoTrack profileSet: params];
}

/**
 用户属性
 设置用户属性，存在则不设置，不存在则创建，适合首次相关的用户属性，比如首次访问时间等
 */
RCT_EXPORT_METHOD(profileSetOnce:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [BDAutoTrack profileSetOnce: params];
}

/**
 用户属性
 设置数值类型的属性，可进行累加
 */
RCT_EXPORT_METHOD(profileIncrement:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [BDAutoTrack profileIncrement: params];
}

/**
 用户属性
 向用户的某个 List 类型的属性添加属性，比如爱好
 */
RCT_EXPORT_METHOD(profileAppend:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [BDAutoTrack profileAppend: params];
}

/**
 用户属性
 删除用户的属性
 */
RCT_EXPORT_METHOD(profileUnset:(NSString *)customKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [BDAutoTrack profileUnset: customKey];
}

/**
 设置UUID
 */
RCT_EXPORT_METHOD(setUserUniqueId:(NSString *)userUniqueID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  [BDAutoTrack setCurrentUserUniqueID:userUniqueID];
  resolve(userUniqueID);
}

/**
 清空UUID
 */
RCT_EXPORT_METHOD(clearUserUniqueId)
{
  [BDAutoTrack setCurrentUserUniqueID:nil];
}

/**
 获取全部的实验 id
 */
RCT_REMAP_METHOD(getAbSdkVersion, getAbSdkVersionWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  NSString *allAbVids = [BDAutoTrack allAbVids];
  resolve(allAbVids);
}

/**
 获取全部的实验 id
 */
RCT_REMAP_METHOD(getAllAbSdkVersion, getAllAbSdkVersionWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  NSString *allAbVids = [BDAutoTrack allAbVids];
  resolve(allAbVids);
}

/**
 获取实验参数（异步）
 */
RCT_REMAP_METHOD(getABTestConfigValueForKey, getABTestConfigValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  id ret = [BDAutoTrack ABTestConfigValueForKey:key defaultValue:defaultValue];
  resolve(ret);
}

/**
 获取ABTest相关配置
 返回ABTest的所有的Configs值
 此接口不会触发曝光，可以随意读取。
 如果正常为了做实验，请勿使用此接口，请使用-[BDAutoTrack ABTestConfigValueForKey:defaultValue:]接口
 */
RCT_REMAP_METHOD(getAllAbTestConfigs, getAllAbTestConfigsWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    NSDictionary *result;
    result = [[BDAutoTrack sharedTrack] allABTestConfigs];
    resolve(result);
}

/**
 获取实验参数（同步）
 */
RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(getABTestConfigValueForKeySync:(NSString *)key defaultValue:(NSString *)defaultValue) {
    return [BDAutoTrack ABTestConfigValueForKey:key defaultValue:defaultValue];
}

/**
 获取设备ID
 */
RCT_REMAP_METHOD(getDeviceID, getDeviceIDWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  // RCTLogInfo(@"[Native]: %s", __func__);
  NSString *did = [BDAutoTrack rangersDeviceID];
  // RCTLogInfo(@"[Native]: %@", did);
  resolve(did);
}

/**
 获取UUID
 */
RCT_REMAP_METHOD(getUserUniqueID, getUserUniqueIDWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  // RCTLogInfo(@"[Native]: %s", __func__);
  NSString *did = [BDAutoTrack userUniqueID];
  // RCTLogInfo(@"[Native]: %@", did);
  resolve(did);
}

/**
 获取SSID
 */
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
