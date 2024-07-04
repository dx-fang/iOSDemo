//
//  SecondTabBarVC.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/16.
//

#import "SecondTabBarVC.h"
#import "OceanTableViewController.h"

@interface SecondTabBarVC ()
// TODO:
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) OceanTableViewController* tableViewController;
@end

@implementation SecondTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableViewController = [[OceanTableViewController alloc] initWithStyle:UITableViewStylePlain];
    // 假设self是目标视图控制器
    [self addChildViewController:self.tableViewController];
    [self.view addSubview:self.tableViewController.view];

    // 设置tableViewController视图的大小和位置
    self.tableViewController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);

    // 完成添加子视图控制器的过程
    [self.tableViewController didMoveToParentViewController:self];
    
    // 设置数据源和代理
    self.tableViewController.tableView.dataSource = self;
    self.tableViewController.tableView.delegate = self;

    // 注册单元格
    [self.tableViewController.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellIdentifier"];

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
