//
//  LagMonitor.h
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LagMonitor : NSObject
+ (instancetype)sharedInstance;
- (void)startMonitoring;
@end

NS_ASSUME_NONNULL_END
