#import "RangersAppLogModule.h"
#import <React/RCTLog.h>
#import <RangersAppLog/RangersAppLog.h>

//发生于应用已安装情况下，用户点击ALink时
#define ALINK_DATA_EVENT                   @"ALinkDataEvent"
//发生于应用首次启动（卸载重装也算）
#define ATTRIBUTION_DATA_EVENT             @"AttributionDataEvent"

static NSDictionary *attributionData;
static RCTBridge *bridgeCommon;

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

//事件处理
- (NSArray<NSString *> *)supportedEvents
{
    return @[ALINK_DATA_EVENT];
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
 }
 */
RCT_EXPORT_METHOD(init:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    appIdGlobal = @"";
    bridgeCommon = self.bridge;
    if ((NSString *)params[@"appId"] != nil) {
        appIdGlobal = (NSString *)params[@"appId"];
    }
}

/**
 设置是否自启动，如果用户已经授权的情况下设为true，否则设为false
 false的情况下必须在用户同意隐私弹窗后调用，否则不会存储和上报事件
 */
RCT_EXPORT_METHOD(start)
{
  // [[BDAutoTrack sharedTrack] startTrack];
    [BDAutoTrack startTrack];
}

/**
 统计事件埋点
 */
RCT_EXPORT_METHOD(onEventV3:(NSString *)event params:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  RCTLogInfo(@"%s", __func__);
  [[BDAutoTrack sharedTrack] eventV3:event params:params];
}

/**
 * 主动触发上报。SDK有频率限制，每10s最多可以触发一次
 */
RCT_EXPORT_METHOD(flush)
{
  [BDAutoTrack flush];
}

/**
 设置事件公共属性
 */
RCT_EXPORT_METHOD(setHeaderInfo:(NSDictionary *)customHeader resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  for (NSString *key in customHeader) {
      if ([key isKindOfClass:NSString.class]) {
          NSObject *val = customHeader[key];
          [[BDAutoTrack sharedTrack] setCustomHeaderValue:val forKey:key];
      }
  }
}

/**
 移除事件公共属性
 */
RCT_EXPORT_METHOD(removeHeaderInfo:(NSString *)customKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  [[BDAutoTrack sharedTrack] removeCustomHeaderValueForKey: customKey];
}

/**
 用户属性
 设置用户属性，存在则覆盖，不存在则创建
 */
RCT_EXPORT_METHOD(profileSet:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [[BDAutoTrack sharedTrack] profileSet: params];
}

/**
 用户属性
 设置用户属性，存在则不设置，不存在则创建，适合首次相关的用户属性，比如首次访问时间等
 */
RCT_EXPORT_METHOD(profileSetOnce:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [[BDAutoTrack sharedTrack] profileSetOnce: params];
}

/**
 用户属性
 设置数值类型的属性，可进行累加
 */
RCT_EXPORT_METHOD(profileIncrement:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [[BDAutoTrack sharedTrack] profileIncrement: params];
}

/**
 用户属性
 向用户的某个 List 类型的属性添加属性，比如爱好
 */
RCT_EXPORT_METHOD(profileAppend:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [[BDAutoTrack sharedTrack] profileAppend: params];
}

/**
 用户属性
 删除用户的属性
 */
RCT_EXPORT_METHOD(profileUnset:(NSString *)customKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [[BDAutoTrack sharedTrack] profileUnset: customKey];
}

/**
 设置UUID
 */
RCT_EXPORT_METHOD(setUserUniqueId:(NSString *)userUniqueID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [[BDAutoTrack sharedTrack] setCurrentUserUniqueID:userUniqueID];
    resolve(userUniqueID);
}

/**
 清空UUID
 */
RCT_EXPORT_METHOD(clearUserUniqueId)
{
    [[BDAutoTrack sharedTrack] setCurrentUserUniqueID:nil];
}

/**
 获取全部的实验 id
 */
RCT_REMAP_METHOD(getAbSdkVersion, getAbSdkVersionWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString *allAbVids = [[BDAutoTrack sharedTrack] allAbVids];
    resolve(allAbVids);
}

/**
 获取实验参数（异步）
 */
RCT_REMAP_METHOD(getABTestConfigValueForKey, getABTestConfigValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  id ret = [[BDAutoTrack sharedTrack] ABTestConfigValueForKey:key defaultValue:defaultValue];
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
    result = [[BDAutoTrack sharedTrack] performSelector:@selector(allABTestConfigs2)];
    resolve(result);
}

/**
 获取实验参数（同步）
 */
RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(getABTestConfigValueForKeySync:(NSString *)key defaultValue:(NSString *)defaultValue) {
    return [[BDAutoTrack sharedTrack] ABTestConfigValueForKey:key defaultValue:defaultValue];
}

/**
 获取设备ID
 */
