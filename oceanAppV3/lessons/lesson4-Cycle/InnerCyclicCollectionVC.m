//
//  InnerCyclicCollectionVC.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/20.
//

#import "InnerCyclicCollectionVC.h"

@interface InnerCyclicCollectionVC() <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<NSString *> *processedDataSource;
@property (strong, nonatomic) NSTimer *autoScrollTimer;
@end

@implementation InnerCyclicCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size
                                 .height - 100); // 设置单元格大小
    
    // 初始化collectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size
                                                                             .width, self.view.bounds.size
                                                                             .height - 100) collectionViewLayout:layout];
    self.collectionView.pagingEnabled = YES; // 开启分页效果，使每个item占满整个屏幕
    
    // 注册单元格
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    // 设置数据源和代理
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    // 设置滚动指示器
    self.collectionView.showsHorizontalScrollIndicator = YES; // 显示水平滚动指示器
    self.collectionView.showsVerticalScrollIndicator = NO; // 显示垂直滚动指示器
    self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    // 添加到视图
    [self.view addSubview:self.collectionView];
    
    // 创建UIPageControl
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    // 设置总页数
    pageControl.numberOfPages = 4;
    // 设置当前页
    pageControl.currentPage = 0;
    // 设置未选中页的颜色
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    // 设置选中页的颜色
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    // 设置位置和大小
    pageControl.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
    [pageControl addTarget:self action:@selector(pageControlDidChange:) forControlEvents:UIControlEventValueChanged];
    // 添加到视图
    [self.view addSubview:pageControl];
    
    self.processedDataSource = @[@"D", @"A", @"B", @"C", @"D", @"A"];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    [self setupAutoScrollTimer];
}

- (void)setupAutoScrollTimer {
    self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(scrollToNextItem) userInfo:nil repeats:YES];
}

- (void)scrollToNextItem {
    // 获取当前显示的item的indexPath
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
    NSLog(@"currentIndexPath---%@", currentIndexPath);
    // 计算下一个item的indexPath
    NSInteger nextItem = currentIndexPath.item + 1;
    NSInteger nextSection = currentIndexPath.section;
    
    // 如果已经是最后一个item，则滚动到第一个item
    if (nextItem == [self.collectionView numberOfItemsInSection:currentIndexPath.section]) {
        nextItem = 0;
        nextSection++;
        // 如果是最后一个section，则回到第一个section
        if (nextSection == [self.collectionView numberOfSections]) {
            nextSection = 0;
        }
    }
    
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
    // 滚动到下一个item
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.processedDataSource.count; // 示例数据量
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = indexPath.row % 2 == 1 ? [UIColor blueColor] : [UIColor redColor]; // 设置单元格背景色为示例
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger itemsCount = self.processedDataSource.count;
    if (itemsCount <= 1) return;
    
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    CGFloat width = scrollView.bounds.size.width;
    
    if (contentOffsetX >= width * (itemsCount - 1)) {
        // 滑动到最后一项，跳转到第二项
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    } else if (contentOffsetX <= 0) {
        // 滑动到第一项，跳转到倒数第二项
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:itemsCount - 2 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = (NSInteger)(scrollView.contentOffset.x / pageWidth);
//    pageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.autoScrollTimer invalidate];
    self.autoScrollTimer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self setupAutoScrollTimer];
}

#pragma UIPageControl
- (void)pageControlDidChange:(UIPageControl *)pageControl {
    // 用户点击了pageControl，更新UI等
    NSLog(@"当前页码：%ld", (long)pageControl.currentPage);
    // 这里可以根据pageControl的currentPage来切换显示的内容或视图
}

- (void)dealloc {
    [self.autoScrollTimer invalidate];
    self.autoScrollTimer = nil;
}
@end
