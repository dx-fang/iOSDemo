//
//  ForwardingTarget.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/9.
//

#import "ForwardingTarget.h"
#import <objc/runtime.h>

@implementation ForwardingTarget

// LGUncaughttExceptionHandler
id newDynmicMethod(id self, SEL _cmd) {
    // 直接定位到哪里有问题，可以做crash的收集
    NSLog(@"%@", NSStringFromSelector(_cmd));
    // NSSetUncaughtExceptionHandler(<#NSUncaughtExceptionHandler * _Nullable#>) 保存到本地，下次进行上传
    return [NSNull null];
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    class_addMethod(self.class, sel, (IMP)newDynmicMethod, "@@:");
    [super resolveClassMethod: sel];
    return YES;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    id res = [super forwardingTargetForSelector:aSelector];
    return res;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    id res = [super methodSignatureForSelector:aSelector];
    return res;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [super forwardInvocation:anInvocation];
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    [super doesNotRecognizeSelector:aSelector];
}

@end
