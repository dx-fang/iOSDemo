//
//  DaysViewController.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/9.
//

#import "DaysViewController.h"

@interface DaysViewController ()
@property(strong, nonatomic) UITabBarController *tabVC;
@end

// SD应该也有降采样的API 可以根据实际展示大小去调用对应的API做压缩处理 也可以避免这个问题
@implementation DaysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self eat];
    [self sleep];
    [self play];
    
    // 链式写法  masonry
    self.eat.sleep.play(@"fxxx"); // 都会走get方法，不能加入参，需要通过block处理
}

- (DaysViewController *)eat {
    NSLog(@"eat");
    return self;
}

- (DaysViewController *)sleep {
    NSLog(@"sleep");
    return self;
}

- (void(^)(NSString *))play {
    NSLog(@"play");
    void (^block)(NSString *) = ^(NSString *str) {
        NSLog(@"block=%@", str);
    };
    return block;
}

@end
