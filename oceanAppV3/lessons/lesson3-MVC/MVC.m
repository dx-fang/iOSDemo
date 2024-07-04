//
//  MVC.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/22.
//

#import "MVC.h"
#import "DemoView.h"
#import "BaseObject.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface MVC () <MVCDelegate>

@property (nonatomic, strong)BaseObject *baseobj;
@property (nonatomic, weak)BaseObject *baseobj1;
@property (nonatomic, strong)BaseObject *baseobj2;
@end

@implementation MVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //setupUI
    
    //1.createView
    //    UIView *view = [[UIView alloc]init];
    //    view.frame = CGRectMake(100, 100, 100, 100);
    //    view.backgroundColor = [UIColor orangeColor];
    //    [self.view addSubview:view];
    //
    //    //2.createButton
    //    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoDark];
    //    btn.center = self.view.center;
    //    [self.view addSubview:btn];
    //
    //3...写法优势
    /*
     比如按钮，可以在当前控制器直接add target:添加点击事件，在当前控制器内就能调用到点击方法，不需要设置代理之类的；
     比如要找某个界面，直接切到这个界面对应的controller就行，因为View 写在 Controller里面，不用去别的地方找，就这里有；
     比如一个View，里面有一张图片，图片依赖于网络资源，这样写的好处，可以直接让 View 在 Controller 中就能拿到资源，不需要传值
     缺点！！：
     导致Controller特别臃肿，里面代码特别多，视图一复杂起来，代码量可能过1000行，不好维护
     写在Controller里无法复用，除非你在 VC2里面 copy 当前VC中的 View的代码
     特别low！！会被懂架构的人瞧不起，喷你根本不是MVC,是MC架构，可能还要你来段喊麦证明一下自己(-。-)
     */
    
    // 4.优化/ createView - 参数通过`View`的函数作为外部参数传进去
    DemoView *view = [[DemoView alloc] initWithTitleStr:@"我是参数"];
    view.frame = CGRectMake(100, 100, 400, 30);
    view.delegate = self;
    [self.view addSubview:view];
    // 5、带block
    void (^demoBlock)(NSString*name) = ^(NSString*name) {
        NSLog(@"返回参数222%@", name);
    };
    // 循环，self
    void (^block)(void) = ^() {
        NSLog(@"声明block");
        [self performSelector:@selector(undo)];
    };
    DemoView *view2 = [[DemoView alloc] initWithTitleStr:@"我是参数2" withBlock:^{
        NSLog(@"block回参数");
        block();
    }];
    view2.frame = CGRectMake(100, 300, 400, 30);
    [self.view addSubview:view2];
    
    DemoView *view3 = [[DemoView alloc] initWithTitleStr:@"我是参数3" withParmaBlock:^(NSString * _Nonnull name) {
        NSLog(@"block带回参数11%@", name);
        demoBlock(name);
    }];
    view3.frame = CGRectMake(100, 400, 400, 30);
    [self.view addSubview:view3];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeInfoDark];
    btn2.frame = CGRectMake(100, 500, 300, 40);
    btn2.backgroundColor = [UIColor redColor];
    [btn2 setTitle:@"妞妞怒" forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    [btn2 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self test];
}

//- (void)undo {
//    NSLog(@"self-undo-test");
//}

- (void)other {
    NSLog(@"self-other-test");
}

- (void)other2 {
    NSLog(@"self-other2-test");
}

//实例方法动态解析
//+(BOOL)resolveInstanceMethod:(SEL)sel{
//    NSLog(@"resolveInstanceMethod");
//    if (sel == @selector(undo)) {
//       //动态添加  动态给test方法添加一个方法实现  这个方法会被添加到类对象的class_rw_t的方法列表中
//    Method method = class_getInstanceMethod(self, @selector(other));
//    //这里是的self是类对象   注意这里西部给类对象添加方法
//    class_addMethod(self, sel, method_getImplementation(method), method_getTypeEncoding(method));
//        return YES;
//    }
//    return [super resolveInstanceMethod:sel];
//}
//
//
////类方法动态解析
//+(BOOL)resolveClassMethod:(SEL)sel{
//    NSLog(@"resolveClassMethod");
//    //动态添加
//    if (sel == @selector(undo)) {
//            //动态添加  动态给test方法添加一个方法实现  这个方法会被添加到元类对象的class_rw_t的方法列表中
//        Method method = class_getInstanceMethod(self, @selector(other2));
//        // 这里是的self是类对象  获取到元类对象 这里一定要给元类对象添加方法
//        class_addMethod(object_getClass(self), sel, method_getImplementation(method), method_getTypeEncoding(method));
//        return YES;
//    
//    }
//    return  [super resolveClassMethod:sel];
//}

