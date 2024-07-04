//
//  ReadViewController.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/9.
//

#import "ReadViewController.h"
#import "ContentViewController.h"
// https://blog.csdn.net/HDFQQ188816190/article/details/104010814

@interface ReadViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
 
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pageContentArray;
 
@end
 
@implementation ReadViewController
 
#pragma mark - Lazy Load
 
- (NSArray *)pageContentArray {
    if (!_pageContentArray) {
        NSMutableArray *arrayM = [[NSMutableArray alloc] init];
        for (int i = 1; i < 10; i++) {
            NSString *contentString = [[NSString alloc] initWithFormat:@"This is the page %d of content displayed using UIPageViewController", i];
            [arrayM addObject:contentString];
        }
        _pageContentArray = [[NSArray alloc] initWithArray:arrayM];
 
    }
    return _pageContentArray;
}
 
#pragma mark - Life Cycle
 
- (void)viewDidLoad {
    [super viewDidLoad];
    [self testStatic];
    // 设置UIPageViewController的配置项
//    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey : @(20)};
    NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
 
    // 根据给定的属性实例化UIPageViewController--- UIPageViewControllerTransitionStyleScroll
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:options];
    // 设置UIPageViewController代理和数据源
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    // 设置UIPageViewController初始化数据, 将数据放在NSArray里面
    // 如果 options 设置了 UIPageViewControllerSpineLocationMid,注意viewControllers至少包含两个数据,且 doubleSided = YES
    
    ContentViewController *initialViewController = [self viewControllerAtIndex:0];// 得到第一页
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers
                              direction:UIPageViewControllerNavigationDirectionReverse
                               animated:NO
                             completion:nil];
 
    // 设置UIPageViewController 尺寸
    _pageViewController.view.frame = self.view.bounds;
 
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
 
}
 
#pragma mark - UIPageViewControllerDataSource And UIPageViewControllerDelegate
 
#pragma mark 返回上一个ViewController对象
 
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(ContentViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    // 返回的ViewController，将被添加到相应的UIPageViewController对象上。
    // UIPageViewController对象会根据UIPageViewControllerDataSource协议方法,自动来维护次序
    // 不用我们去操心每个ViewController的顺序问题
    return [self viewControllerAtIndex:index];
    
    
}
 
#pragma mark 返回下一个ViewController对象
 
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(ContentViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.pageContentArray count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
    
    
}
 
#pragma mark - 根据index得到对应的UIViewController
 
- (ContentViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.pageContentArray count] == 0) || (index >= [self.pageContentArray count])) {
        return nil;
    }
    // 创建一个新的控制器类，并且分配给相应的数据
    ContentViewController *contentVC = [[ContentViewController alloc] init];
    contentVC.content = [self.pageContentArray objectAtIndex:index];
    return contentVC;
}
 
#pragma mark - 数组元素值，得到下标值
 
- (NSUInteger)indexOfViewController:(ContentViewController *)viewController {
    return [self.pageContentArray indexOfObject:viewController.content];
}
 
- (void)testStatic {
//    NSLog(@"vc:%p--%d", &age, age);
//    age = 40;
//    NSLog(@"vc:%p--%d", &age, age);
//    [[Person new] add];
//    NSLog(@"vc:%p--%d", &age, age);
//    [Person reduce];
//    NSLog(@"vc:%p--%d", &age, age);
//    [[Person new] wy_add];
}
@end

static int rdsage = 10;

@interface RDSPerson : NSObject
-(void)add;
+(void)reduce;
@end

@implementation RDSPerson

- (void)add {
    rdsage++;
    NSLog(@"Person内部:%@-%p--%d", self, &rdsage, rdsage);
}

+ (void)reduce {
    rdsage--;
    NSLog(@"Person内部:%@-%p--%d", self, &rdsage, rdsage);
}
@end


@implementation RDSPerson (WY)

- (void)wy_add {
    rdsage++;
    NSLog(@"Person (wy)内部:%@-%p--%d", self, &rdsage, rdsage);
}

@end
