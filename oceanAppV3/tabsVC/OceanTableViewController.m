// MyTableViewController.h


#import <UIKit/UIKit.h>
#import "OceanTableViewController.h"
#import "GCDViewController.h"
#import "OperationViewController.h"
#import "blockVC.h"
#import "Config.h"

@implementation OceanTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 在这里进行额外的初始化操作，比如注册单元格
    // TODO:多种cell复用的方法
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 返回表格视图的分区数
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 返回每个分区的行数
    return 20; // 示例数据
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.backgroundColor = [UIColor lightGrayColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    
    if (section == 0) {
        headerLabel.text = @"Header for Section 0";
    } else {
        headerLabel.text = @"Header for Other Sections";
    }
    
    return headerLabel;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    // 类似地，你可以为尾部视图进行自定义
//    // ...
//    return footerView;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    // 根据indexPath.section来区分不同分区
    if (indexPath.section == 0) {
        // 设置第一个分区的单元格样式
        cell.textLabel.text = @"Section 0";
    } else {
        // 设置其他分区的单元格样式
        cell.textLabel.text = @"Other Sections";
    }
    // 配置单元格...
    if (indexPath.row < [vcClassNames count]) {
        // TODO:crash问题解决
        NSString *pre = vcClassNames[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"欢迎来到%@:Row %ld", pre, (long)indexPath.row];
    } else {
        // 配置单元格...
        cell.textLabel.text = [NSString stringWithFormat:@"Row %ld", (long)indexPath.row];
    }
//    if (indexPath.row == 0) {
//        cell.textLabel.text = [NSString stringWithFormat:@"欢迎来到%@:Row %ld", pre, (long)indexPath.row];
//    } else if (indexPath.row == 1) {
//        cell.textLabel.text = [NSString stringWithFormat:@"多线程之GCD%@:Row %ld", pre (long)indexPath.row];
//    } else if (indexPath.row == 2) {
//        cell.textLabel.text = [NSString stringWithFormat:@"多线程之NSOperation", (long)indexPath.row];
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 用户点击了表格视图中的某个单元格
    NSLog(@"点击了第 %ld 行", (long)indexPath.row);
    // 根据indexPath执行相应的操作，比如跳转到另一个视图控制器等
    if (indexPath.row < [vcClassNames count]) {
//        GCDViewController *gcdVC = [[GCDViewController alloc] init];
        UIViewController *vc = [Config buildVCWithIndex:indexPath.row];
//        [self showTableViewControllerWithNav:vc]; // 没成功TODO
        [self showTableViewControllerWithPresent:vc];
    } else {
    }
    //不要忘记在视图控制器或管理UITableView的对象中取消选中单元格，以避免用户点击后单元格保持选中状态。这通常在tableView:didSelectRowAtIndexPath:方法的最后通过调用deselectRowAtIndexPath:animated:方法来完成。
    // 取消选中效果
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark function
// 两种方式进入到VC
// 如果你想返回到导航栈中的特定页面，可以使用popToViewController:animated:或popToRootViewControllerAnimated:方法。

/*
 当使用 `[self.navigationController pushViewController:vc animated:YES];` 没有成功跳转到新的视图控制器（VC）时，可能是由于以下几个原因导致的：

 ### 1. `self.navigationController` 为 `nil`

 这是最常见的原因之一。如果当前视图控制器不在一个 `UINavigationController` 的导航栈中，`self.navigationController` 将会是 `nil`，因此无法执行 `pushViewController:animated:` 方法。确保你的视图控制器是通过 `UINavigationController` 显示的。例如，在应用的 `AppDelegate` 中设置根视图控制器时，应该这样做：

 ```objc
 YourViewController *vc = [[YourViewController alloc] init];
 UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
 self.window.rootViewController = navController;
 ```

 ### 2. 正在进行另一个转场动画

 如果你尝试在另一个转场动画正在进行时推送一个视图控制器，可能会导致推送失败。确保在前一个动画完成后再进行下一个转场操作。

 ### 3. 视图控制器已经在导航栈中

 如果你尝试将一个已经存在于导航栈中的视图控制器再次推送，这可能会导致不符合预期的行为。每次推送应该是一个新的视图控制器实例。

 ### 4. 自定义了导航控制器的转场动画

 如果你自定义了导航控制器的转场动画，并且在动画控制器中有错误，这可能会阻止视图控制器的正常推送。检查你的转场动画代码，确保没有错误。

 ### 5. 视图控制器的 `viewDidLoad` 方法中有阻塞主线程的操作

 如果在 `viewDidLoad` 或其他生命周期方法中执行了耗时的操作，尤其是阻塞了主线程的操作，这可能会影响视图控制器的正常显示。确保这些耗时操作是异步执行的。

 ### 解决方法
 - 确保当前视图控制器被嵌入在 `UINavigationController` 中。
 - 避免在转场动画进行时进行新的转场操作。
 - 使用新的视图控制器实例进行推送。
 - 检查自定义转场动画的实现。
 - 避免在视图控制器的生命周期方法中执行耗时或阻塞主线程的操作。

 如果以上方法都不能解决问题，建议使用调试工具检查 `self.navigationController` 的状态，以及在推送视图控制器前后的导航栈状态，这有助于诊断问题。
 */
- (void)showTableViewControllerWithNav: (UIViewController*) vc {
    // self.navigationController --nil
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showTableViewControllerWithPresent:(UIViewController*)vc {
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}


@end
