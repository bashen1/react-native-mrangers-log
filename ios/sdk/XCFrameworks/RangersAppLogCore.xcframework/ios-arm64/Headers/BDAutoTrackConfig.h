//
//  BDAutoTrackConfig.h
//  RangersAppLog
//
//  Created by bob on 2020/3/25.
//

#import <Foundation/Foundation.h>
#import "BDCommonDefine.h"
#import "BDCommonEnumDefine.h"
#import "BDAutoTrackEncryptionDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface BDAutoTrackConfig : NSObject

/*! @abstract channel默认 @"App Store", Release版本只有 @"App Store"， debug版本可以任意设置. */
@property (nonatomic, copy) NSString *channel;

/*! @abstract 申请appID时候填写的英文名称 */
@property (nonatomic, copy, nullable) NSString *appName;

/*! @abstract AppID，非空，必须设置 */
@property (nonatomic, copy) NSString *appID;

/*! @abstract 默认国内,初始化时一定要传正确的值
 @discussion 发生变化时候请调用 `+[BDAutoTrack setServiceVendor:]`更新值
 @discussion 会影响注册和日志上报。所以如果发生变化后，下次启动初始化请传入正确的值
 */
@property (nonatomic, copy) BDAutoTrackServiceVendor serviceVendor;

/*! @abstract 是否开启 WKWebView 的 H5 打通功能，开启后，若WebView页面的JS AppLog SDK侧也配置开启H5Bridge，则H5 埋点将可以从 Native 端上报。默认关闭。
 */
@property (nonatomic) BOOL enableH5Bridge;

/*! @abstract 是否开启ALink的延迟场景。默认关闭。 */
@property (nonatomic) BOOL enableDeferredALink;

/*! H5Bridge功能域名白名单。只有名单中的页面会开启Bridge。支持通配符。
 * @code
 * config.H5BridgeAllowedDomainPatterns = @[@"*.myapp.com", @"myapp.com"];
*/
@property (nonatomic, copy) NSArray<NSString *> *H5BridgeAllowedDomainPatterns;

/*! 当切换用户时，清除AB Versions缓存。默认为开(YES)。
 */
@property (nonatomic) BOOL clearABCacheOnUserChange;

/*!
 *  用户可以自定义部分 HTTPHeaderFields
 *  请求自身协议类型 Content-Encoding, Content-Type 等无法替换
 *
*/
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *HTTPHeaderFields;

@property (nullable, nonatomic, copy) NSDictionary<NSString*, NSString *> *_Nullable (^setHTTPHeaderFieldsBlock)(void);



@property (nonatomic) BOOL monitorEnabled;

/*! 采集 crash 信息。默认为关(NO)。
 */
@property (nonatomic) BOOL trackCrashEnabled;

/*!
 * 允许所有的域名开启H5Bridge
 * 默认为 NO
 * @code
 * config.H5BridgeDomainAllowAll = YES;
*/
@property (nonatomic, assign) BOOL H5BridgeDomainAllowAll;

/*!
 *  H5 Bridge 注入 `from_web_sdk=1` 标记开关，默认关闭 (NO)。
 *  开启后，AppLogBridge.onEventV3 透传上来的事件 params 会自动带上 `from_web_sdk = 1` 字段，
 *  便于上游 / DevTools / 服务端区分 H5 与客户端事件来源。客户端原生事件不带此字段。
 *  与 Android `InitConfig.setInjectFromH5Enabled(true)` 对齐。
 * @code
 * config.injectFromH5Enabled = YES;
 * @endcode
 */
@property (nonatomic, assign) BOOL injectFromH5Enabled;

/**
 * 是否支持 web 打通场景下 web 侧更新 uuid / uuidType，默认支持
 */
@property (nonatomic, assign) BOOL useBridgeUpdateUUIDEnabled;
/*! 应用启动选项 */
@property (nonatomic, readonly) NSDictionary<id, id> *launchOptions;

/*! @abstract Define custom encryption method (or custom encryption key)
 @discussion SDK不持有该对象。传入前须确保该对象在SDK使用期间不被释放，请勿传入临时对象。
 SDK will not hold the delegate. Please ensure the delegate's liveness during SDK's usage. Do not pass temporary object.
 */
@property (nonatomic, weak) id<BDAutoTrackEncryptionDelegate> encryptionDelegate;

@property (nonatomic, assign) BDAutoTrackEncryptionType encryptionType;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/*! @abstract 根据App ID获取一个config
@param appID 注册应用时获取的AppID
@param launchOptions 应用启动选项，一般直接传入`application:didFinishLaunchingWithOptions:`的`launchOptions`参数即可
*/
+ (instancetype)configWithAppID:(NSString *)appID launchOptions:(nullable NSDictionary<id,id> *)launchOptions APPLOG_API_AVALIABLE(6.0.0);


/*!
 *
 * @abstract 开启DevTools 监控功能
 * @discussion 线上版本请勿开启、对性能有一定影响
 *
 * 默认为 NO
 * @code
 *  config.devToolsEnabled = YES;
 * @endcode
*/
@property (nonatomic, assign) BOOL devToolsEnabled;

/*!
 * @abstract 是否开启 DevTools 事件缓存并发保护，默认为 NO。
 * @discussion 仅在 devToolsEnabled 为 YES 时生效。必须在创建 BDAutoTrack 实例前设置，不支持运行时切换。
 * 开启后按 tracker 隔离缓存，同步保护读写，并向展示层提供事件副本。
 * @code
 *  config.devToolsEventCacheThreadSafetyEnabled = YES;
 * @endcode
 */
@property (nonatomic, assign) BOOL devToolsEventCacheThreadSafetyEnabled;


/*!
 *
 * @abstract 新用户模式
 * @discussion 用于归因相关的测试，开启后会重置标识数据 (deviceId / installId)，并且mock部分系统设备标识数据
 *
 * 默认为 NO
 * @code
 *  config.newUserMode = YES;
 * @endcode
*/
@property (nonatomic, assign) BOOL newUserMode;


/*!
 *
 * @abstract 实验曝光频控
 * @discussion 设置为NO时对当前会话内的相同key的曝光不再重复上报
 *
 * 默认为 YES
 * @code
 *  config.isAbtestExposureEventRepeatEnabled = NO;
 * @endcode
*/
@property (nonatomic, assign) BOOL isAbTestExposureEventRepeatEnabled;

@end





@interface BDAutoTrackConfig (API_DEPRECATED)

+ (instancetype)configWithAppID:(NSString *)appID APPLOG_API_DEPRECATED_WITH_REPLACEMENT("configWithAppID:launchOptions:");

@property (nonatomic, copy, nullable) NSString *initialUserUniqueID APPLOG_API_DEPRECATED_WITH_REPLACEMENT("use BDAutoTrack.setCurrentUserUniqueID:withType Instead");

@property (nonatomic, copy, nullable) NSString *initialUserUniqueIDType APPLOG_API_DEPRECATED_WITH_REPLACEMENT("use BDAutoTrack.setCurrentUserUniqueID:withType Instead");

@property (nonatomic, assign) BOOL rollback;


@end

NS_ASSUME_NONNULL_END
