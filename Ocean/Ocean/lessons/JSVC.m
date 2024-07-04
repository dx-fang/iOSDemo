//
//  JSVC.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/7/1.
//

#import "JSVC.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface JSVC ()

@end

@implementation JSVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// https://juejin.cn/post/7252231214724218917?searchId=2024070111471713E2B20345BDC1A0CBE2
- (void)OC_Call_JS {
    // 创建一个JSContext对象
    JSContext *jsContext = [[JSContext alloc] init];
//    JSContext *context = [[JSContext alloc] init];
//    [context evaluateScript:@"var num = 5 + 5"];
//    JSValue *num = [context objectForKeyedSubscript:@"num"];
//    NSLog(@"num: %@", [num toNumber]);
    // 1.执行JS代码 计算js变量a和b之和
    [jsContext evaluateScript:@"var a = 1; var b = 2;"];
      // 返回值是 JSValue 类型的对象
    JSValue *result = [jsContext evaluateScript:@"a + b"];
      // 将 JSValue 类型转换成 OC 中的类型
    NSInteger sum = [result toInt32];
    NSLog(@"%ld", (long)sum);    // 3
     
//    // 2.定义方法并调用
//    [jsContext evaluateScript:@"var addFunc = function(a, b) { return a + b }"];
//    JSValue *result = [jsContext evaluateScript:@"addFunc(a, b)"];
//    NSLog(@"%@", result.toNumber);  // 3
//    
//    // 3.也可以OC传参
//    JSValue *addFunc = jsContext[@"addFunc"];
//      // 在 OC 侧可以通过 callWithArguments：方法调用 js 的方法实现
//    JSValue *addResult = [addFunc callWithArguments:@[@20, @30]];
//    NSLog(@"%d", addResult.toInt32);    // 50
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
