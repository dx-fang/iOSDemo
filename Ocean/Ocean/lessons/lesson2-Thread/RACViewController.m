//
//  RACViewController.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/23.
//

#import "RACViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface RACViewController ()
@end

@implementation RACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"ra信号" forState:UIControlEventTouchUpInside];
    button.frame = CGRectMake(100, 100, 40, 40);
    button.backgroundColor = [UIColor redColor];
    // 监听按钮点击
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"按钮被点击了");
    }];
    [self.view addSubview:button];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 200, 400, 40)];
    textField.backgroundColor = [UIColor blueColor];
    textField.placeholder = @"请输入文案（已替代）";
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 300, 400, 40)];
    label.backgroundColor = [UIColor yellowColor];
    // 将textField的text属性绑定到label的text属性
    RAC(label, text) = textField.rac_textSignal;
    [self.view addSubview:textField];
    [self.view addSubview:label];
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 模拟异步网络请求
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 模拟请求成功
            [subscriber sendNext:@"请求的数据"];
            [subscriber sendCompleted];
        });
        return [RACDisposable disposableWithBlock:^{
            // 清理资源
        }];
    }];

    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"接收到的数据：%@", x);
    }];
    
    RACSignal *signal1 = [RACSignal return:@"第一个信号的数据"];
    RACSignal *signal2 = [RACSignal return:@"第二个信号的数据"];
    [[RACSignal combineLatest:@[signal1, signal2]] subscribeNext:^(RACTuple *x) {
        RACTupleUnpack(NSString *data1, NSString *data2) = x;
        NSLog(@"接收到的数据：%@, %@", data1, data2);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
