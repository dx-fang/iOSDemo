//
//  BaseObject+Methods.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/23.
//

#import "BaseObject+Methods.h"
#import <objc/runtime.h>

@implementation BaseObject (Methods)
@dynamic categoryAge;
-(void)delete {
    NSLog(@"BaseObject扩展1-delete");
}
-(void)all {
    NSLog(@"BaseObject扩展1-all");
}
-(void)add {
    NSLog(@"BaseObject扩展1-add");
}

- (NSInteger)categoryAge {
    // 获取关联对象
    return objc_getAssociatedObject(self, @selector(categoryAge));
}

//- (void)setPseudoProperty:(NSInteger *)categoryAge {
//    // 设置关联对象
//    objc_setAssociatedObject(self, @selector(categoryAge), categoryAge, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

@end
