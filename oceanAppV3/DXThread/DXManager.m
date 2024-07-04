//
//  DXManager.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/28.
//

#import "DXManager.h"
/*
声明一个静态实例变量，确保它在应用程序的生命周期内只被初始化一次。
提供一个类方法来访问这个静态实例。
重写allocWithZone:方法，确保使用alloc或new创建对象时都返回同一个实例。
可选地，可以重写copyWithZone:和mutableCopyWithZone:方法，确保复制操作也返回同一个实例。
 */

@implementation DXManager

static DXManager *_sharedInstance = nil;

/*
 使用dispatch_once确保单例的初始化代码只执行一次。
 这是线程安全的，可以保证在多线程环境下_sharedInstance只被创建一次。
 */
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[super allocWithZone:NULL] init];
    });
    return _sharedInstance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return self;
}

@end
