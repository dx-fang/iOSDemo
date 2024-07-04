//
//  NSObject+Logic.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/9.
//

#import "NSObject+Logic.h"
#import "objc/runtime.h"
#import "ForwardingTarget.h"
#import "UIKit/UIKit.h"
static ForwardingTarget *target = nil;
@implementation NSObject (Logic)

+ (void)load { // 只会执行一次，但是子类会可以调用
    // 要用单例包裹，防止调用多次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        target = [ForwardingTarget new];
        Method _Nullable *originalMethod = class_getInstanceMethod(objc_getClass(@"NSConstantArray"), @selector(forwardingTargetForSelector));
        Method _Nullable *swizzleMethod = class_getInstanceMethod(self, @selector(logic_forwardingTargetForSelector));
        method_exchangeImplementations(originalMethod, swizzleMethod);
        
        // 做一个保护
        BOOL didAddMethod = class_addMethod(self, @selector(objectAtIndexedSubscript), method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
        if (didAddMethod) { // 替换
            class_replaceMethod(self, @selector(logic_objectAtIndexedSubscript), method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else { // 交换
            method_exchangeImplementations(originalMethod, swizzleMethod);
        }
    });
    
//    Method *originalMethod = class_getInstanceMethod(objc_getClass(@"NSConstantArray"), @selector(objectAtIndexedSubscript));
//    Method *swizzleMethod = class_getInstanceMethod(self, @selector(logic_objectAtIndexedSubscript));
//    method_exchangeImplementations(originalMethod, swizzleMethod);
}

// 因此，为了全局实现，还是放在load里交换方法
- (id)logic_forwardingTargetForSelector:(SEL)aSelector {
    id result = [self logic_forwardingTargetForSelector:aSelector];
    if (result) return result;
    // 只有UIbutton有问题才会进入
    if (![self isKindOfClass:[UIButton class]]) {
        return result;
    }
    NSLog(@"%@", result);
    return target;
}

@end
