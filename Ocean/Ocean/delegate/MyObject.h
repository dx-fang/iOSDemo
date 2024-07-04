//
//  MyObject.h
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/18.
//

#import <Foundation/Foundation.h>
#import "MyDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyObject : NSObject
@property (weak, nonatomic) id<MyDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
