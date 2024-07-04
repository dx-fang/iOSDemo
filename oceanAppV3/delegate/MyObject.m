//
//  MyObject.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/18.
//

#import "MyObject.h"

@implementation MyObject

- (void)completeTask {
    // 任务完成后，通知代理
    [self.delegate taskDidFinishWithResult:@"Success"];
}

@end
