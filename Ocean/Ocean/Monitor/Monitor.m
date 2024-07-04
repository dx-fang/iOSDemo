//
//  Monitor.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/10.
//


/*
 这种模式通常用于监控和分析应用的性能，特别是RunLoop的行为，或者用于在主线程的RunLoop中定期执行任务。
 通过观察者和定时器，开发者可以获取关于RunLoop状态的详细信息，或者确保某些任务按预定频率执行。
 */

#import "Monitor.h"

@interface Monitor()
/** thread */
@property (nonatomic, strong) NSThread *monitorThread;
/** 是否正在执行 */
@property (nonatomic, assign, getter=isExecuting) BOOL executing; // 是否正在执行的标志
@end

@implementation Monitor
CFRunLoopObserverRef _observer; // observer
CFRunLoopTimerRef _timer; // 定时器

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static Monitor *instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        [instance monitorThread];
    });
    return instance;
}

- (void)monitorThread {
    self.monitorThread = [[NSThread alloc] initWithTarget:self selector:@selector(monitorThreadEntryPoint:) object:nil];
    [self.monitorThread start];
}

- (void)monitorThreadEntryPoint:(id)__unused object {
    @autoreleasepool {
        // Setup code for monitoring
    }
}

// 创建和启动线程，在线程内启动RunLoop
+ (void)monitorThreadEntryPoint {
    [[NSThread currentThread] setName:@"Monitor"];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    [runLoop run];
}

// 创建并启动线程，在线程内启动RunLoop并添加观察者和定时器
- (void)startMonitor {
    if (!_observer) {
        CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
        _observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &runLoopObserverCallBack, &context);
        CFRunLoopAddObserver(CFRunLoopGetMain(), _observer, kCFRunLoopDefaultMode);
    }
    if (!_timer) {
//        _timer = CFRunLoopTimerCreate(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + 1, 0.1, 0, 0, &runLoopObserverCallBack, NULL);
//        CFRunLoopAddTimer(CFRunLoopGetMain(), _timer, kCFRunLoopCommonModes);
    }
}

#pragma mark 添加定时器到监控线程
- (void)addTimerToMonitorThread {
    CFRunLoopRef currentRunLoop = CFRunLoopGetCurrent();
    CFRunLoopTimerContext timerContext = {0, (__bridge void *)(self), NULL, NULL, NULL};
//    CFRunLoopTimerRef timer = CFRunLoopTimerCreate(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + 0.01, 0.01, 0, 0, &runLoopObserverCallBack, &timerContext);
//    CFRunLoopAddTimer(currentRunLoop, timer, kCFRunLoopCommonModes);
}

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    switch (activity) {
        case kCFRunLoopEntry:
            NSLog(@"kCFRunLoopEntry");
            break;
        case kCFRunLoopBeforeTimers:
            NSLog(@"kCFRunLoopBeforeTimers");
            break;
        case kCFRunLoopBeforeSources:
            NSLog(@"kCFRunLoopBeforeSources");
            break;
        case kCFRunLoopBeforeWaiting:
            NSLog(@"kCFRunLoopBeforeWaiting");
//            NSData *monitorStartDate = [NSDate date];
            NSLog(@"monitoring = NO");
//            monitoring = NO;
            break;
        case kCFRunLoopAfterWaiting:
            NSLog(@"kCFRunLoopAfterWaiting");
            break;
        case kCFRunLoopExit:
            NSLog(@"kCFRunLoopExit");
            break;
        default:
            NSLog(@"Unknown RunLoop Activity");
            break;
    }
}

// 任务加到block，放入数组，每次从数组里取
- (void)createTaskList {
    // 创建存储任务的数组
    NSMutableArray<void (^)(void)> *tasks = [[NSMutableArray alloc] init];

    // 添加任务1
    [tasks addObject:[^{
        NSLog(@"执行任务1");
    } copy]];

    // 添加任务2
    [tasks addObject:[^{
        NSLog(@"执行任务2");
    } copy]];

    // 添加任务3
    [tasks addObject:[^{
        NSLog(@"执行任务3");
    } copy]];

    // 遍历数组并执行每个任务
    for (void (^taskBlock)(void) in tasks) {
        taskBlock();
    }
}
@end

