//
//  DemoView.h
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MVCDelegate <NSObject>
-(void)clickBtn:(UIButton *)sender;
@end

@interface DemoView : UIView

@property(weak, nonatomic)id<MVCDelegate> delegate;

-(instancetype)initWithTitleStr:(NSString *)titleStr;
-(instancetype)initWithTitleStr:(NSString *)titleStr withBlock: (void (^)(void))block;
-(instancetype)initWithTitleStr:(NSString *)titleStr withParmaBlock:(void (^)(NSString *name))block;
@end

NS_ASSUME_NONNULL_END
