//
//  ThreadSafeArray.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/27.
//

#import "ThreadSafeArray.h"

@implementation ThreadSafeArray
- (instancetype)init {
    self = [super init];
    if (self) {
        internalArray = [[NSMutableArray alloc] init];
        lock = [[NSLock alloc] init];
    }
    return self;
}

- (void)addObject:(id)object {
    [lock lock];
    [internalArray addObject:object];
    [lock unlock];
}

- (void)removeObject:(id)object {
    [lock lock];
    [internalArray removeObject:object];
    [lock unlock];

}

- (id)objectAtIndex:(NSUInteger)index {
    [lock lock];
    id object = [internalArray objectAtIndex:index];
    [lock unlock];
    return object;

}

- (NSUInteger)count {
    [lock lock];
    NSUInteger count = [internalArray count];
    [lock unlock];
    return count;
}

@end
