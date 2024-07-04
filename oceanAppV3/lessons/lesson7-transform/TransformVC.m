//
//  TransformVC.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/25.
//

#import "TransformVC.h"

@interface TransformVC ()
@property (nonatomic, strong) UIView *demoView;
@end

@implementation TransformVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建一个视图
    self.demoView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    self.demoView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.demoView];
    
    // 添加一个按钮，点击时执行旋转操作
    UIButton *rotateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rotateButton.frame = CGRectMake(20, 300, 100, 50);
    [rotateButton setTitle:@"Rotate" forState:UIControlStateNormal];
    [rotateButton addTarget:self action:@selector(rotateView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rotateButton];
    
    // 添加一个按钮，点击时执行放大操作
    UIButton *scaleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    scaleButton.frame = CGRectMake(200, 300, 70, 50);
    [scaleButton setTitle:@"Scale" forState:UIControlStateNormal];
    [scaleButton addTarget:self action:@selector(scaleView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scaleButton];
    
    // 添加一个按钮，点击时执行缩小操作
    UIButton *scaleButton2 = [UIButton buttonWithType:UIButtonTypeSystem];
    scaleButton2.frame = CGRectMake(320, 300, 70, 50);
    [scaleButton2 setTitle:@"Scale" forState:UIControlStateNormal];
    [scaleButton2 addTarget:self action:@selector(scaleView2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scaleButton2];
    
    // 添加一个按钮，点击时执行旋转操作
    UIButton *BezierButton1= [UIButton buttonWithType:UIButtonTypeSystem];
    BezierButton1.frame = CGRectMake(20, 400, 100, 50);
    [BezierButton1 setTitle:@"BezierButton1" forState:UIControlStateNormal];
    [BezierButton1 addTarget:self action:@selector(buildBezierPath1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:BezierButton1];
    
    // 添加一个按钮，点击时执行放大操作
    UIButton *BezierButton2 = [UIButton buttonWithType:UIButtonTypeSystem];
    BezierButton2.frame = CGRectMake(200, 400, 70, 50);
    [BezierButton2 setTitle:@"BezierButton2" forState:UIControlStateNormal];
    [BezierButton2 addTarget:self action:@selector(buildBezierPath2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:BezierButton2];
    
    // 添加一个按钮，点击时执行缩小操作
    UIButton *BezierButton3 = [UIButton buttonWithType:UIButtonTypeSystem];
    BezierButton3.frame = CGRectMake(320, 400, 70, 50);
    [BezierButton3 setTitle:@"BezierButton3" forState:UIControlStateNormal];
    [BezierButton3 addTarget:self action:@selector(buildBezierPath3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:BezierButton3];
    
    // 添加一个按钮，点击时执行缩小操作
    UIButton *keyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    keyButton.frame = CGRectMake(20, 500, 70, 50);
    [keyButton setTitle:@"BezierButton3" forState:UIControlStateNormal];
    [keyButton addTarget:self action:@selector(buildKeyframeAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:keyButton];
    
    UIButton *transactionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    transactionButton.frame = CGRectMake(20, 600, 70, 50);
    [transactionButton setTitle:@"CATransaction" forState:UIControlStateNormal];
    [transactionButton addTarget:self action:@selector(buildCATransaction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:transactionButton];
}

- (void)rotateView {
    // 对视图进行45度旋转
    CGAffineTransform rotationTransform = CGAffineTransformRotate(self.demoView.transform, M_PI / 4);
    self.demoView.transform = rotationTransform;
}

- (void)scaleView {
    // 将视图的宽度和高度缩放到原来的1.5倍
    CGAffineTransform scaleTransform = CGAffineTransformScale(self.demoView.transform, 1.5, 1.5);
    self.demoView.transform = scaleTransform;
}

- (void)scaleView2 {
    // 将视图的宽度和高度缩放到原来的1.5倍
    CGAffineTransform scaleTransform = CGAffineTransformScale(self.demoView.transform, 0.5, 0.5);
    self.demoView.transform = scaleTransform;
}

- (void)buildBezierPath1 {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(100, 100)];
    [path addLineToPoint:CGPointMake(200, 100)];
    [path addLineToPoint:CGPointMake(200, 200)];
//    4. **关闭路径** 如果你想要闭合路径（即连接路径的终点和起点），可以使用：
    [path closePath];
}

// 5. **绘制曲线**贝塞尔曲线的绘制通常在 UIView 的 `-drawRect:` 方法中进行：
- (void)buildBezierPath2:(CGRect)rect {
    // 设置曲线颜色
    [[UIColor blueColor] setStroke];

    // 绘制路径
    UIBezierPath *quadPath = [[UIBezierPath alloc] init];

    [quadPath moveToPoint:CGPointMake(10, 150)]; // 起点

    [quadPath addQuadCurveToPoint:CGPointMake(300, 150) controlPoint:CGPointMake(150, 0)]; // 终点和控制点

    [[UIColor redColor] setFill];

    [quadPath stroke];
}

- (void)buildBezierPath3:(CGRect)rect {
    UIBezierPath *cubicPath = [[UIBezierPath alloc] init];

    [cubicPath moveToPoint:CGPointMake(10, 150)]; // 起点

    [cubicPath addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(100, 0) controlPoint2:CGPointMake(200, 300)]; // 终点和两个控制点

    [[UIColor greenColor] setFill];

    [cubicPath stroke];
}

- (void)buildKeyframeAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.values = @[
        [NSValue valueWithCGPoint:CGPointMake(100, 100)],
        [NSValue valueWithCGPoint:CGPointMake(200, 100)],
        [NSValue valueWithCGPoint:CGPointMake(200, 200)],
        [NSValue valueWithCGPoint:CGPointMake(100, 200)],
        [NSValue valueWithCGPoint:CGPointMake(100, 100)]
    ];
    /*
     或者，使用 path 属性来指定一个路径，动画将沿着这个路径进行。
     CGMutablePathRef path = CGPathCreateMutable();
     CGPathMoveToPoint(path, NULL, 100, 100);
     CGPathAddLineToPoint(path, NULL, 200, 100);
     CGPathAddLineToPoint(path, NULL, 200, 200);
     CGPathAddLineToPoint(path, NULL, 100, 200);
     CGPathCloseSubpath(path);
     animation.path = path;
     CGPathRelease(path);
     */
    animation.duration = 4.0; // 动画时长
//    animation.repeatCount = HUGE_VALF; // 重复次数，HUGE_VALF 表示无限重复
    // 动画完成后，默认情况下动画对象会从图层上移除，并且图层会回到动画开始之前的状态。
    // 如果你想让图层保持在动画结束的状态，需要设置动画对象的 fillMode 和 removedOnCompletion 属性。
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = false;
    [self.demoView.layer addAnimation:animation forKey:@"positionAnimation"];
}

- (void)buildCATransaction {
    [CATransaction begin];
    [CATransaction setAnimationDuration:2.0]; // 设置动画持续时间为1秒

    // 设置动画完成时的回调
    [CATransaction setCompletionBlock:^{
        NSLog(@"动画完成");
    }];

    // 修改图层属性，执行动画
    self.demoView.layer.opacity = 0;
    self.demoView.layer.backgroundColor = [UIColor orangeColor].CGColor;
    self.demoView.layer.cornerRadius = 10;
    // 3D变换
    [CATransaction commit]; // 提交事务，开始动画
}
@end
