//
//  MyDelegate.h
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// Objective-C
@protocol MyDelegate <NSObject>
- (void)taskDidFinishWithResult:(NSString *)result;
@end

//@interface MyDelegate : NSObject
//
//@end

NS_ASSUME_NONNULL_END
