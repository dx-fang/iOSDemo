//
//  MyDelegateObject.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/18.
//

#import "MyDelegateObject.h"
#import "MyDelegate.h"

// 代理对象需要遵循上面定义的协议，并实现协议中的方法。
@interface MyDelegateObject ()<MyDelegate>
@end

@implementation MyDelegateObject
- (void)taskDidFinishWithResult:(NSString *)result {
    NSLog(@"Task finished with result: %@", result);
}
@end
