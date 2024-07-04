//
//  DXThread.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/9.
//

#import "DXThread.h"

@implementation DXThread

- (void)dealloc
{
    NSLog(@"dx-DXThread=%s", __func__);
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        // 死锁,主线程里的同步会死锁
//    });
}

@end
