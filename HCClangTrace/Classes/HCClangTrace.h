//
//  HCClangTrace.h
//  RuntimeLearning
//
//  Created by 贺超 on 2020/4/24.
//  Copyright © 2020 hechao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCClangTrace : NSObject

/// 生成trace.order文件；一般我们要检测启动前执行的函数，所以放到首页的viewDidAppear中调用该函数
+ (void)generateOrderFile;
/// 获取APP的进程创建时间，可以根据这个时间来计算pre main的时间，可用于启动时间的统计
/// @discussion 返回的是毫秒为单位，保证精确度
+ (NSTimeInterval)getProcessStartTime;

@end

NS_ASSUME_NONNULL_END
