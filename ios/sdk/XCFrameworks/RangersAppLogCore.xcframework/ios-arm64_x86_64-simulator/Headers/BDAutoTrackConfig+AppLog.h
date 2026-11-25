//
//  BDAutoTrackConfig+AppLog.h
//  RangersAppLog
//
//  Created by bob on 2020/3/25.
//

#import "BDAutoTrackConfig.h"
#import "BDCommonDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface BDAutoTrackConfig (AppLog)

/*! @abstract 是否开启事件上报，默认YES，关闭后任何事件包括用户自定义事件都不会上报
 @discussion 有些客户只需要ABTest功能，不需要任何事件上报，包括曝光事件，可以通过这个关闭
 */
@property (nonatomic, assign) BOOL trackEventEnabled;

/*! @abstract 是否开启无埋点。同时需要在Tea配置。
 @discussion 如果设置NO且Tea平台配置NO，则不会采集无埋点事件
 @discussion 如果设置NO且Tea平台配置YES，则不会采集无埋点事件
 @discussion 如果设置YES且Tea平台配置NO，则拉取配置成功后停止采集无埋点事件
 @discussion 如果设置YES且Tea平台配置YES，则采集无埋点事件
 */
@property (nonatomic, assign) BOOL autoTrackEnabled;

/*! @abstract 配置全埋点事件类型，默认 BDAutoTrackDataTypePage | BDAutoTrackDataTypeClick
 @discussion 用法：config.autoTrackEventType = BDAutoTrackDataTypePage | BDAutoTrackDataTypeClick | BDAutoTrackDataTypePageLeave;
 */
@property (nonatomic, assign) BDAutoTrackDataType autoTrackEventType;

/*! @abstract 是否移除原生全埋点事件中的页面标题字段，默认关闭(NO)
 @discussion 开启后，页面进入/离开事件移除 page_title、refer_page_title，点击事件移除 page_title
 @discussion 仅影响原生 UITracker 事件，不影响 H5/Web 事件
 @discussion 请在创建 BDAutoTrack 实例前完成配置
 */
@property (nonatomic, assign) BOOL pageTitleRemoveEnabled;

/*! @abstract 是否开启无埋点列表点击动态代理兼容逻辑，默认NO。
 @discussion 用于兼容 UITableView/UICollectionView delegate 被三方 SDK 动态子类化且原始对象依赖 forwardInvocation 转发的场景。
 @discussion 该能力为进程级兼容开关，开启后同进程内保持开启；未开启时保持原有无埋点列表点击 swizzle 逻辑。
 */
@property (nonatomic, assign) BOOL autoTrackDelegateProxyForwardingEnabled;

/*! @abstract 当无埋点开关开启时，是否采集H5页面的无埋点事件，默认开(YES)
 */
@property (nonatomic) BOOL H5AutoTrackEnabled;

/*! @abstract 是否采集屏幕方向，默认不采集(NO)
 */
@property (nonatomic) BOOL screenOrientationEnabled;

/*! @abstract 是否采集GPS，默认不采集(NO)
 */
@property (nonatomic) BOOL trackGPSLocationEnabled;

/*! @abstract 是否自动激活。默认YES，一般情况请不要修改 */
@property (nonatomic, assign) BOOL autoActiveUser;

/*! @abstract 采集事件的时候输出日志，在控制台中可以查看
 @discussion 需要同时设置logger，因为NSLog低效，且在iOS 13中有问题。release版本请设置为NO
 */
@property (nonatomic, assign) BOOL showDebugLog;

/*! @abstract 采集事件的时候输出日志，在控制台中可以查看
 @discussion logger为nil，则不会输出日志
 */
@property (nonatomic, copy, nullable) BDAutoTrackLogger logger;

/*! @abstract 日志上报是否加密。用于debug情况可以抓包调试 */
@property (nonatomic, assign) BOOL logNeedEncrypt;
/*! @abstract 响应是否加密 */
@property (nonatomic, assign) BOOL logResponseNeedEncrypt;
/*! @abstract 是否开启打包优化功能 */
@property (nonatomic, assign) BOOL logReportOptimizeEnabled;

/*! @abstract 是否自动拉配置。默认YES，一般情况请不要修改。仅私有化部署情况，可能不需要自动拉取配置 */
@property (nonatomic, assign) BOOL autoFetchSettings;

/*! @abstract 是否开AB。默认YES，一般情况请不要修改 */
@property (nonatomic, assign) BOOL abEnable;

/*! @abstract 是否采集 launch & terminate 埋点。默认YES，一般情况请不要修改 */
@property (nonatomic, assign) BOOL launchTerminateEnable;

/*! @abstract 新用户模式下，mock idfv 数据 */
@property (nonatomic, copy) BDAutoTrackMockBlock mockVendorIDBlock;

/*! @abstract 新用户模式下，mock advertisingID 数据 */
@property (nonatomic, copy) BDAutoTrackMockBlock mockAdvertisingIDBlock;

@end

NS_ASSUME_NONNULL_END
