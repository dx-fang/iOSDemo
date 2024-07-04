//
//  BaseObject+Methods.h
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/23.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseObject (Methods)
@property(nonatomic, assign)NSInteger categoryAge;
-(void)delete;
-(void)all;
-(void)add;
@end

NS_ASSUME_NONNULL_END
