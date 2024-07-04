//
//  FirstViewController.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/7.
//

#import "GCDViewController.h"

@interface GCDViewController ()
@property(strong,nonatomic) UILabel *creatlabel;
@property(strong,nonatomic) UILabel *runlabel;

// 定义一个并发队列
@property (nonatomic, strong) dispatch_queue_t concurrent_queue;
// 多个线程需要数据访问
@property (nonatomic, strong) NSMutableDictionary *dataCenterDic;

@end

@implementation GCDViewController

- (instancetype)init{
    NSLog(@"init");
    self = [super init];
    if (self){
        // 创建一个并发队列:
        self.concurrent_queue = dispatch_queue_create("read_write_queue", DISPATCH_QUEUE_CONCURRENT);
        // 创建数据字典:
        self.dataCenterDic = [NSMutableDictionary dictionary];

    }
    return self;
}
#pragma mark - 读数据
- (id)jj_objectForKey:(NSString *)key{
    __block id obj;
    // 同步读取指定数据:
    dispatch_sync(self.concurrent_queue, ^{
        obj = [self.dataCenterDic objectForKey:key];
    });
    return obj;
}

#pragma mark - 写数据
- (void)jj_setObject:(id)obj forKey:(NSString *)key{
    // 异步栅栏调用设置数据
    dispatch_barrier_async(self.concurrent_queue, ^{
        NSLog(@"写--%@",obj);
        [self.dataCenterDic setObject:obj forKey:key];
    });
}

// 多读单写
- (void)readWriteLock:(UIButton *)sender {
    dispatch_queue_t queue = dispatch_queue_create("dx.com", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i < 5; i++) {
        dispatch_async(queue, ^{
            [self jj_setObject:[NSString stringWithFormat:@"dx---%d",i] forKey:@"key"];
        });
    }
    for (int i = 0; i < 5; i++) {
        dispatch_async(queue, ^{
            NSLog(@"读1--%@",[self jj_objectForKey:@"key"]);
        });
    }
 }

- (void)viewDidLoad {
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"多读单写" forState:UIControlEventTouchUpInside];
    button.frame = CGRectMake(60, 60, 40, 40);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(readWriteLock:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:@"dispatch_group_request" forState:UIControlEventTouchUpInside];
    button2.frame = CGRectMake(200, 60, 40, 40);
    button2.backgroundColor = [UIColor redColor];
    [button2 addTarget:self action:@selector(dispatch_group_request:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button3 setTitle:@"dispatch_barrier_async_request" forState:UIControlEventTouchUpInside];
    button3.frame = CGRectMake(60, 200, 100, 40);
    button3.backgroundColor = [UIColor redColor];
    [button3 addTarget:self action:@selector(dispatch_barrier_async_request:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button4 setTitle:@"operationdemoForGCD" forState:UIControlEventTouchUpInside];
    button4.frame = CGRectMake(60, 300, 100, 40);
    button4.backgroundColor = [UIColor redColor];
    [button4 addTarget:self action:@selector(operationdemoForGCD:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];
    
    UIButton *button5 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button5 setTitle:@"InvocationOperat" forState:UIControlEventTouchUpInside];
    button5.frame = CGRectMake(60, 400, 100, 40);
    button5.backgroundColor = [UIColor redColor];
    [button5 addTarget:self action:@selector(dispatch_semaphore_t_request:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button5];
    
}


- (void)dispatch_group_request:(UIButton *)sender
{
    // 创建1个队列组
    dispatch_group_t group = dispatch_group_create();
    // 创建1个并发队列
    dispatch_queue_t queue = dispatch_queue_create("jj.com", DISPATCH_QUEUE_CONCURRENT);
    // 异步添加1个并发队列
    dispatch_group_async(group, queue, ^{
        // 延迟模拟
        sleep(1);
        NSLog(@"1--%@",[NSThread currentThread]);
    });

    dispatch_group_async(group, queue, ^{
        // 延迟模拟
        sleep(1);
        NSLog(@"2--%@",[NSThread currentThread]);
    });

    // 上面的任务执行完后会来到这里
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"3--%@",[NSThread currentThread]);
    });
    NSLog(@"0--%@",[NSThread currentThread]);
}