// 消息转发
- (id)forwardingTargetForSelector:(SEL)aSelector{
    NSLog(@"dx--forwardingTargetForSelector=1111");
//    if (sel_isEqual(aSelector, @selector(undo))) {
    if (aSelector == @selector(undo)) {
        return nil; // [BaseObject new]; //将test消息转发给Cat对象
    }
    return [super forwardingTargetForSelector:aSelector];
}
/*
 在 Objective-C 中，当一个对象接收到它无法响应的消息时，Objective-C 的消息发送机制会启动消息转发（Message Forwarding）过程。forwardingTargetForSelector: 是这个过程中的第一步，它允许你指定另一个对象来“接管”这个消息。如果这个方法返回 nil 或 self，则会进入完整的消息转发流程，即调用 methodSignatureForSelector: 和 forwardInvocation:。
 你的代码中存在几个潜在的问题，可能导致运行时错误：
 选择器比较：在 Objective-C 中，选择器（SEL）是一种可以用来代表方法名的类型，但它们应该使用 sel_isEqual 函数进行比较，而不是直接使用 ==。尽管在实践中直接使用 == 往往也能工作，因为编译器通常会确保相同的选择器字符串映射到相同的 SEL 实例，但使用 sel_isEqual 是更安全、更标准的做法。
 方法签名：@selector(undo:) 指的是一个带有一个参数的 undo 方法。确保你想要转发的方法签名（即方法名和它的参数）与 @selector(undo:) 完全匹配。如果 BaseObject 中实现的方法不接受参数，那么应该是 @selector(undo) 而不是 @selector(undo:)。
 BaseObject 实现：确保 BaseObject 类确实实现了 undo: 方法。如果 BaseObject 没有实现这个方法，那么即使消息被转发到了 BaseObject 的实例，仍然会导致 unrecognized selector sent to instance 错误。
 修正后的代码示例：
 - (id)forwardingTargetForSelector:(SEL)aSelector {
     NSLog(@"dx--aSelector=%@", NSStringFromSelector(aSelector));
     if (sel_isEqual(aSelector, @selector(undo:))) {
         return [BaseObject new]; // 将消息转发给 BaseObject 对象
     }
     return [super forwardingTargetForSelector:aSelector];
 }
 确保 BaseObject 类中有相应的方法实现：
 @implementation BaseObject

 - (void)undo:(id)param {
     NSLog(@"BaseObject handling undo:");
 }

 @end
 这样，当 self 收到一个它无法响应的 undo: 消息时，这个消息会被转发给一个新创建的 BaseObject 实例。
 */

//返回方法签名   包括：返回值类型、参数类型
-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSLog(@"dx--methodSignatureForSelector=1111");
    if (aSelector == @selector(undo)) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:i"];
    }
    return [super methodSignatureForSelector:aSelector];
}

//anInvocation封装了一个方法调用  包括：方法调用者，方法名，方法参数
/*
 forwardingTargetForSelector：将消息转发给能处理消息的对象
 methodSignatureForSelector和forwardInvocation：第一个方法生成方法签名NSMethodSignature对象，然后创建anInvocation对象座位参数传给第二个方法，然后在第二个方法中可以尽情的处理,只要在第二个方法里面不执行父类的方法，即使不处理也不会崩溃.
 */
