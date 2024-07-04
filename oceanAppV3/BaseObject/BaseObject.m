//
//  BaseObject.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/22.
//

#import "BaseObject.h"

@interface BaseObject ()<NSCoding>
@end


@implementation BaseObject
//@synthesize name = customNameVariable; // 使用 @synthesize 指定成员变量的名称，为属性指定一个特定的成员变量名，而不是使用自动合成的名称
- (void)add {
    NSLog(@"BaseObject主类-add");
}

- (void)dealloc {
//    [super dealloc];
    NSLog(@"BaseObject主类--dealloc");
}

-(void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeInteger:self.age forKey:@"age"];

}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        _name = [decoder decodeObjectForKey:@"name"];
        _age = [decoder decodeIntegerForKey:@"age"];
    }
    return self;

}

- (void)undo {
    NSLog(@"object-undo-test");
}

@end
