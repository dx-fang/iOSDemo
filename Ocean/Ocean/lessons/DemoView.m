//
//  DemoView.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/22.
//

//typedef void (^NestedContainerViewScrollCallBack)(NestedContainerViewStatus status, CGFloat height);
//// 浮层滑动
//@property (nonatomic, copy) NestedContainerViewScrollCallBack scrollCallBack;

#import "DemoView.h"
@interface DemoView()
@property(copy, nonatomic) void (^paramblock)(NSString *name);
@property(copy, nonatomic) void (^block)(void);
//@property (weak, nonatomic) id<MyDelegate> delegate;
@end
@implementation DemoView

-(instancetype)initWithTitleStr:(NSString *)titleStr{
    if (self = [super init]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoDark];
        btn.frame = CGRectMake(0, 0, 300, 40);
//        btn.titleLabel.text = titleStr;
        [btn setTitle:titleStr forState:UIControlStateNormal];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(p_clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.frame = btn.frame;
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

-(instancetype)initWithTitleStr:(NSString *)titleStr withBlock: (void (^)(void))block {
    if (self = [super init]) {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoDark];
//        btn.frame = CGRectMake(100, 100, 300, 40);
////        btn.titleLabel.text = titleStr;
//        [btn setTitle:titleStr forState:UIControlStateNormal];
//        [self addSubview:btn];
//        [btn addTarget:self action:@selector(p_clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeInfoDark];
        btn2.frame = CGRectMake(0, 0, 300, 40);
        [btn2 setTitle:[titleStr stringByAppendingString:@"111"] forState:UIControlStateNormal];
//        btn2.titleLabel.text = [titleStr stringByAppendingString:@"111"];
//        [btn setTitle:titleStr forState:UIControlStateNormal];
        [self addSubview:btn2];
        self.frame = btn2.frame;
        [btn2 addTarget:self action:@selector(p_clickBtn2:) forControlEvents:UIControlEventTouchUpInside];
        self.block = block;
//        btn2.userInteractionEnabled = YES; // 确保按钮可以交互
//        self.userInteractionEnabled = YES; // 确保当前视图可以交云
    }
    return self;
}

-(instancetype)initWithTitleStr:(NSString *)titleStr withParmaBlock:(void (^)(NSString *name))block {
    if (self = [super init]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoDark];
        btn.frame = CGRectMake(0, 0, 300, 40);
        [btn setTitle:[titleStr stringByAppendingString:@"parma"] forState:UIControlStateNormal];
        [self addSubview:btn];
        self.frame = btn.frame;
        [btn addTarget:self action:@selector(p_clickBtn3:) forControlEvents:UIControlEventTouchUpInside];
        self.paramblock = block;
    }
    return self;
}


- (void)p_clickBtn:(UIButton *)sender{
    if(sender == nil) return;
    //通过代理回调
    [_delegate respondsToSelector:@selector(clickBtn:)] ?
    [_delegate clickBtn:sender] : nil;
}

- (void)p_clickBtn2:(UIButton *)sender{
    if(sender == nil) return;
    self.block();
}

- (void)p_clickBtn3:(UIButton *)sender{
    if(sender == nil) return;
    self.paramblock(@"带参数");
}
@end
