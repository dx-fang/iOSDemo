//
//  RunLoopViewController.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/23.
//

#import "RunLoopViewController.h"
#import <Aspects/Aspects.h>
#import "RunLoopThread.h"

@interface RunLoopViewController ()
@property (nonatomic, strong) RunLoopThread *thread;
@property (nonatomic, assign, getter=isStoped) BOOL stopped;
@end

@implementation RunLoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoDark];
    btn.frame = CGRectMake(100, 100, 300, 40);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"hook" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *nsString = @"perform加Runloop";
    CFStringRef cfString = (__bridge CFStringRef)nsString; // 将NSString转换为CFStringRef
    NSString *nsStringAgain = (__bridge NSString *)cfString; // 将CFStringRef转换回NSString
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeInfoDark];
    btn1.frame = CGRectMake(100, 200, 300, 40);
    btn1.backgroundColor = [UIColor redColor];
    [btn1 setTitle:nsString forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    [btn1 addTarget:self action:@selector(addPerform:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeInfoDark];
    btn2.frame = CGRectMake(100, 300, 300, 40);
    btn2.backgroundColor = [UIColor redColor];
    [btn2 setTitle:@"定时器加Runloop" forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    [btn2 addTarget:self action:@selector(addTimer:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeInfoDark];
    btn3.frame = CGRectMake(100, 350, 300, 40);
    btn3.backgroundColor = [UIColor redColor];
    [btn3 setTitle:@"addCADisplayLink加Runloop" forState:UIControlStateNormal];
    [self.view addSubview:btn3];
    [btn3 addTarget:self action:@selector(addDispatch:) forControlEvents:UIControlEventTouchUpInside];
   
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeInfoDark];
    btn4.frame = CGRectMake(100, 400, 300, 40);
    btn4.backgroundColor = [UIColor redColor];
    [btn4 setTitle:@"dispatch加Runloop" forState:UIControlStateNormal];
    [self.view addSubview:btn4];
    [btn4 addTarget:self action:@selector(addCADisplayLink:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setupHook];
}

- (void)clickBtn:(UIButton *)sender {
    NSLog(@"原始方法执行");
    // Foundation
    // 获取主线程/当前线程的 RunLoop 对象
    NSLog(@"NSRunLoop-mainRunLoop=%@", [NSRunLoop mainRunLoop]);
    NSLog(@"NSRunLoop-currentRunLoop=%@", [NSRunLoop currentRunLoop]);
    NSLog(@"CFRunLoopGetMain=%@", CFRunLoopGetMain());
    NSLog(@"CFRunLoopGetCurrent=%@", CFRunLoopGetCurrent());
}

- (void)setupHook {
    [self aspect_hookSelector:@selector(clickBtn) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        NSLog(@"clickBtn 被拦截，执行完毕");
    } error:nil];
}

- (void)addPerform:(UIButton *)sender {
    [self performSelector:@selector(addPerformMethod) withObject:nil afterDelay:3];
    // 使用`performSelector:withObject:afterDelay:`的变体
    // 除了最初提到的`performSelector:withObject:afterDelay:`方法外，还有一些相关的方法，如`performSelector:onThread:withObject:waitUntilDone:modes:`，它允许你指定执行方法的线程和RunLoop模式。
    [self performSelector:@selector(addPerformMethod2) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO modes:@[NSDefaultRunLoopMode]];
    
}

- (void)addPerformMethod {
    NSLog(@"performSelector方式=%@", [NSThread currentThread]);
}

- (void)addPerformMethod2 {
    NSLog(@"performSelector变体=%@", [NSThread currentThread]);
}

- (void)addTimer:(UIButton *)sender {
    //  这种方式创建的定时器需要手动添加到RunLoop中。`timerWithTimeInterval:target:selector:userInfo:repeats:`方法创建了一个定时器，但没有自动将其添加到RunLoop中，需要通过`addTimer:forMode:`方法手动添加。
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(timerMethod) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    // 自动添加到RunLoop， 使用`scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:`方法创建的定时器会被自动添加到当前RunLoop的默认模式（`NSDefaultRunLoopMode`）中。
    NSTimer *timer2 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerMethod2) userInfo:nil repeats:NO];
}

- (void)timerMethod {
    NSLog(@"定时器timewith方式=%@", [NSThread currentThread]);
}

- (void)timerMethod2 {
    NSLog(@"定时器scheduledtime方式=%@", [NSThread currentThread]);
}

/*
 使用`CADisplayLink`
 CADisplayLink`是一个特殊类型的定时器，用于同步屏幕刷新率进行定期调用。
 它通常用于高性能图形渲染和动画，确保动画的平滑性。
 */
- (void)addCADisplayLink:(UIButton *)sender  {
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(CADisplayLinkMethod)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)CADisplayLinkMethod {
    NSLog(@"定时器CADisplayLinkMethod方式");
    [self testRunLoopForOnce];
}

- (void)testRunLoopForOnce {
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(test) object:nil];
    [thread start];
    [self performSelector:@selector(test) onThread:thread withObject:nil waitUntilDone:NO];
        // 开启
}

- (void)test {
    NSLog(@"testRunLoop on %@", [NSThread currentThread]);
    [self keepAliveThread];
}
/*3. 使用`dispatch_after`和GCD
    虽然这种方式并不是直接添加到RunLoop中，但它提供了另一种延迟执行代码的方法，可以在某些情况下替代NSTimer。
  */

- (void)addDispatch:(UIButton *)sender {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // 延迟执行的代码
        NSLog(@"addDispatch");
    });
}

- (void)keepAliveThread {
    __weak typeof(self) weakSelf = self;
    
    self.stopped = NO;
    self.thread = [[RunLoopThread alloc] initWithBlock:^{
        NSLog(@"begin-----%@", [NSThread currentThread]);
        // ① 获取/创建当前线程的 RunLoop
        // ② 向该 RunLoop 中添加一个 Source/Port 等来维持 RunLoop 的事件循环
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
    
        while (weakSelf && !weakSelf.isStoped) {
            // ③ 启动该 RunLoop
            /*
              [[NSRunLoop currentRunLoop] run]
              如果调用 RunLoop 的 run 方法，则会开启一个永不销毁的线程
              因为 run 方法会通过反复调用 runMode:beforeDate: 方法，以运行在 NSDefaultRunLoopMode 模式下
              换句话说，该方法有效地开启了一个无限的循环，处理来自 RunLoop 的输入源 Sources 和 Timers 的数据
            */
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        NSLog(@"end-----%@", [NSThread currentThread]);
    }];
    [self.thread start];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.thread) return;
    [self performSelector:@selector(testAlive) onThread:self.thread withObject:nil waitUntilDone:NO];
}

// 子线程需要执行的任务
- (void)testAlive {
    NSLog(@"touchesBegan-test-%s-----%@", __func__, [NSThread currentThread]);
}

// 停止子线程的 RunLoop
- (void)stopThread
{
    // 设置标记为 YES
    self.stopped = YES;
    // 停止 RunLoop
    CFRunLoopStop(CFRunLoopGetCurrent());
    NSLog(@"%s-----%@", __func__, [NSThread currentThread]);
    // 清空线程
    self.thread = nil;
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
    
    if (!self.thread) return;
    // 在子线程调用（waitUntilDone设置为YES，代表子线程的代码执行完毕后，当前方法才会继续往下执行）
    [self performSelector:@selector(stopThread) onThread:self.thread withObject:nil waitUntilDone:YES];
}



@end
