//
//  BaseViewController.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/20.
//

#import "BaseViewController.h"

@interface BaseViewController ()
@property(nonatomic, strong) UIButton *backButton;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏的通用样式
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor]; // 导航栏背景色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor]; // 导航栏元素颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}]; // 导航栏标题颜色
    
    // 添加返回按钮（如果需要）
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 60, 40, 40)];
//    self.backButton.frame = CGRectMake(50, 100, 200, 40); // 设置按钮的位置和大小
    [self.backButton setTitle:@"返回" forState:UIControlStateNormal]; // 设置按钮的标题
    self.backButton.backgroundColor = [UIColor blackColor];
    [self.backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside]; // 设置按钮点击事件
    [self.view addSubview:self.backButton]; // 将按钮添加到视图上
}

- (void)backAction:(UIButton *)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        // 在这里执行任何需要在视图控制器关闭后进行的操作
    }];

}

/* TODO
 `navigationController.navigationBar` 是 `UINavigationController` 的一个属性，它允许你访问和自定义整个导航控制器的导航栏。通过这个属性，你可以设置导航栏的样式、外观和行为，包括背景颜色、标题样式、是否透明等。

 ### 设置导航栏背景颜色

 ```objc
 self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
 ```

 ### 设置导航栏标题颜色和字体

 ```objc
 [self.navigationController.navigationBar setTitleTextAttributes:
  @{NSForegroundColorAttributeName:[UIColor whiteColor],
    NSFontAttributeName:[UIFont systemFontOfSize:18]}];
 ```

 ### 设置导航栏透明

 ```objc
 [self.navigationController.navigationBar setTranslucent:YES];
 ```

 ### 隐藏导航栏

 在某些情况下，你可能希望在特定的视图控制器中隐藏导航栏。

 ```objc
 - (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:YES animated:animated];
 }

 - (void)viewWillDisappear:(BOOL)animated {
     [super viewWillDisappear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:animated];
 }
 ```

 ### 设置导航栏背景图片

 ```objc
 [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"yourImageName"] forBarMetrics:UIBarMetricsDefault];
 ```

 ### 设置导航栏阴影图片

 ```objc
 self.navigationController.navigationBar.shadowImage = [UIImage new];
 ```

 ### 使用大标题

 在iOS 11及以上版本，`UINavigationBar` 支持大标题样式。

 ```objc
 if (@available(iOS 11.0, *)) {
     self.navigationController.navigationBar.prefersLargeTitles = YES;
     self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
 }
 ```

 ### 注意事项

 - 修改 `navigationBar` 的样式时，应该考虑整个应用的一致性。如果你想为特定的视图控制器设置不同的导航栏样式，可能需要在视图控制器的 `viewWillAppear:` 和 `viewWillDisappear:` 方法中进行相应的设置和还原。
 - 隐藏导航栏可能会影响用户的导航体验，确保在适当的上下文中使用这一功能。
 - 使用大标题时，应该注意与界面其他元素的协调，以及在不同iOS版本上的表现。

 通过访问和修改 `navigationController.navigationBar`，你可以灵活地定制导航栏，以适应应用的设计需求。
 */
@end

