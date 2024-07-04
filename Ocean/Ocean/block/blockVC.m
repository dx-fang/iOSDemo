//
//  blockVC.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/16.
//

#import "blockVC.h"

static int blockAge = 10;

@interface BlockPerson : NSObject
-(void)add;
+(void)reduce;
@end

@implementation BlockPerson

- (void)add {
    blockAge++;
    NSLog(@"Person内部:%@-%p--%d", self, &blockAge, blockAge);
}

+ (void)reduce {
    blockAge--;
    NSLog(@"Person内部:%@-%p--%d", self, &blockAge, blockAge);
}
@end


@implementation BlockPerson (WY)

- (void)wy_add {
    blockAge++;
    NSLog(@"Person (wy)内部:%@-%p--%d", self, &blockAge, blockAge);
}

@end

@interface blockVC ()

@end

@implementation blockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self testBlock];
    [self testStatic];
}

- (void)testBlock {
    // __block int count = 10;
    int count = 10;
    void (^myBlock)(void) = ^{
        NSLog(@"Count111 = %d", count);
        // count = 20; // 这里会报错，因为默认情况下block内部不能修改外部变量的值
        NSLog(@"Count222 = %d", count);
    };
    myBlock();
}

- (void)testStatic {
    NSLog(@"vc:%p--%d", &blockAge, blockAge);
    blockAge = 40;
    NSLog(@"vc:%p--%d", &blockAge, blockAge);
    [[BlockPerson new] add];
    NSLog(@"vc:%p--%d", &blockAge, blockAge);
    [BlockPerson reduce];
    NSLog(@"vc:%p--%d", &blockAge, blockAge);
    [[BlockPerson new] wy_add];
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
