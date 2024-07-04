//
//  main.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/7.
//

#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import "objc/runtime.h"
#import <malloc/malloc.h>

@interface TestObject: NSObject
@property (nonatomic,assign) int age;
@property (nonatomic,assign) double height;
@property (nonatomic,assign) int row;
@end

@implementation TestObject

@end

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        TestObject *objc = [[TestObject alloc] init];
        // Setup code that might create autoreleased objects goes here.
        objc.age = 4;
        objc.height = 5;
        objc.row = 6;
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
        NSLog(@"lbobjc对象实际需要的内存大小: %zd",class_getInstanceSize([objc class])); // 8
        NSLog(@"lbobjc对象实际分配的内存大小: %zd",malloc_size((__bridge const void *)(objc))); // 16
        // 加上属性后变为24/32
        // https://juejin.cn/post/6844903939985391629?searchId=20240607171638B32A3D47F8F510ABC32C
        /*
         OC对象 最少占用 16 个字节内存 .
         当对象中包含属性, 会按属性占用内存开辟空间. 在结构体内存分配原则下自动偏移和补齐 .
         对象最终满足 16 字节对齐标准 .
         属性最终满足 8 字节对齐标准 .
         可以通过 #pragma pack() 自定义对齐方式 .
         */
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}


//-(void)testTag {
//    NSNumber *num1 = @3;
//    NSNumber *num2 = @4;
//    NSNumber *num3 = @5;
//    // 数值太大，64位不够放，得alloc生成个对象来保存
//    NSNumber *num4 = @(0xFFFFFFFFFFFFFFFF);
//    // 小数值的NSNumber对象，并不是alloc出来放在堆中的对象，只是一个单纯的指针，目标值是存放在指针的地址值中
//    NSLog(@"%p %p %p %p", num1, num2, num3, num4);
//}
