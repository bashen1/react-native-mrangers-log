//
//  BDAutoTrack+Extension.h
//  RangersAppLog
//
//  Created by bytedance on 9/27/22.
//

#import "BDAutoTrack.h"

NS_ASSUME_NONNULL_BEGIN


@protocol BDTrackerEventBuilder <NSObject>


/*!
 @abstract 添加自定义参数
 
 @since 6.14.0
 
 @param parameters  埋点参数，参数必须是有效的JSON对象， [NSJSONSerialization isValidJSONObject:parameters]

 @discussion 允许多次调用，参数之间根据调用时序，相当于多次调用 addEntriesFromDictionary 进行添加以及覆盖
 
 @code
 
 [[[[[BDAutoTrack sharedTrack] eventBuilder:@"event_to_track"]
       addParameters:@{@"parameter1":@(1)}]
   addParameters:@{@"parameters2":@"2"}]
  track];

 @endcode
 
 */
- (id<BDTrackerEventBuilder>)addParameters:(NSDictionary<NSString *, id> *)parameters;

/*!
 @abstract 添加 A/BTesting实验分组信息
 
 @since 6.14.0
 
 @param vids  AB实验结果，多个实验用 ' , ' 分割

 @discussion AB实验分组信息只会影响目标埋点，不会影响全局的曝光区域
 
 @code
 
 [[[BDAutoTrack.sharedTrack eventBuilder:@"event_to_track"]
   additionalABVids:@"vid1,vid2"]
  track];

 @endcode
 
 */
- (id<BDTrackerEventBuilder>)addABTestingExperiments:(NSString *)vids;


/*!
 
 @abstract 记录埋点
 
 @since 6.14.0
 
 @discussion BDTrackerEventBuilder 在没有调用 track 时，仅缓存相关信息，并不会完成埋点记录
 
 */
- (void)track;

@end

@protocol BDTrackerEventJsonCallback <NSObject>

- (void)pageJson:(nullable NSDictionary *)eventJson isEntryPage:(BOOL)isEntryPage;
- (void)launchJson:(nullable NSDictionary *)eventJson;
- (void)eventJson:(nonnull NSString *)eventName eventJson:(nullable NSDictionary *)eventJson;

@end

@protocol BDTrackerEventDropStrategy <NSObject>

@optional

/// 数据库缓存条数
/// @return 缓存条数，最小值为 2000 条，默认无限制，返回 0 和 -1 表示无限制
- (int)eventDBCacheCount;

/// 上报丢弃超时时长
/// @return 超时时长，最小值为 1 天，默认无限制，返回 0 和 -1 表示无限制
- (int)reportTimeoutInDay;

/// 判断是否允许重试（不允许重试则删除）
/// @return 允许重试的最大次数，最小值为 1 次，默认无限制，返回 -1 表示无限制
- (int)reportMaxRetryTimes;

@end

@interface BDAutoTrack (Extension)

@property (nonatomic, strong) id<BDTrackerEventJsonCallback> eventJsonCallback;
@property (nonatomic, strong) id<BDTrackerEventDropStrategy> eventDropStrategy;

/*!
 @abstract 创建 BDTrackerEventBuilder 对象，支持链式调用
 
 @since 6.14.0
 
 @param event event primary key
 
 @return 返回 BDTrackerEventBuilder 对象
 
*/
- (id<BDTrackerEventBuilder>)eventBuilder:(nonnull NSString *)event;


/*!
 @abstract 埋点的扩展方法
 
 @since 6.14.0
 
 @param event event primary key
 
 @param parameters  埋点参数，参数必须是有效的JSON对象， [NSJSONSerialization isValidJSONObject:parameters]
 
 @param option  埋点的配置
 
 
*/
- (void)trackEvent:(NSString *)event
        parameters:(NSDictionary *)parameters
            option:(id)option;

- (int)eventDBCacheCount;

- (int)reportTimeoutInDay;

- (int)reportMaxRetryTimes;

@end

NS_ASSUME_NONNULL_END
