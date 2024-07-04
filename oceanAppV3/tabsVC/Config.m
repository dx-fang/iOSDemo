//
//  Config.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/16.
//
#import "Config.h"
@implementation Config

/*
这段代码首先定义了一个包含多个自定义视图控制器类名的数组`vcClassNames`。然后，通过遍历这个数组，使用`NSClassFromString`函数根据类名字符串动态获取到类的`Class`对象。如果成功获取到`Class`对象，就使用`alloc`和`init`方法创建该类的实例，并将创建好的视图控制器实例添加到`viewControllers`数组中。这样，`viewControllers`数组就存储了所有动态创建的视图控制器实例。
 */
+ (UIViewController *)buildVCWithIndex:(NSInteger)index {
//    NSArray *vcClassNames = @[@"ViewControllerA", @"ViewControllerB", @"ViewControllerC"];
//    NSMutableArray *viewControllers = [NSMutableArray array];
//
//    for (NSString *className in vcClassNames) {
//        Class class = NSClassFromString(className);
//        if (class) {
//            UIViewController *vc = [[class alloc] init];
//            if (vc) {
//                [viewControllers addObject:vc];
//            }
//        }
//    }
    NSString *className = vcClassNames[index];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *vc = [[class alloc]init];
        return vc;
    }
    return [[UIViewController alloc]init];
}
@end

