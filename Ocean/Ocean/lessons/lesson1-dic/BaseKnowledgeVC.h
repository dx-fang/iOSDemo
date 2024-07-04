//
//  baseknowledgeVC.h
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/20.
//

/*
 在数组或者字典初始化时插入nil会crash么？--是：NSInvalidArgumentException
 是的，在Objective-C中直接在数组（`NSArray`、`NSMutableArray`）或字典（`NSDictionary`、`NSMutableDictionary`）初始化时插入`nil`会导致崩溃。
 对于数组，如果尝试插入`nil`，会抛出`NSInvalidArgumentException`异常，因为数组不允许包含`nil`元素。
 对于字典，键（Key）和值（Value）都不能为`nil`。如果键或值为`nil`，同样会抛出`NSInvalidArgumentException`异常。如果需要表示空值，可以使用`NSNull`对象作为字典的值。
 在使用字面量语法（如`@[]`、`@{}`）初始化数组或字典时，尤其需要注意不要插入`nil`，因为这会直接导致运行时错误。如果确实需要在集合中表示空值或缺失的元素，应该使用`NSNull`单例对象。
 */
#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseKnowledgeVC : BaseViewController

@end

NS_ASSUME_NONNULL_END
