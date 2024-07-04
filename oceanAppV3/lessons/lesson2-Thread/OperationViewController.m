//
//  SecondViewController.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/7.
//

#import "OperationViewController.h"
#import "DXThread.h"

@interface OperationViewController ()

@property(strong,nonatomic) UILabel *creatlabel;
@property(strong,nonatomic) UILabel *runlabel;
@property (nonatomic, strong) DXThread *thread;
@property (nonatomic, assign, getter=isStoped) BOOL stopped;
@end

@implementation OperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"开启线程单任务" forState:UIControlEventTouchUpInside];
    button.frame = CGRectMake(60, 60, 40, 40);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(startThread:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:@"开启线程单多任务" forState:UIControlEventTouchUpInside];
    button2.frame = CGRectMake(200, 60, 40, 40);
    button2.backgroundColor = [UIColor redColor];
    [button2 addTarget:self action:@selector(startThreadWithTwo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button3 setTitle:@"添加依赖" forState:UIControlEventTouchUpInside];
    button3.frame = CGRectMake(60, 200, 100, 40);
    button3.backgroundColor = [UIColor redColor];
    [button3 addTarget:self action:@selector(addDependencyOperation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button4 setTitle:@"测试子线程是否会testthread开启RunLoop" forState:UIControlEventTouchUpInside];
    button4.frame = CGRectMake(60, 300, 100, 40);
    button4.backgroundColor = [UIColor redColor];
    [button4 addTarget:self action:@selector(serialwithconcurrentOperation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];
    
    UIButton *button5 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button5 setTitle:@"InvocationOperat" forState:UIControlEventTouchUpInside];
    button5.frame = CGRectMake(60, 400, 100, 40);
    button5.backgroundColor = [UIColor redColor];
    [button5 addTarget:self action:@selector(useInvocationOperation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button5];
    
}

- (void)startThread:(UIButton*)sender {
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
    [backgroundQueue addOperationWithBlock:^{
        // 模拟耗时操作
        [NSThread sleepForTimeInterval:2.0];
        NSString *result = @"任务完成";
        
        // 切换回主队列更新UI
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"更新UI: %@", result);
        }];
    }];
}
// 多任务块
- (void)startThreadWithTwo:(UIButton *)sender {
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        // 在这里执行任务
        NSLog(@"执行第一个块的任务");
    }];
    [blockOperation addExecutionBlock:^{
        NSLog(@"执行第二个块的任务");
    }];
    [blockOperation addExecutionBlock:^{
        NSLog(@"执行第3个块的任务");
    }];
    [blockOperation addExecutionBlock:^{
        NSLog(@"执行第4个块的任务");
    }];
    [blockOperation addExecutionBlock:^{
        NSLog(@"执行第5个块的任务");
    }];

    // 创建操作队列并将操作添加到队列中
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 2;
    [queue addOperation:blockOperation];
}

// 3142与1324都有可能，说明[operation1 setQueuePriority:NSOperationQueuePriorityNormal]并没什么作用
- (void)addDependencyOperation:(UIButton*) sender
{
    // 创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 2;

    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"operation%d: %@",1,[NSThread currentThread]);
    }];
    //设置普通优先级
    [operation1 setQueuePriority:NSOperationQueuePriorityNormal];
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"operation%d: %@",2,[NSThread currentThread]);
    }];

    //2依赖1
    [operation2 addDependency:operation1];

    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"operation%d: %@",3,[NSThread currentThread]);
    }];

    //设置高的优先级
    [operation3 setQueuePriority:NSOperationQueuePriorityHigh];

    NSBlockOperation *operation4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"operation%d: %@",4,[NSThread currentThread]);
    }];
    //4依赖3
    [operation4 addDependency:operation3];
    
    // 队列添加操作
    [queue addOperation:operation1];
    [queue addOperation:operation2];
    [queue addOperation:operation3];
    [queue addOperation:operation4];
}

- (void)serialwithconcurrentOperation:(UIButton*) sender {
    NSOperationQueue *serialQueue = [[NSOperationQueue alloc] init];
    serialQueue.maxConcurrentOperationCount = 1;

    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"operation1---%d: %@",4,[NSThread currentThread]);
    }];
    [serialQueue addOperation:op1];

    [serialQueue addOperationWithBlock:^{
        NSOperationQueue *concurrentQueue = [[NSOperationQueue alloc] init];
        concurrentQueue.maxConcurrentOperationCount = 2;

        NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"operation2---%d: %@",4,[NSThread currentThread]);
        }];
        NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"operation3---%d: %@",4,[NSThread currentThread]);
        }];
        [concurrentQueue addOperation:op2];
        [concurrentQueue addOperation:op3];
        [concurrentQueue waitUntilAllOperationsAreFinished];
    }];

    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"operation4---%d: %@",4,[NSThread currentThread]);
    }];
    [serialQueue addOperation:op4];
}

/**
 * 使用子类 NSInvocationOperation
 */