-(void)forwardInvocation:(NSInvocation *)anInvocation{

    //尽情处理一：也可以什么也不做 不调用父类这样程序也不会奔溃
    NSLog(@"forwardInvocation");
    
    //尽情处理二：把消息转发给别动对象 修改方法调用者
    if (anInvocation.selector == @selector(undo)) {
    //anInvocation 一开始的方法调用者是person对象  这里可以改变方法调用者为cat对象，再去执行方法   Cat类中要有实现test方法
    //写法1
//       anInvocation.target = [[BaseObject alloc] init];
//        [anInvocation invoke];
        //写法2
//       [anInvocation invokeWithTarget:[[BaseObject alloc] init]];
    } else {
        // 重要点
        [super forwardInvocation:anInvocation];
    }
    
    
    //尽情处理三：修改方法名，
    anInvocation.selector = @selector(other);
    [anInvocation invoke];

    
    //尽情处理四：修改参数
//    if (anInvocation.selector == @selector(test:)) {
//        int age;
//这里为啥是2 因为前面还有2个参数self和_cmd
//        [anInvocation getArgument:&age atIndex:2];
//        NSLog(@"%d",age);
//        NString *name = @"zht";
//        [anInvocation setArgument:&name atIndex:2];
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%s", __func__);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%s", __func__);
}

#pragma mark - privateDelegate
- (void)clickBtn:(UIButton *)sender{
    //View层按钮的点击事件回调~
    NSLog(@"代理按钮");
}

- (void)test {
//    [self testProperty];
    [self testCls];
    BaseObject *person = [[BaseObject alloc] init];
//    BaseObject *person = [[[BaseObject alloc] init] autorelease];
    NSLog(@"%s", __func__);
}
- (void)testProperty{
    BaseObject *obj = [BaseObject alloc];
    //    [obj release];
    //    BaseObject *anotherObj = obj; // anotherObj也指向obj，引用计数不变
    //    [anotherObj release]; // 释放anotherObj，引用计数减1，如果这是唯一的引用，对象被销毁
    
    // weak修饰baseobj1时，会警告 "Assigning retained object to weak property; object will be released after assignment
    // 原因是你将一个拥有所有权（retained object）的对象赋值给了一个声明为weak的属性。
    // 在赋值操作完成后，由于没有强引用（strong reference）保持这个对象，它将会被立即释放。
    /*
     在Objective-C中，weak属性用于防止循环引用，特别是在处理有父子关系或者代理关系的对象时。当一个对象只有weak引用时，一旦没有其他强引用指向它，这个对象就会被自动释放，并且weak引用会被自动设置为nil，以避免野指针错误。
     */
    self.baseobj1 = [[BaseObject alloc] init]; // weak
    self.baseobj2 = [BaseObject alloc];
//    [self.baseobj2 setAge:10];
    NSLog(@"000-obj:%@,obj1:%@,obj2:%@", obj, self.baseobj1, self.baseobj2);
    self.baseobj1 = obj;
    NSLog(@"1111-obj:%@,obj1:%@,obj2:%@", obj, self.baseobj1, self.baseobj2);
    // 强引用变量被重新赋值给另一个对象，原来引用的对象会收到一条release消息，因为这个强引用不再指向它了。
    self.baseobj2 = obj;
    NSLog(@"2222-obj:%@,obj1:%@,obj2:%@", obj, self.baseobj1, self.baseobj2);
    self.baseobj1 = nil;
    NSLog(@"3333-obj:%@,obj1:%@,obj2:%@", obj, self.baseobj1, self.baseobj2);
    self.baseobj2 = nil;
    NSLog(@"4444obj:%@,obj1:%@,obj2:%@", obj, self.baseobj1, self.baseobj2);
}

- (void)testCls {
    BaseObject *obj = [BaseObject alloc];
    // 使用 object_getClass 函数通过对象的 isa 指针获取对象的类
    Class cls = object_getClass(obj);
    // 获取类的名称
    const char *className = class_getName(cls);
    // 打印类的名称
    NSLog(@"该对象属于的类是: %s, %@", className, NSStringFromClass(cls));
    [self printPropertiesOfClass:cls];
    [self printMethodsOfClass:cls];
    [self callMethodWithClassName:cls AndMethodName:@"add"];
}

