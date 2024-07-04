//
//  NSThreadVC.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/16.
//

#import "NSThreadVC.h"
#import "DXThread.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface NSThreadVC ()
@property (nonatomic, strong) DXThread *thread;
@property (nonatomic, assign, getter=isStoped) BOOL stopped;
@end

@implementation NSThreadVC

// NSThread给予了开发者较高的控制权，但相应地，也需要开发者自己管理线程的生命周期和资源。
- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"开启线程(start)" forState:UIControlEventTouchUpInside];
    button.frame = CGRectMake(60, 60, 40, 40);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(startThread:) forControlEvents:UIControlEventTouchUpInside];
    // 监听按钮点击
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"开启线程按钮被点击了");
    }];
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:@"开启线程（直接开启）" forState:UIControlEventTouchUpInside];
    button2.frame = CGRectMake(200, 60, 40, 40);
    button2.backgroundColor = [UIColor redColor];
    [button2 addTarget:self action:@selector(autoStartThread:) forControlEvents:UIControlEventTouchUpInside];
    // 监听按钮点击
    [[button2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"开启线程按钮被点击了（直接开启）");
    }];
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button3 setTitle:@"测试子线程是否会主动开启RunLoop" forState:UIControlEventTouchUpInside];
    button3.frame = CGRectMake(60, 200, 100, 40);
    button3.backgroundColor = [UIColor redColor];
    [button3 addTarget:self action:@selector(testRunLoop:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button4 setTitle:@"测试子线程是否会testthread开启RunLoop" forState:UIControlEventTouchUpInside];
    button4.frame = CGRectMake(60, 300, 100, 40);
    button4.backgroundColor = [UIColor redColor];
    [button4 addTarget:self action:@selector(testthread:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];
}

- (void)startThread:(UIButton *)sender {
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"startThread--%@",[NSThread currentThread]);
    }];
    [thread start];
    
    NSThread *thread2 = [[NSThread alloc] initWithBlock:^{
        NSLog(@"%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:2.0];
        NSLog(@"startThread22--%@",[NSThread currentThread]);
        /*
         waitUntilDone:参数控制当前线程是否需要等待performSelectorOnMainThread:withObject:waitUntilDone:方法执行完毕。
         如果设置为YES，当前线程将阻塞直到主线程中的方法执行完成；
         如果设置为NO，则不会等待。在更新UI的场景下，通常设置为NO。
         */
        [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];

    }];
    [thread2 start];
}

- (void)updateUI
{
    NSLog(@"startThread222--%@",[NSThread currentThread]);
    self.view.backgroundColor = [UIColor systemRedColor];
}

- (void)autoStartThread:(UIButton *)sender {
    [NSThread detachNewThreadWithBlock:^{
        NSLog(@"NSThread: 执行后台任务%@",[NSThread currentThread]);
    }];
}

// 线程没有开启runloop
- (void)testRunLoop:(UIButton *)sender {
//    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(test) object:nil];
//    [thread start];
//    [self performSelector:@selector(test) onThread:thread withObject:nil waitUntilDone:NO];
    __weak typeof(self) weakSelf = self;
    self.stopped = NO;
    self.thread = [[DXThread alloc] initWithBlock:^{
        NSLog(@"dx-begin-----%@", [NSThread currentThread]);
//        sleep(2000);
        // ① 获取/创建当前线程的 RunLoop
        // ② 向该 RunLoop 中添加一个 Source/Port 等来维持 RunLoop 的事件循环
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
//        while (weakSelf && !weakSelf.isStoped) {
//            // ③ 启动该 RunLoop
//            /*
//              [[NSRunLoop currentRunLoop] run]
//              如果调用 RunLoop 的 run 方法，则会开启一个永不销毁的线程
//              因为 run 方法会通过反复调用 runMode:beforeDate: 方法，以运行在 NSDefaultRunLoopMode 模式下
//              换句话说，该方法有效地开启了一个无限的循环，处理来自 RunLoop 的输入源 Sources 和 Timers 的数据
//            */
////            [[NSRunLoop currentRunLoop] run]; // 停不下来
//            // 以下两种哪些更好
////            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate init]];
//
//            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//        }
        NSLog(@"end-----%@", [NSThread currentThread]);
    }];
    [self.thread start];
}
- (void)testthread: (UIButton*)sender {
    dispatch_queue_t queue = dispatch_queue_create("123", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSLog(@"1");
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        //         创建定时器回调函数
        //        void (^timerCallback)(CFRunLoopTimerRef timer, void *info) = ^(CFRunLoopTimerRef timer, void *info) {
        //            NSLog(@"3");
        //            // 停止 RunLoop，结束任务
        //            CFRunLoopStop(CFRunLoopGetCurrent());
        //        };
        //
        //        // 创建定时器
        //        CFRunLoopTimerContext context = {0, NULL, NULL, NULL, NULL};
        //        CFRunLoopTimerRef timer = CFRunLoopTimerCreate(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + 2.0, 0, 0, 0, timerCallback, &context);
        //
        //        // 将定时器添加到当前 RunLoop
        //        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes);
        //
        //        // 启动 RunLoop，等待定时器触发
        //        CFRunLoopRun();
        //
        //        // 清理
        //        CFRelease(timer);
                
        //         向当前线程的 RunLoop 添加一个 NSPort 对象，保持 RunLoop 运行
        [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        [self performSelector:@selector(action) withObject:nil afterDelay:2.0];
        [runLoop run];
        NSLog(@"2");
    });
}

