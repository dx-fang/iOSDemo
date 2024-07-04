//
//  GestureVC.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/25.
//

#import "GestureVC.h"

@interface GestureVC ()
@property (nonatomic, strong) UIView *zoomableView;
@end

@implementation GestureVC

// A 上加小B，A设置手势，B的点击事件能响应到么--能（在A没有处理事件时）
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建一个视图
    self.zoomableView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    self.zoomableView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.zoomableView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 20, 100, 100);
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"按钮" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.zoomableView addSubview:button];
    // 创建并添加双指缩放手势
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.zoomableView addGestureRecognizer:pinchGesture];
    
    UIView *view = [[UIView alloc]initWithFrame: CGRectMake(60, 60, 100, 100)];
    view.backgroundColor = [UIColor yellowColor];
    [self.zoomableView addSubview:view];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.zoomableView addGestureRecognizer:tapGesture];
}

- (void)handlePinch:(UIPinchGestureRecognizer *)pinchGestureRecognizer {
    // 获取缩放比例
    CGFloat scale = pinchGestureRecognizer.scale;
    
    // 根据缩放比例调整视图的transform
    pinchGestureRecognizer.view.transform = CGAffineTransformScale(pinchGestureRecognizer.view.transform, scale, scale);
    
    // 重置缩放比例
    pinchGestureRecognizer.scale = 1.0;
}

- (void)handleTap:(UITapGestureRecognizer *)tapGest {
    NSLog(@"tap");
}

- (void)click:(UIButton*)sender {
    NSLog(@"button");
}
@end
