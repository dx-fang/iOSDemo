//
//  ContentViewController.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/9.
//

#import "ContentViewController.h"
#import "CAView.h"

#define kRandomColor ([UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0f])

@interface ContentViewController () <CALayerDelegate>
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) CAView *caView;
@end

 
@implementation ContentViewController
 
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor]; /*kRandomColor*/;
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 100)];
    _contentLabel.backgroundColor = [UIColor blueColor];
    _contentLabel.text = @"ContentViewController";
//    _contentLabel.numberOfLines = 0;
//    _contentLabel.backgroundColor = kRandomColor;
    
    [self.view addSubview:_contentLabel];
    _caView = [[CAView alloc] initWithFrame:CGRectMake(100, 300, 50, 50)];
    [self.view addSubview:_caView];
    
    self.view.backgroundColor = [UIColor lightGrayColor];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];

    view.backgroundColor = [UIColor whiteColor];

    view.center = self.view.center;

    [self.view addSubview:view];

    CALayer *layer = [CALayer layer];

    [view.layer addSublayer:layer];

    layer.frame = CGRectMake(0, 0, 200, 200);
    layer.backgroundColor = [[UIColor redColor] CGColor];
    // imageNamed: 会根据不同机型取不同倍图

    UIImage *image = [UIImage imageNamed:@"test"];

    // UIImage转CGImageRef时scale属性丢失
//    和UIImage不同，CGImage没有拉伸的概念。使用UIImage类去读取图片的时候，它会读取了屏幕（1x、2x、3x）对应尺寸的图片。但是用CGImage来设置layer.contents时，拉伸这个因素在转换的时候就丢失了，不过我们可以通过手动设置contentsScale来修复这个问题
    CGImageRef imageRef = image.CGImage;

    // 坑点：CALayer有一个属性叫做 contents ，这个属性的类型被定义为id，但是，如果你给contents赋的不是CGImage，那么你得到的图层将是空白的。contents 这个奇怪的表现是由 Mac OS 的历史原因造成的。它之所以被定义为 id 类型，是因为在 Mac OS 系统上，这个属性对 CGImage 和 NSImage 类型的值都起作用。如果你试图在iOS平台上将 UIImage 的值赋给它，只能得到一个空白的图层。
    layer.contents = (__bridge id)imageRef; // image;

    // 设置图片缩放

    // 如果contentsGravity设置为自动缩放，可以不用设置这个属性
    layer.contentsScale = image.scale;

    // 设置图片居中不缩放
    layer.contentsGravity = kCAGravityCenter; // kCAGravityResize
    
    layer.masksToBounds = false;
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(300, 300, 200, 200)];
    view2.backgroundColor = [UIColor blueColor];

    view.center = self.view.center;

    [self.view addSubview:view2];

    CALayer *layer2 = [CALayer layer];

    [view2.layer addSublayer:layer2];

    layer2.frame = CGRectMake(0, 0, 100, 100);

    // 设置代理

    layer2.delegate = self;

    // display方法必须手动调用，不然不会执行绘制

    [layer2 display];

}
 
- (void)viewWillAppear:(BOOL)paramAnimated{
    [super viewWillAppear:paramAnimated];
    _contentLabel.text = _content;
}
 

// [layer display]需要手动调用，CALayer不会自动重绘它的内容，而是把重绘决定权交给了开发者。
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    // 画一个圆环

    CGContextSetLineWidth(ctx, 10);

    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);

    CGContextStrokeEllipseInRect(ctx, layer.bounds);

}
@end
