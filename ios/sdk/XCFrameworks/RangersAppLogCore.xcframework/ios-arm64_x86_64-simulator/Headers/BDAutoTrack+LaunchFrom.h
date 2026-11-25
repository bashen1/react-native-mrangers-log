//
//  BDAutoTrack+LaunchFrom.h
//  RangersAppLog
//
//  Created by bob on 2020/6/3.
//

#import "BDAutoTrack.h"
#import "BDCommonDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface BDAutoTrack (LaunchFrom)

/*
 @abstract 初始化之后，支持设置APP的启动方式，会体现的上报的数据中，参考<RangersAppLog/BDCommonDefine.h>
 @discussion UIScene 应用在首次进入前台前，如宿主已确认本次为后台唤醒，
 请设置 BDAutoTrackLaunchFromBackground，避免将随后的首次前台误判为冷启动。
 */
+ (void)setLaunchFrom:(BDAutoTrackLaunchFrom)from;

@end

NS_ASSUME_NONNULL_END
