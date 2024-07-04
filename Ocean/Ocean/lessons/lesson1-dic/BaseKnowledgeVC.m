//
//  baseknowledgeVC.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/20.
//

#import "BaseKnowledgeVC.h"

@interface BaseKnowledgeVC ()
@property(nonatomic, strong) UILabel *titleLBL;
@property(nonatomic, strong) UIButton *setDicButton;
@property(nonatomic, strong) UIButton *getDicButton;
@end

@implementation BaseKnowledgeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // 你的视图控制器特定的设置
    self.view.backgroundColor = [UIColor yellowColor];
//    self.navigationItem.title = @"我的页面";
//    // 覆盖基类中的导航栏设置
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareAction)];

    // Do any additional setup after loading the view.
    self.titleLBL = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 200, 40)];
    self.titleLBL.backgroundColor = [UIColor redColor];
    self.titleLBL.text = @"塞值是否会crash";
    [self.view addSubview:self.titleLBL]; // 将按钮添加到视图上
    
    self.setDicButton =[UIButton buttonWithType:UIButtonTypeSystem];
//    [[UIButton alloc] initWithFrame:CGRectMake(20, 200, 200, 30)];
    self.setDicButton.frame = CGRectMake(80, 200, 200, 40); // 设置按钮的位置和大小
    [self.setDicButton setTitle:@"点击我给数组塞值" forState:UIControlStateNormal]; // 设置按钮的标题
    [self.getDicButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.setDicButton  addTarget:self action:@selector(setButtonClicked:)
                 forControlEvents:UIControlEventTouchUpInside]; // 设置按钮点击事件
    [self.view addSubview:self.setDicButton]; // 将按钮添加到视图上
    
    self.getDicButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.getDicButton.frame = CGRectMake(80, 300, 200, 40); // 设置按钮的位置和大小
    [self.getDicButton setTitle:@"点击取值" forState:UIControlStateNormal];
    [self.getDicButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal]; // 设置标题颜色
    [self.getDicButton addTarget:self action:@selector(getButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.getDicButton];
    
}

- (void)setButtonClicked:(UIButton *)sender {
    // 正确
    NSDictionary *dict1 = @{@"key1": @"value1", @"key2": [NSNull null]}; // 使用NSNull代替nil值
    // 错误 - 会导致崩溃
//    NSDictionary *dict2 = @{@"key1": @"value1", @"key2": nil};
    // 正确
    NSArray *array1 = @[@"item1", @"item2", [NSNull null]]; // 使用NSNull代替nil
    // 错误 - 会导致崩溃
//    NSArray *array2 = @[@"item1", @"item2", nil];
    
    NSString *item1 = @"Apple";
    NSString *item2 = @"Banana";
    NSString *item3 = nil; // 假设这是一个动态确定的值，可能为nil
    NSString *item4 = @"Cherry";

    // 使用 arrayWithObjects: 并以 nil 结尾来创建数组
    NSArray *fruits = [NSArray arrayWithObjects:item1, item2, item3, item4, nil];

    // 结果：fruits 数组只包含 @"Apple" 和 @"Banana"
    [self backAction];

}

- (void)getButtonClicked:(UIButton *)sender {
    NSLog(@"getButtonClicked");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)shareAction {
    // 分享按钮的行为
    NSLog(@"shareAction");
}

@end
