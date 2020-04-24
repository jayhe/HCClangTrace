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

@end

NS_ASSUME_NONNULL_END