- (void)printPropertiesOfClass:(Class) cls {
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(cls, &count);
    for (unsigned int i = 0; i < count; i++) {
        const char *propertyName = property_getName(properties[i]);
        NSLog(@"Property: %s", propertyName);
    }
    free(properties);
}

//    cls->data()-> methods
- (void)printMethodsOfClass:(Class) cls {
    unsigned int count;
    Method *methods = class_copyMethodList(cls, &count);
    for (unsigned int i = 0; i < count; i++) {
        SEL methodSEL = method_getName(methods[i]);
        const char *methodName = sel_getName(methodSEL);
        NSLog(@"Method: %s", methodName);
        SEL sel = @selector(methodName:);
        // 发送消息
        BaseObject *obj = [BaseObject alloc];
        if ([obj respondsToSelector:sel]) {
         [obj performSelector:sel withObject:nil];
        }
        NSMethodSignature *signature = [obj methodSignatureForSelector:sel];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:obj];
        [invocation setSelector:sel];
        // 设置参数
        NSObject *argument = nil;
        [invocation setArgument:&argument atIndex:2]; // 注意：参数索引从2开始，0和1被target和selector占用
        [invocation invoke];
    }
    free(methods);
}

// 知道类名和方法名，可以使用 objc_msgSend 函数直接发送消息。
// 类型转换：由于 objc_msgSend 默认返回 id 类型，并且接受 id 类型的第一个参数（接收者）和 SEL 类型的第二个参数（方法选择器），你需要将其转换为合适的函数指针类型，以匹配方法的实际参数和返回类型。
// 调用方法：使用 NSClassFromString 来获取类对象，使用 NSSelectorFromString 来获取方法选择器，然后通过转换后的 objc_msgSend 调用方法。
// 类型安全：直接使用 objc_msgSend 可能会绕过编译器的类型检查，因此需要确保方法签名的正确性。
// ARC 环境下的注意事项：在启用 ARC 的环境下，直接调用 objc_msgSend 可能会遇到编译器报错。这是因为 ARC 需要知道如何正确管理方法返回值的内存。在这种情况下，你可能需要使用特定的变体，如 objc_msgSend_stret（用于结构体返回类型）、objc_msgSend_fpret（用于浮点数返回类型）等，或者通过桥接转换来规遍编译器。
// 使用 objc_msgSend 提供了强大的动态消息发送能力，但也需要谨慎使用，以避免类型不匹配等问题。
- (void)callMethodWithClassName:(Class)cls AndMethodName:(NSString *)methodName {
    // 获取类对象
//    Class cls = NSClassFromString(className);
    // 获取方法选择器
    SEL selector = NSSelectorFromString(methodName);
    // 检查类和方法是否存在
    if (cls && [cls instancesRespondToSelector:selector]) {
        // 创建类的实例
        id instance = [[cls alloc] init];
        // 将 objc_msgSend 转换为合适的函数指针类型
        void (*objc_msgSendTyped)(id, SEL) = (void *)objc_msgSend;
        // 调用方法
        objc_msgSendTyped(instance, selector);
    } else {
        NSLog(@"Class or method not found.");
    }
}


//- (void)setBaseobj:(BaseObject *)baseobj {
//    if (_baseobj != baseobj) {
//        [_baseobj release];
//        _baseobj = [baseobj retain];
//    }
//}
//
//- (BaseObject *)baseobj {
//    return _baseobj;
//}

- (void)testDic {
    BaseObject *obj = [[BaseObject alloc] init];
    obj.name = @"张三";
    obj.age = 28;
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"person.data"];
    [NSKeyedArchiver archiveRootObject:obj toFile:filePath];
    
    // 解档
    BaseObject *decodedPerson = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    NSLog(@"姓名: %@, 年龄: %ld", decodedPerson.name, (long)decodedPerson.age);
    
    //完成了`Person`对象的自动归档和自动解档操作。通过实现`NSCoding`协议，可以方便地将对象保存到文件中或从文件中恢复对象的状态
}


@end