- (void)useInvocationOperation:(UIButton*) sender {
    // 1.创建 NSInvocationOperation 对象
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
     // self为想要观察的NSOperation对象的状态属性注册观察者。这通常在将操作添加到操作队列之前完成。
    [operation addObserver:self forKeyPath:@"isExecuting" options:NSKeyValueObservingOptionNew context:nil];
    [operation addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:nil];
    [operation addObserver:self forKeyPath:@"isCancelled" options:NSKeyValueObservingOptionNew context:nil];
    // 2.调用 start 方法开始执行操作
    [operation start];
}

/**
 * 任务1
 */
- (void)task1 {
    for (int i = 0; i < 10; i++) {
        [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
        NSLog(@"%d---%@", i, [NSThread currentThread]); // 打印当前线程
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isExecuting"]) {
        if ([change[NSKeyValueChangeNewKey] boolValue] == YES) {
            NSLog(@"操作正在执行");
        }
    } else if ([keyPath isEqualToString:@"isFinished"]) {
        if ([change[NSKeyValueChangeNewKey] boolValue] == YES) {
            NSLog(@"操作已完成");
        }
    } else if ([keyPath isEqualToString:@"isCancelled"]) {
        if ([change[NSKeyValueChangeNewKey] boolValue] == YES) {
            NSLog(@"操作已取消");
        }
    }
}

/*
 当点击开始按钮时，使用`dispatch_once`确保代码块只执行一次。
 在这个代码块中，创建了一个新的线程`testThread`，并在这个线程中启动一个RunLoop，该RunLoop会持续运行直到`self.isFault`变为`true`。
 同时，在线程开始运行前后分别打印了"startRun"和"stopRun"日志。
 */
- (void)beginAction:(UIButton *)sender {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.thread = [[NSThread alloc] initWithBlock:^{
            while (!self.stopped) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            NSLog(@"stopRun");
        }];
        NSLog(@"startRun");
        [self.thread start];
    });
}

/*
 当点击结束按钮时，通过`performSelector:onThread:withObject:waitUntilDone:`方法在`testThread`线程上调用`doSomething`方法。这里的`waitUntilDone:NO`参数表示调用是异步的，即方法调用请求被发送后，`endAction:`方法会立即返回，不会等待`doSomething`方法执行完成。
 */
- (void)endAction:(UIButton *)sender {
    [self performSelector:@selector(doSomething) onThread:self.thread withObject:nil waitUntilDone:NO];
}

// 打印当前方法名和正在执行该方法的线程。
- (void)doSomething {
    NSLog(@"%@ %@", __func__, [NSThread currentThread]);
}

/*
 这是一个按钮的动作处理方法。当按钮被点击时，它会在`self.testThread`线程上同步执行`doSomething`方法
 （由于`waitUntilDone:YES`，调用者会等待`doSomething`方法执行完成）。
 注释中提到了停止线程的RunLoop的代码，但实际的停止代码（`stopThread`方法调用）被注释掉了。
 */
- (IBAction)stopAction:(UIButton *)sender {
    [self performSelector:@selector(stopThread) onThread:self.thread withObject:nil waitUntilDone:YES];
    // 停止线程的RunLoop
    // [self stopThread];
}

/*
 此方法用于停止当前线程的RunLoop，并打印当前方法名和线程。这个方法在`stopAction`中被提到，但在实际调用中被注释掉了，所以如果需要停止RunLoop，需要取消对`stopThread`方法调用的注释。
 */
- (void)stopThread {
    self.stopped = YES;
//    CFRunLoopStop(CFRunLoopGetCurrent()); //直接设置nil，不去停止也可以正常销毁，stop相当于休眠，没有任务唤醒的话就直接销毁了。
    self.thread = nil; // 停止强引用
    // 如何监控生命周期 observer
    NSLog(@"%@ %@", __func__, [NSThread currentThread]);
}

- (void)GCFKeepActive {
//    dispatch_get_main_queue()
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSRunLoop * runloop = [NSRunLoop currentRunLoop];
        [runloop addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        [runloop run];
    });
}

- (void)operationQueueForSerialWithCur {
    NSOperationQueue *serialQueue = [[NSOperationQueue alloc] init];
    serialQueue.maxConcurrentOperationCount = 1;
    
    NSOperationQueue *concurrentQueue = [[NSOperationQueue alloc] init];
    concurrentQueue.maxConcurrentOperationCount = 2;
    
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"operation1---%d: %@",4,[NSThread currentThread]);
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"operation2---%d: %@",4,[NSThread currentThread]);
    }];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"operation3---%d: %@",4,[NSThread currentThread]);
    }];
    
    
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"operation4---%d: %@",4,[NSThread currentThread]);
    }];
    [serialQueue addOperation:op1];
    [concurrentQueue addOperation:op2];
    [concurrentQueue addOperation:op3];
    [serialQueue addOperation:op4];
}

- (void)operationdemo2
{

    // 创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    // 队列添加任务
    [queue addOperationWithBlock:^{

        NSLog(@"%@",[NSThread currentThread]);
        sleep(2);

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"%@",[NSThread currentThread]);
        }];
    }];
}