/*
 在串行队列 queue 上异步执行代码块。
 打印 "1"。
 使用 performSelector:withObject:afterDelay: 计划在未来某个时间点执行 action 方法。这里需要注意的是，performSelector:withObject:afterDelay: 方法将 action 方法的执行计划在当前线程的 RunLoop 中。由于代码块是在一个自定义的串行队列中执行的，并不是在主线程中，这个自定义队列的线程默认是没有启动 RunLoop 的。因此，action 方法实际上不会被执行，除非在这个串行队列的线程中手动启动 RunLoop。
 打印 "2"。
 综上所述，这段代码的输出将会是：12
 */
- (void)action {
    NSLog(@"3");
}

// 被执行的后台任务方法
- (void)doBackgroundWork {
    @autoreleasepool {
        // 在这里执行后台任务
        NSLog(@"NSThread: 执行后台任务 %@", [NSThread currentThread]);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.thread) return;
    [self performSelector:@selector(test) onThread:self.thread withObject:nil waitUntilDone:NO];
}


// 子线程需要执行的任务
- (void)test {
    NSLog(@"test--start:%s", __func__);
    NSLog(@"dx--testRunLoop on %@", [NSThread currentThread]);
    NSLog(@"dx--mainThread on %@, %d", [NSThread mainThread], [NSThread isMainThread], self.thread); // 1
    [NSThread sleepForTimeInterval:2];
    // 启动runloop--_CFRunLoopGet0,没有的话会自动创建
//    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    NSLog(@"end");
}

- (void)dealloc
{
    NSLog(@"func:%s, thread:%@, cur: %@", __func__, self.thread, [NSThread currentThread]);
    if (!self.thread) return;
    // 在子线程调用（waitUntilDone设置为YES，代表子线程的代码执行完毕后，当前方法才会继续往下执行）
    [self performSelector:@selector(stopThread) onThread:self.thread withObject:nil waitUntilDone:YES];
}
/*
 线程不存在：确保self.thread引用的线程对象确实存在。
 ·如果self.thread是nil或者引用的线程已经结束，尝试在这个线程上执行方法可能会导致问题。
 线程安全：如果stopThread方法中包含了线程不安全的操作，也可能导致崩溃。确保这个方法的实现考虑到了线程安全。
 */

// 停止子线程的 RunLoop
- (void)stopThread
{
    NSLog(@"stopThread");
    // 设置标记为 YES
    self.stopped = YES;
    // 停止 RunLoop
    CFRunLoopStop(CFRunLoopGetCurrent());
    NSLog(@"%s-----%@", __func__, [NSThread currentThread]);
    // 清空线程
    self.thread = nil;
}

@end
/*
 要在自定义线程中使用 `performSelector:withObject:afterDelay:` 方法，需要确保该线程有一个运行中的 RunLoop。以下是如何在自定义线程中加入 RunLoop 并使 `performSelector:withObject:afterDelay:` 正常工作的步骤：

 1. **创建并启动自定义线程**：首先，需要创建一个新的线程，在这个线程中启动一个 RunLoop。

 2. **在自定义线程中启动 RunLoop**：在新线程的执行方法中，启动一个 RunLoop 来处理定时器、输入源等事件。

 3. **使用 `performSelector:withObject:afterDelay:`**：一旦 RunLoop 启动，就可以在这个线程中使用 `performSelector:withObject:afterDelay:` 方法安排方法执行了。

 以下是一个示例代码，展示了如何在自定义线程中加入 RunLoop 并使用 `performSelector:withObject:afterDelay:`：

 ```objc
 - (void)startCustomThread {
     NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(runCustomThread) object:nil];
     [thread start];
 }

 - (void)runCustomThread {
     @autoreleasepool {
         // 向当前线程的 RunLoop 添加一个 NSPort 对象，保持 RunLoop 运行
         [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
         
         // 启动 RunLoop
         [[NSRunLoop currentRunLoop] run];
     }
 }

 - (void)testThread {
     [self performSelector:@selector(startCustomThread) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
     
     // 假设 customThread 是你已经创建并启动 RunLoop 的线程
     [self performSelector:@selector(action) onThread:customThread withObject:nil afterDelay:2.0];
 }

 - (void)action {
     NSLog(@"3");
 }
 ```

 在这个示例中，`startCustomThread` 方法创建并启动了一个新线程，然后在这个新线程中通过 `runCustomThread` 方法启动了一个 RunLoop。这样，当你在这个线程上调用 `performSelector:withObject:afterDelay:` 方法时，由于 RunLoop 已经在运行，所以 `action` 方法可以被正确地延迟执行。

 请注意，示例中的 `customThread` 应该是指向已经创建并且 RunLoop 已经启动的线程的变量。在实际应用中，你需要根据实际情况调整代码，确保 `performSelector:withObject:afterDelay:` 是在正确的线程上调用的。
 */