- (void)dispatch_barrier_async_request:(UIButton *)sender
{

    dispatch_queue_t queue = dispatch_queue_create("jj.com", DISPATCH_QUEUE_CONCURRENT);

    dispatch_async(queue, ^{
        NSLog(@"2:%@", [NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"3:%@", [NSThread currentThread]);
    });

    dispatch_barrier_async(queue, ^{
        NSLog(@"4:%@", [NSThread currentThread]);
    });

    dispatch_async(queue, ^{
        NSLog(@"5:%@", [NSThread currentThread]);
    });

    NSLog(@"1:%@", [NSThread currentThread]);
    // 1 2 3 4 5
}

// 异步并发-dispatch_queue_create("jj.com", DISPATCH_QUEUE_CONCURRENT);
- (void)operationdemoForGCD:(UIButton *)sender {
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"operationdemoForGCD111---%@",[NSThread currentThread]);
        sleep(2);
        NSLog(@"operationdemoForGCD222---sleep%@",[NSThread currentThread]);

        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"operationdemoForGCD222--%@",[NSThread currentThread]);
        });
    });
    // dispatch_after是不会阻塞线程的，并且延时后，会回到主线程执行任务。
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"dispatch_after222:%@",[NSThread currentThread]);
    });
    NSLog(@"dispatch_after111:%@",[NSThread currentThread]);
    
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"2222---%@",[NSThread currentThread]);
     });

    // 创建一个串行队列
    dispatch_queue_t serialQueue = dispatch_queue_create("com.example.serialQueue", DISPATCH_QUEUE_SERIAL);
    // 创建一个并发队列
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.example.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(serialQueue, ^{
         NSLog(@"执行第1个并行任务");
    });
    // 在串行队列中添加任务
    dispatch_async(serialQueue, ^{
       // 在并发队列中并行执行两个任务
       dispatch_async(concurrentQueue, ^{
           NSLog(@"执行第2个并行任务");
       });
       dispatch_async(concurrentQueue, ^{
           NSLog(@"执行第3个并行任务");
       });
        
    });
    dispatch_async(serialQueue, ^{
         NSLog(@"执行第4个并行任务");
    });
    
    // 创建单列 dispatch_once
//    static GCDDemo *demo;
//    static dispatch_once_t onceToken;
//
//    dispatch_once(&onceToken, ^{
//        demo = [GCDDemo new];
//    });
//
//    return demo;
}


- (void)addSubThreadAction {
    NSLog(@"启动RunLoop=%@",[NSRunLoop currentRunLoop].currentMode);
    NSLog(@"子线程任务开始=%@， %@",[NSRunLoop currentRunLoop], [NSThread currentThread]);
    for(int i = 0; i < 3; i++) {
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"子线程任务=%d", i);
    }
    NSLog(@"子线程任务结束=%@",[NSRunLoop currentRunLoop].currentMode);
    CFRunLoopStop(CFRunLoopGetCurrent()); // runloop并没有结束，启动方式问题--[runLoop run];
//    CFRunLoopStop([NSRunLoop currentRunLoop].getCFRunLoop);
}

- (void)keepAliveAction {
    
}

- (void)dispatch_semaphore_t_request:(UIButton *)sender
{
    //创建1个信号量，且信号量的值为0
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    // 并发队列
    dispatch_queue_t queue = dispatch_queue_create("jj.com", DISPATCH_QUEUE_CONCURRENT);

    dispatch_async(queue, ^{
        sleep(1);
        NSLog(@"1--%@",[NSThread currentThread]);
        //信号值+1
        dispatch_semaphore_signal(sema);

    });

    dispatch_async(queue, ^{
        sleep(1);
        NSLog(@"2--%@",[NSThread currentThread]);

        //信号值+1
        dispatch_semaphore_signal(sema);

    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 等待2个
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        NSLog(@"0--%@",[NSThread currentThread]);

    });

}

/*
注意事项 TODO:在非主线程被调用会怎么样
确保在观察者对象被销毁之前移除观察者，例如在dealloc方法中。
使用KVO时要注意线程安全问题，因为observeValueForKeyPath:ofObject:change:context:方法可能会在非主线程被调用。
NSOperation的这些状态属性是线程安全的，你可以安全地在多线程环境下观察它们。
通过上述步骤，你可以使用KVO来观察NSOperation的执行状态变化，从而根据操作的状态执行相应的逻辑。
 */
@end
