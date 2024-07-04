//
//  NSArray+Logic.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/9.
//

#import "NSArray+Logic.h"
#import "objc/runtime.h"
@implementation NSArray (Logic)


// method swizzle->hook
// 没有实现该方法，是懒加载类，用的时候才会加载。
// 一旦实现，就会提前加载时机到Main之前。在main函数之前，类装载的时候就主动调用，会影响启动速度，避免耗时操作
+ (void)load { // 只会执行一次，但是子类会可以调用
    // 要用单例包裹，防止调用多次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method _Nullable *originalMethod = class_getInstanceMethod(objc_getClass(@"NSConstantArray"), @selector(objectAtIndexedSubscript));
        Method _Nullable *swizzleMethod = class_getInstanceMethod(self, @selector(logic_objectAtIndexedSubscript));
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

// 在类方法/实例方法调用之前调用 && 主动加载，可以用但是不建议用。因为类方法/实例方法可能没有调用。需要手动调用
//+ (void)initialize {
//    
//}
// 因此，为了全局实现，还是放在load里交换方法
- (id)logic_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx < self.count) {
        return [self objectAtIndexedSubscript:idx];
    }
    NSLog(@"越界了 idx %d >= count %d", idx, self.count);
    return nil;
}

- (void)findIndex {
    NSArray *array = @[@"Apple", @"Banana", @"Cherry", @"Date"];
    NSString *elementToFind = @"Cherry";
    NSUInteger index = [array indexOfObject:elementToFind];

    if (index != NSNotFound) {
        NSLog(@"找到元素 '%@' 在索引 %lu", elementToFind, (unsigned long)index);
    } else {
        NSLog(@"数组中没有找到元素 '%@'", elementToFind);
    }
}
@end