- (void)operationdemoForNSOpeartion
{
    NSLog(@"operationdemoForNSOpeartion");
    // 创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //创建串行队列:1 并行队列>1
    //并行队列可以看到是执行顺序是无序。最大并发数不是开启了多少条线程，开启线程数量是由系统决定的，不需要我们来管理。
    queue.maxConcurrentOperationCount = 2;
    //创建操作任务
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"operation11---%@",[NSThread currentThread]);
    }];
    //设置普通优先级
    [operation1 setQueuePriority:NSOperationQueuePriorityNormal];
    //队列添加操作任务
    [queue addOperation:operation1];
    
//    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
//        NSLog(@"operation222---%@",[NSThread currentThread]);
//    }];
//    // 2依赖1
//    [operation2 addDependency:operation1];
//    // 队列添加操作任务
//    [queue addOperation:operation2];
//    [queue waitUntilAllOperationsAreFinished];
//    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
//        for (int i = 0; i < 5; i++) {
//            NSLog(@"for循环-%d: %@",i,[NSThread currentThread]);
//        }
//    }];
//    //队列添加操作任务
//    [queue addOperation:operation];
//    [queue waitUntilAllOperationsAreFinished];
    for (int i = 0; i < 5; i++) {
        //队列添加操作任务
        [queue addOperationWithBlock:^{
            NSLog(@"for循环-%d: %@",i,[NSThread currentThread]);
        }];
    }
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"operation333--%@",[NSThread currentThread]);
    }];
    //设置高的优先级
    [operation3 setQueuePriority:NSOperationQueuePriorityHigh];
    //队列添加操作任务
    [queue addOperation:operation3];

    NSBlockOperation *operation4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"operation44---%d: %@",4,[NSThread currentThread]);
    }];
    //4依赖3
    [operation4 addDependency:operation3];
    [queue addOperation:operation4];
}

- (void)operationQueueForSerialWithCur11 {
    NSOperationQueue *serialQueue = [[NSOperationQueue alloc] init];
    serialQueue.maxConcurrentOperationCount = 1;
    
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"operation1---%d: %@",4,[NSThread currentThread]);
    }];
    [serialQueue addOperation:op1];
    
    [serialQueue addOperationWithBlock:^{
        NSOperationQueue *concurrentQueue = [[NSOperationQueue alloc] init];
        concurrentQueue.maxConcurrentOperationCount = 2;
        
        NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"operation2---%d: %@",4,[NSThread currentThread]);
        }];
        NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"operation3---%d: %@",4,[NSThread currentThread]);
        }];
        [concurrentQueue addOperation:op2];
        [concurrentQueue addOperation:op3];
        [concurrentQueue waitUntilAllOperationsAreFinished];
    }];
    
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"operation4---%d: %@",4,[NSThread currentThread]);
    }];
    [serialQueue addOperation:op4];
}

@end

// NSInvocationOperation是NSOperation的一个子类，它允许你创建一个操作，对某个对象的某个方法的调用。
// 创建目标对象和要执行的方法
//    MyObject *myObject = [[MyObject alloc] init];
//    // 创建NSInvocationOperation对象
//    NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc] initWithTarget:myObject selector:@selector(myTaskMethod) object:nil];
//    // 创建操作队列并将操作添加到队列中
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [queue addOperation:invocationOperation];

//  NSBlockOperation也是NSOperation的子类，允许你使用一个或多个块来定义操作。
// 如果NSBlockOperation对象包含多个块，那么这些块可以并发执行。
// 创建NSBlockOperation对象
//    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
//        // 在这里执行任务
//        NSLog(@"执行第一个块的任务");
//    }];
//    // 添加更多的块
//    [blockOperation addExecutionBlock:^{
//        NSLog(@"执行第二个块的任务");
//    }];
//
//    // 创建操作队列并将操作添加到队列中
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [queue addOperation:blockOperation];
//    NSBlockOperation可以包含多个执行块，如果添加的执行块数量超过1，那么这些块将并发执行，前提是NSOperationQueue的maxConcurrentOperationCount属性允许并发执行。

// NSOperation *operation = [[NSOperation alloc] init];
// 注册观察者 TODO:self为想要观察的NSOperation对象的状态属性注册观察者。这通常在将操作添加到操作队列之前完成。
//    [operation addObserver:self forKeyPath:@"isExecuting" options:NSKeyValueObservingOptionNew context:nil];
//    [operation addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:nil];
//    [operation addObserver:self forKeyPath:@"isCancelled" options:NSKeyValueObservingOptionNew context:nil];

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    if ([keyPath isEqualToString:@"isExecuting"]) {
//        if ([change[NSKeyValueChangeNewKey] boolValue] == YES) {
//            NSLog(@"操作正在执行");
//        }
//    } else if ([keyPath isEqualToString:@"isFinished"]) {
//        if ([change[NSKeyValueChangeNewKey] boolValue] == YES) {
//            NSLog(@"操作已完成");
//        }
//    } else if ([keyPath isEqualToString:@"isCancelled"]) {
//        if ([change[NSKeyValueChangeNewKey] boolValue] == YES) {
//            NSLog(@"操作已取消");
//        }
//    }
//}
