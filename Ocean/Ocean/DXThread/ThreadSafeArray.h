//
//  ThreadSafeArray.h
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThreadSafeArray : NSObject
{
   NSMutableArray *internalArray;
   NSLock *lock;
}
- (void)addObject:(id)object;
- (void)removeObject:(id)object;
- (id)objectAtIndex:(NSUInteger)index;
- (NSUInteger)count;
@end

NS_ASSUME_NONNULL_END
