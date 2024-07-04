//
//  DXThread.h
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DXThread : NSThread
// TODO:?
// 保活：针对某一个线程,有其他方式么？
// NSoperation 操作与管理的是线程池,类似
// GCD：管理的是队列与线程池，可以
// NSCondition:条件锁--给线程加锁，不涉及到Runloop
@end

NS_ASSUME_NONNULL_END
