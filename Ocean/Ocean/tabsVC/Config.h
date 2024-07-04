//
//  Config.h
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/16.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSArray* vcClassNames = @[
    @"BaseKnowledgeVC", // 1
    @"NSThreadVC", // 2
    @"GCDViewController",
    @"OperationViewController",
    @"RACViewController",
    @"MVC",
    @"CyclicCollectionVC",
    @"InnerCyclicCollectionVC",
    @"RunLoopViewController",
    @"AutoLayoutVC",
    @"TransformVC",
    @"GestureVC",
    @"GCDViewController",
    @"OperationViewController",
    @"blockVC",
    @"ContentViewController",
    @"PerformVC",
    @"ShareActivityVC",
    @"OpenAPPVC",
    @"LivePhotoVC",
    @"JSVC",
];

@interface Config : NSObject
+ (UIViewController *)buildVCWithIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
