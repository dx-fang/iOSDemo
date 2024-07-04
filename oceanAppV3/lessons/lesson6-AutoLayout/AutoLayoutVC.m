//
//  AutoLayoutVC.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/24.
//

#import "AutoLayoutVC.h"

@interface AutoLayoutVC ()

@end

@implementation AutoLayoutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    redView.translatesAutoresizingMaskIntoConstraints = NO; // 关键步骤，允许 Auto Layout 控制此视图
    [self.view addSubview:redView];

    UIView *blueView = [[UIView alloc] init];
    blueView.backgroundColor = [UIColor blueColor];
    blueView.translatesAutoresizingMaskIntoConstraints = NO; // 同上
    [self.view addSubview:blueView];

    // 红色视图约束
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:redView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:redView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:-50]];

    [redView addConstraint:[NSLayoutConstraint constraintWithItem:redView
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0
                                                         constant:100]];

    [redView addConstraint:[NSLayoutConstraint constraintWithItem:redView
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0
                                                         constant:100]];

    // 蓝色视图约束
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:blueView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:redView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:20]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:blueView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:redView
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];

    [blueView addConstraint:[NSLayoutConstraint constraintWithItem:blueView
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:redView
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:1.0
                                                          constant:0]];

    [blueView addConstraint:[NSLayoutConstraint constraintWithItem:blueView
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:redView
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:1.0
                                                          constant:0]];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
