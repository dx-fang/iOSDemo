//
//  PerformVC.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/18.
//

#import "PerformVC.h"

@interface PerformVC ()

@end

@implementation PerformVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
        
    // 创建按钮
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeSystem];
    // 设置按钮的位置和尺寸
    myButton.frame = CGRectMake(100, 100, 200, 50); // x, y, width, height
    // 设置按钮的标题
    [myButton setTitle:@"点击我-performSelector方法" forState:UIControlStateNormal];
    // 设置按钮标题的颜色
    [myButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    // 添加点击事件
    [myButton addTarget:self action:@selector(buttonActionWithPerform:) forControlEvents:UIControlEventTouchUpInside];
    
    // 将按钮添加到视图中
    [self.view addSubview:myButton];
    
    // 创建按钮
    UIButton *invocationButton = [UIButton buttonWithType:UIButtonTypeSystem];
    // 设置按钮的位置和尺寸
    invocationButton.frame = CGRectMake(100, 300, 200, 50); // x, y, width, height
    // 设置按钮的标题
    [invocationButton setTitle:@"点击我-invocatio方法" forState:UIControlStateNormal];
    // 设置按钮标题的颜色
    [invocationButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    // 添加点击事件
    [invocationButton addTarget:self action:@selector(buttonActionWithInvocation:) forControlEvents:UIControlEventTouchUpInside];
    
    // 将按钮添加到视图中
    [self.view addSubview:invocationButton];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// 但它有一些限制，比如最多只能传递两个参数，且不能传递非对象类型的参数（比如基本数据类型）。
- (void)buttonActionWithPerform:(UIButton *)sender {
    NSLog(@"buttonActionWithPerform");
    SEL myMethod = @selector(performMethodWithArg1:arg2:);
    [self performSelector:myMethod withObject:@"dx" withObject:@"gr"];
}
- (void)performMethodWithArg1:(NSString *)arg1 arg2:(NSString *)arg2{
    NSLog(@"myMethodWithArg1=%@, Arg2=%@", arg1, arg2);
}

// NSInvocation是一个更为强大且灵活的方式，它可以用来动态地构造和调用方法调用。
// NSInvocation可以传递任意数量的参数，包括非对象类型的参数。
- (void)buttonActionWithInvocation:(UIButton *)sender {
    NSLog(@"buttonActionWithInvocation");
    SEL myMethod = @selector(invocationMethodWithArg1:arg2:);
    NSMethodSignature *signature = [self methodSignatureForSelector:myMethod];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:myMethod];
    [invocation setTarget:self];

    // 设置参数
    NSInteger arg1 = 42;
    [invocation setArgument:&arg1 atIndex:2];
    // 注意：参数索引从2开始，0和1被self和_cmd占用
    NSString *arg2 = @"Hello";
    [invocation setArgument:&arg2 atIndex:3];

    // 调用方法
    [invocation invoke];

    // 获取返回值
    NSString *result = nil;
    [invocation getReturnValue:&result];
    NSLog(@"invocationMethodWithArg1--result=%@", result);

}
- (NSString *)invocationMethodWithArg1:(NSInteger *)arg1 arg2:(NSString *)arg2{
    NSLog(@"invocationMethodWithArg1=%d, Arg2=%@", arg1, arg2);
    return @"dxxxx";
}
// NSInvocation提供了完整的动态方法调用功能，但使用起来比performSelector:系列方法更为复杂。
@end
