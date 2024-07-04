////
////  LagMonitor.m
////  oceanAppV3
////
////  Created by 方德翔 on 2024/6/29.
////
//
///*卡顿原因及解决方案
// 1、可能的原因：
// 长时间的主线程同步任务，例如大量数据的计算、I/O 操作或网络请求
// 复杂UI布局，例如图文混排
// 资源竞争，多个线程同时访问共享资源时，如果没有合适地加锁或使用其他同步机制
// 主线程被其他高优先级任务占用时，例如系统任务或后台任务
//
// 2、解决方案：
// 使用 Instruments 工具进行性能分析和检测。
// 在主线程上避免执行耗时操作，尤其是 I/O 操作、网络请求等，可以将这些操作放到后台线程或使用异步方式执行。
// 合理分段长时间运行的任务，避免长时间的单次执行。
// 在 UI 操作方面，尽量减少不必要的 UI 更新操作，使用合适的方式优化界面性能。
// 使用 GCD 或 Operation Queue 等多线程技术，合理管理并发任务，避免资源竞争和死锁。
// 在主线程中优先处理用户交互事件和 UI 更新，避免被其他低优先级任务占用。
//
// 3 卡顿检测
// 主流方案：主线程卡顿监控。通过开辟一个子线程来监控主线程的 RunLoop，当两个状态区域之间的耗时大于阈值时，就记为发生一次卡顿。
// 实现思路：开辟一个子线程，然后实时计算 kCFRunLoopBeforeSources 和 kCFRunLoopAfterWaiting
// 两个状态区域之间的耗时是否超过某个阀值，来断定主线程的卡顿情况，如果主线程发生卡顿，这时我们要保存应用的上下文，即卡顿发生时程序的堆栈调用和运行日志上传。
// */
//#import "LagMonitor.h"
//#import <CoreFoundation/CoreFoundation.h>
//
//@implementation LagMonitor {
//    id _observer;
//    dispatch_semaphore_t _semaphore;
//    BOOL _isMonitoring;
//}
//
//+ (instancetype)sharedInstance {
//    static LagMonitor *instance;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[LagMonitor alloc] init];
//    });
//    return instance;
//}
//
//- (void)startMonitoring {
//    if (_isMonitoring) {
//        return;
//    }
//    
//    _isMonitoring = YES;
//    
//    // 创建信号量，用于控制RunLoop监测的时间间隔
//    _semaphore = dispatch_semaphore_create(0);
//    
//    // 创建观察者，监听RunLoop的各个阶段
//    _observer = [NSRunLoopObserver
//                 observerWithActivity:NSRunLoopAllActivities
//                 repeats:YES
//                 callback:^(NSRunLoopObserver *observer, NSRunLoopActivity activity) {
//                     [self runLoopObserverCallback];
//                 }];
//
//    if (_observer) {
//        // 将观察者添加到主线程的RunLoop中
//        [[NSRunLoop mainRunLoop] addObserver:_observer];
//    
//        // 创建一个子线程用于监测RunLoop的状态
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            while (_isMonitoring) {
//                // 等待信号量，即等待指定的时间间隔
//                long semaphoreWait = dispatch_semaphore_wait(_semaphore, dispatch_time(DISPATCH_TIME_NOW, 50 * NSEC_PER_MSEC));
//                if (semaphoreWait != 0) {
//                    // 如果信号量等待超时，则认为主线程出现卡顿
//                    [BacktraceLogger printMainThreadStack];
//                }
//            }
//        });
//    } else {
//        NSLog(@"创建 NSRunLoopObserver 失败");
//    }
//}
//
//- (void)runLoopObserverCallback {
//    // 发送信号量，通知子线程主线程的RunLoop正在运行
//    dispatch_semaphore_signal(_semaphore);
//}
//
//@end
//
//// CFRunLoopObserverCreate
////@implementation LagMonitor {
////    CFRunLoopObserverRef _observer;
////    dispatch_semaphore_t _semaphore;
////    BOOL _isMonitoring;
////}
////
////+ (instancetype)sharedInstance {
////    static LagMonitor *instance;
////    static dispatch_once_t onceToken;
////    dispatch_once(&onceToken, ^{
////        instance = [[LagMonitor alloc] init];
////    });
////    return instance;
////}
////
////- (void)startMonitoring {
////    if (_isMonitoring) {
////        return;
////    }
////    
////    _isMonitoring = YES;
////    
////    // 创建信号量，用于控制RunLoop监测的时间间隔
////    _semaphore = dispatch_semaphore_create(0);
////    
////    // 创建观察者，监听RunLoop的各个阶段
////    CFRunLoopObserverContext context = {0, (__bridge void *)self, NULL, NULL, NULL};
////    _observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &runLoopObserverCallback, &context);
////    if (_observer) {
////        // 将观察者添加到主线程的RunLoop中
////        CFRunLoopAddObserver(CFRunLoopGetMain(), _observer, kCFRunLoopCommonModes);
////        
////        // 创建一个子线程用于监测RunLoop的状态
////        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
////            while (_isMonitoring) {                // 等待信号量，即等待指定的时间间隔
////                long semaphoreWait = dispatch_semaphore_wait(_semaphore, dispatch_time(DISPATCH_TIME_NOW, 50 * NSEC_PER_MSEC));
////                if (semaphoreWait != 0) {
////                    // 如果信号量等待超时，则认为主线程出现卡顿
////                    [BacktraceLogger printMainThreadStack];
////                }
////            }
////        });
////    } else {
////        NSLog(@"创建 CFRunLoopObserverRef 失败");
////    }
////}
////
////void runLoopObserverCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
////    LagMonitor *monitor = (__bridge LagMonitor *)info;
////    // 发送信号量，通知子线程主线程的RunLoop正在运行
////    dispatch_semaphore_signal(monitor->_semaphore);
////}
////
////@end
