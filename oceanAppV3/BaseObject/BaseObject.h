//
//  BaseObject.h
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseObject : NSObject <NSCoding>
{
    // 私有成员变量
    NSInteger height;
}
@property(nonatomic, assign)NSInteger age;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger weight;
-(void)add;
-(void)undo;
@end


NS_ASSUME_NONNULL_END
