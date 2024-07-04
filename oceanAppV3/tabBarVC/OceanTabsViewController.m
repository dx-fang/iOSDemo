//
//  OceanTabsViewController.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/7.
//

#import "OceanTabsViewController.h"
#import "ReadViewController.h"
#import "DaysViewController.h"
#import "FirstTabBarVC.h"
#import "OceanTableViewController.h"
//#import "SwiftTableView.swift"
#import "oceanAppV3-Swift.h"

@interface OceanTabsViewController ()

@end

@implementation OceanTabsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//      创建Tab Bar中的视图控制器
//     FirstViewController *firstVC = [[FirstViewController alloc] init];
    
//     UINavigationController *firstNav = [[UINavigationController alloc] initWithRootViewController:firstVC];
//    firstVC.tabBarItem.title = @"首页";
//    firstVC.tabBarItem.image = [UIImage imageNamed:@"home_icon"];

//     SecondViewController *secondVC = [[SecondViewController alloc] init];
//     UINavigationController *secondNav = [[UINavigationController alloc] initWithRootViewController:secondVC];
//    secondVC.tabBarItem.title = @"设置";
//    secondVC.tabBarItem.image = [UIImage imageNamed:@"settings_icon"];
    
    FirstTabBarVC *firstVC = [[FirstTabBarVC alloc] init];
    firstVC.tabBarItem.title = @"home";
    
    ReadViewController *readVC = [[ReadViewController alloc] init];
    readVC.tabBarItem.title = @"read";

    OceanTableViewController *tableVC = [[OceanTableViewController alloc]init];
    tableVC.tabBarItem.title = @"table";
    
    DaysViewController *daysVC = [[DaysViewController alloc] init];
    daysVC.tabBarItem.title = @"days";
    
    SwiftViewController *swiftViewController = [[SwiftViewController alloc] init];
//    [swiftViewController testFunction];
    swiftViewController.tabBarItem.title = @"swift";
    
    self.viewControllers = @[tableVC, firstVC, readVC, daysVC, swiftViewController];
    
//    [self addChildViewController:tabBarController];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*
 添加子视图控制器的步骤
 **调用addChildViewController:**：这个方法将子视图控制器添加到父视图控制器中，但此时子视图控制器的视图还没有被添加到父视图控制器的视图层次结构中。这个方法会自动调用子视图控制器的willMoveToParentViewController:方法，传入父视图控制器作为参数。
 添加子视图控制器的视图：通常需要手动将子视图控制器的视图添加到父视图控制器的视图或其子视图中。这通常通过设置frame和调用addSubview:来完成。
 **调用didMoveToParentViewController:**：在子视图控制器的视图被添加到父视图控制器的视图层次结构后，需要调用这个方法。这个方法告诉子视图控制器，它已经被添加到父视图控制器中。
 */
- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    NSLog(@"willMoveToParentViewController");
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
    NSLog(@"didMoveToParentViewController");
}

/* TODO
 对生命周期的影响
 addChildViewController:和didMoveToParentViewController:的调用不会直接触发子视图控制器的标准生命周期事件（如viewDidLoad、viewWillAppear:、viewDidAppear:等）。这些生命周期事件主要与视图控制器的视图的加载和显示相关。
 当子视图控制器的视图被添加到父视图控制器的视图层次结构中时，如果这是子视图控制器的视图第一次被加载，那么viewDidLoad会被调用。随后，当子视图控制器的视图即将显示或已经显示时，viewWillAppear:和viewDidAppear:也会被相应地调用。
 当子视图控制器从父视图控制器中移除时，应该调用willMoveToParentViewController:方法并传入nil，然后从父视图控制器的视图中移除子视图控制器的视图，最后调用removeFromParentViewController。这个过程会触发viewWillDisappear:和viewDidDisappear:方法。
 */


@end
