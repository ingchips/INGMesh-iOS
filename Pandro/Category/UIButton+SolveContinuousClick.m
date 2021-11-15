//
//  UIButton+BK.m
//  SKYDispark
//
//  Created by mac on 2018/9/7.
//  Copyright © 2018年 wzq. All rights reserved.
//


/**
 UIButton+SolveContinuousClick.m
 */
#import "UIButton+SolveContinuousClick.h"
#import <objc/runtime.h>

@interface UIButton ()
@property (nonatomic, assign) NSTimeInterval scc_custom_acceptEventTime; // 接收到点击事件的时间
@end

@implementation UIButton (SolveContinuousClick)

+ (void)load{
    Method systemMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    SEL sysSEL = @selector(sendAction:to:forEvent:);
    Method scc_customMethod = class_getInstanceMethod(self, @selector(scc_custom_sendAction:to:forEvent:));
    SEL scc_customSEL = @selector(scc_custom_sendAction:to:forEvent:);
    // 添加方法 语法: BOOL class_addMethod(Class cls, SEL name, IMP imp, const char *types)
    // 若返回YES，说明系统中方法实现不存在，则使用class_replaceMethod函数替换方法的实现；
    // 若返回NO，说明系统中此方法实现已存在，则使用method_exchangeImplementations函数交换方法的实现即可。
    // cls: 被添加方法的类  name: 被添加方法方法名  imp: 被添加方法的实现函数  types: 被添加方法的实现函数的返回值类型和参数类型的字符串
    BOOL didAddMethod = class_addMethod(self, sysSEL, method_getImplementation(scc_customMethod), method_getTypeEncoding(scc_customMethod));
    // 如果系统中该方法已经存在,则替换系统的方法
    // 替换方法 语法: IMP class_replaceMethod(Class cls, SEL name, IMP imp, const char *types)
    if (didAddMethod) {
        class_replaceMethod(self, scc_customSEL, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
    }else{
        method_exchangeImplementations(systemMethod, scc_customMethod);
    }
}

// scc_custom_acceptEventInterval的 Get 方法
- (NSTimeInterval )scc_custom_acceptEventInterval{
    return [objc_getAssociatedObject(self, "UIControl_acceptEventInterval") doubleValue];
}

// scc_custom_acceptEventInterval的 Set 方法
- (void)setScc_custom_acceptEventInterval:(NSTimeInterval)scc_custom_acceptEventInterval{
    objc_setAssociatedObject(self, "UIControl_acceptEventInterval", @(scc_custom_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// scc_custom_acceptEventTime的 Get 方法
- (NSTimeInterval )scc_custom_acceptEventTime{
    return [objc_getAssociatedObject(self, "UIControl_acceptEventTime") doubleValue];
}

// scc_custom_acceptEventTime的 Set 方法
- (void)setScc_custom_acceptEventTime:(NSTimeInterval)scc_custom_acceptEventTime{
    objc_setAssociatedObject(self, "UIControl_acceptEventTime", @(scc_custom_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)scc_custom_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    // 如果想要设置统一的间隔时间，可以在此处加上以下几句
    // 注意，网上有使用 UIControl 分类的，如果使用 UIControl 分类，并且在这里统一设置时间间隔，会影响到其他继承自 UIControl 类的控件，要想统一设置又不想影响其他继承自 UIControl 的控件，建议使用UIButton分类，实现方法都是一样的。
    //if (self.scc_custom_acceptEventInterval <= 0) {
    //   self.scc_custom_acceptEventInterval = 2.0; // 如果没有自定义时间间隔，则默认为2秒
    //}
    // 是否大于设定的时间间隔(一个按钮在第一次接收到点击事件时，scc_custom_acceptEventTime默认初始化值是0)
    BOOL needSendAction = (NSDate.date.timeIntervalSince1970 - self.scc_custom_acceptEventTime >= self.scc_custom_acceptEventInterval);
    // 更新上一次点击时间戳，供与下一次接收点击事件的时间比较使用
    if (self.scc_custom_acceptEventInterval > 0) {
        self.scc_custom_acceptEventTime = NSDate.date.timeIntervalSince1970;
    }
    // 两次点击的时间间隔小于设定的时间间隔时，才执行响应事件
    if (needSendAction) {
        [self scc_custom_sendAction:action to:target forEvent:event];
    }
}

@end
