//
//  CAView.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/17.
//

#import "CAView.h"

@implementation CAView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.backgroundColor = [[UIColor redColor] CGColor];
        self.frame = frame;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)adjustStickyState:(BOOL)sticky {
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
//    [self.layerForSticky setHidden:!sticky];
//    [self.layerForNonSticky setHidden:sticky];
    [CATransaction commit];
}

// 图层变换/转换
//- (void)a {
//    let animation = CABasicAnimation(keyPath: "position.x")
//    animation.fromValue = 0.0
//    animation.toValue = 200.0
//    animation.duration = 1.0
//    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
//    layer.add(animation, forKey: "positionAnimation")
//    layer.transform = CATransform3DMakeRotation(CGFloat.pi / 4, 0, 0, 1)
//}
//
//- (void)b {
//    // 创建了一个 UIImageView，并将一张图片设置为其内容。然后，我们创建了一个 CALayer 作为蒙版层，并将其设置为 UIImageView 的 mask 属性。通过设置 mask 属性，蒙版层会裁剪 UIImageView 的内容，从而实现蒙版效果。
//
//    let imageView = UIImageView(frame: CGRect(x: 100, y: 200, width: 100, height: 100))
//    imageView.image = UIImage(named: "风景.jpg")
//    view.addSubview(imageView)
//
//    let maskLayer = CALayer()
//    maskLayer.frame = imageView.bounds
//    maskLayer.contents = UIImage(named: "sicon2x")?.cgImage
//    imageView.layer.mask = maskLayer
//}

@end
