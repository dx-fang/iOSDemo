//
//  ViewController.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/7.
//

#import "ViewController.h"
#import "OceanTabsViewController.h"

@interface ViewController ()
@property(strong,nonatomic) UILabel *label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad");
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat labelWidth = 200;
    CGFloat labelHeight = 20;
    CGFloat labelTopView = 150;
    CGRect frame = CGRectMake((screen.size.width-labelWidth)/2,labelTopView , labelWidth, labelHeight);

    self.label = [[UILabel alloc] initWithFrame:frame];
    self.label.text = @"hellow world";
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.label];
    
    OceanTabsViewController *tabBarController = [[OceanTabsViewController alloc] init];
    [self.view addSubview:tabBarController.view];
//     将UITabBarController添加为子视图控制器
    [self addChildViewController:tabBarController];
//
//    // 将UITabBarController的视图添加到当前视图控制器的视图中
    tabBarController.view.frame = self.view.bounds; // 或者设置为特定的frame
    [self.view addSubview:tabBarController.view];
    [tabBarController didMoveToParentViewController:self];
}

@end