RCT_REMAP_METHOD(getDeviceID, getDeviceIDWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  // RCTLogInfo(@"[Native]: %s", __func__);
  NSString *did = [[BDAutoTrack sharedTrack] rangersDeviceID];
  // RCTLogInfo(@"[Native]: %@", did);
  resolve(did);
}

/**
 获取UUID
 */
RCT_REMAP_METHOD(getUserUniqueID, getUserUniqueIDWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  // RCTLogInfo(@"[Native]: %s", __func__);
  NSString *did = [[BDAutoTrack sharedTrack] userUniqueID];
  // RCTLogInfo(@"[Native]: %@", did);
  resolve(did);
}

/**
 获取SSID
 */
RCT_REMAP_METHOD(getSsid, getSsidWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  // RCTLogInfo(@"[Native]: %s", __func__);
  NSString *did = [[BDAutoTrack sharedTrack] ssID];
  // RCTLogInfo(@"[Native]: %@", did);
  resolve(did);
}

/**
 获取设备ID（同步）
 */
RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(getDeviceIDSync) {
    // RCTLogInfo(@"[Native]: %s", __func__);
  NSString *did = [[BDAutoTrack sharedTrack] rangersDeviceID];
    // RCTLogInfo(@"[Native]: %@", did);
  return did;
}

/**
获取UUID（同步）
*/
RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(getUserUniqueIDSync){
   // RCTLogInfo(@"[Native]: %s", __func__);
  NSString *did = [[BDAutoTrack sharedTrack] userUniqueID];
   // RCTLogInfo(@"[Native]: %@", did);
  return did;
}

/**
获取SSID（同步）
*/
RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(getSsidSync){
   // RCTLogInfo(@"[Native]: %s", __func__);
  NSString *did = [[BDAutoTrack sharedTrack] ssID];
  // RCTLogInfo(@"[Native]: %@", did);
  return did;
}

/**
 获取AttributionData
 */
RCT_REMAP_METHOD(getAttributionData, getAttributionDataWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    if (attributionData) {
        resolve(attributionData);
    } else {
        resolve(nil);
    }
}

/**
 把ALink url传给SDK
 */
RCT_EXPORT_METHOD(initALinkUrl: (NSString *)url)
{
    NSURL *URL = [NSURL URLWithString: url];
    [BDAutoTrack continueALinkActivityWithURL: URL];
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

+ (void) initializeSDK:(id<BDAutoTrackAlinkRouting>)aLinkRoutingDelegate launchOptions:(NSDictionary *)launchOptions appId:(NSString *)appId appName:(NSString *)appName channel:(NSString *)channel {
    BDAutoTrackConfig *config = [BDAutoTrackConfig configWithAppID:appId launchOptions:launchOptions];
    config.serviceVendor = BDAutoTrackServiceVendorCN; //数据上报
    config.appName = appName;  // 与您申请APPID时的app_name一致
    config.channel = channel; // iOS一般默认App Store
    config.abEnable = YES; //开启ab测试，默认为YES
    config.enableDeferredALink = YES; // 是否开启ALink的延迟场景,默认关闭
    
    config.logNeedEncrypt = YES; // 是否加密日志，默认加密。release版本请设置为 YES
    config.showDebugLog = NO; // 是否在控制台输出日志，仅调试使用，需要同时设置logger。release版本请设置为 NO
    // config.logger = ^(NSString * _Nullable log) {NSLog(@"%@",log);}; //如果 showDebugLog设置为 YES 请打开这里的注释
    
    [BDAutoTrack startTrackWithConfig: config]; //初始化
    [BDAutoTrack setALinkRoutingDelegate: aLinkRoutingDelegate]; // 调用顺序需要在初始化之后
    // [BDAutoTrack startTrack]; // 开始记录，注释掉也可以在模块中start开启【隐私合规之后】
}

/// Deferred deep link callback 根据回调返回的路由信息路由页面
/// 发生于应用首启时（包括卸载重装）
/// 目前这个与Android的触发时机不同，Android需要start后才归因，iOS是直接启动归因，所以在bundle未载入的时候，已经发送事件，但是js端未触发
/// @param routingInfo 路由信息
+ (void)onAttributionData:(nullable NSDictionary *)routingInfo error:(nullable NSError *)error {
    if (!error && routingInfo) {
        attributionData = routingInfo;
        [bridgeCommon enqueueJSCall:@"RCTDeviceEventEmitter"
                            method:@"emit"
                              args:@[ATTRIBUTION_DATA_EVENT, routingInfo]
                        completion:NULL];
    }
}

/// Deep link callback 根据回调返回的路由信息路由页面
/// 发生于应用已安装情况下，用户点击ALink时
/// @param routingInfo 路由信息
+ (void)onALinkData:(nullable NSDictionary *)routingInfo error:(nullable NSError *)error {
    if (!error && routingInfo) {
        [bridgeCommon enqueueJSCall:@"RCTDeviceEventEmitter"
                            method:@"emit"
                              args:@[ALINK_DATA_EVENT, routingInfo]
                        completion:NULL];
    }
}

@end
