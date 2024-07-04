//
//  CyclicCollectionVC.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/20.
//

#import "CyclicCollectionVC.h"

@interface CyclicCollectionVC ()
//@property(nonatomic, strong)NSArray<NSString *> processedDataSource;
@property (nonatomic, strong) NSArray<NSString *> *processedDataSource;
@end

/*
 在Objective-C中实现可以循环滑动的图集，通常会用到UICollectionView。通过巧妙地设计数据源和处理滚动事件，可以让用户感觉到图集是可以无限循环的。以下是实现这一功能的基本步骤：
 1. 准备数据源
 首先，准备好你的图集数据源。为了实现循环滑动的效果，你可以在数据源的头部和尾部各添加一份额外的数据。比如，如果你的图集数据是[A, B, C, D]，那么处理后的数据源可能是[D, A, B, C, D, A]。
 2. 设置UICollectionView
 使用UICollectionView来展示图集。设置其布局（通常是UICollectionViewFlowLayout），并且配置单元格（Cell）来展示图集中的每一项。
 3. 配置数据源和代理
 实现UICollectionViewDataSource和UICollectionViewDelegate协议，配置数据源方法来返回处理后的数据源，以及处理用户的滑动事件。
 4. 实现循环滑动
 初始位置：在viewDidLoad或者viewWillAppear中，将UICollectionView滚动到处理后的数据源的第二项（即原始数据的第一项）的位置。这样用户在开始滑动时看到的是第一个元素。
 无缝循环：在UIScrollViewDelegate的scrollViewDidScroll方法中检测滚动位置。当用户滑动到数据源的头部或尾部时，无缝地将UICollectionView跳转到中间部分的对应位置。例如，当用户滑动到最后一项（处理后数据源的倒数第二项）之后继续向右滑动时，程序应该将UICollectionView无缝地跳转到第二项的位置。
 你可以实现一个在用户看来可以无限循环滑动的图集。需要注意的是，这里的实现依赖于在数据源两端添加额外数据的技巧，以及在滑动时适时调整UICollectionView的滚动位置，从而实现无缝循环的效果。
 */
@implementation CyclicCollectionVC

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    self.processedDataSource = @[@"D", @"A", @"B", @"C", @"D", @"A"];
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // 创建布局
       UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
       layout.itemSize = CGSizeMake(100, 100); // 设置单元格大小
    // 将UICollectionView滚动到处理后的数据源的第二项（即原始数据的第一项）的位置。这样用户在开始滑动时看到的是第一个元素。
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    // 配置cell
//      UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellIdentifier" forIndexPath:indexPath];
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
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
