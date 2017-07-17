//
//  JAProgressUIWebView.m
//  Summary
//
//  Created by Jason on 08/05/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "JAProgressUIWebView.h"
#import <objc/message.h>

NSString *kAFJAReceiveDataNotification =  @"kAFNReceiveDataNotification";
NSString *kAFJAReceiveResponseNotification = @"kAFJAReceiveResponseNotification";

@interface JAProgressUIWebView ()

@property (nonatomic,assign) long long expectedContentLength;
@property (nonatomic,strong) JAProgressView *progressView;

@property (nonatomic,strong) NSArray *records;
@property (nonatomic,assign) CGFloat estimatedProgress;

@end

@implementation JAProgressUIWebView

- (instancetype)initWithFrame:(CGRect)frame {
    CGRect fixedFrame = CGRectEqualToRect(CGRectZero, frame) ? CGRectMake(0, kNavBarHeight - kProgressBarHeight, [UIScreen mainScreen].bounds.size.width, kProgressBarHeight) : frame;
    
    if (self = [super initWithFrame:fixedFrame]) {
        [self setup];
        [self addObserver];
    }
    return self;
}

- (void)setup {
    self.progressView = [[JAProgressView alloc] init];
    [self.layer addSublayer:self.progressView.progressBarlayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.progressView.superview) {
        [self.progressView.layer addSublayer:self.progressView.progressBarlayer];
    }
}

// ------------------------------- Begin ----------------------------------------------------
/*
 分类的实现方式
 AFHTTPSessionManager+JACoder.h
 
 NS_ASSUME_NONNULL_BEGIN
 
 @interface AFHTTPSessionManager (JACoder)
 
 @property (nonatomic,assign,getter=isLock) BOOL lock;
 
 @end
 
 NS_ASSUME_NONNULL_END
 */

/*
 AFHTTPSessionManager+JACoder.m
 
 @implementation AFHTTPSessionManager (JACoder)
 
 + (void)load {
 Method originalMethod = class_getInstanceMethod(self, @selector(URLSession:dataTask:didReceiveData:));
 Method swizzledMethod = class_getInstanceMethod(self, @selector(ja_URLSession:dataTask:didReceiveData:));
 BOOL didAddMethod =
 class_addMethod(self,
 @selector(URLSession:dataTask:didReceiveData:),
 method_getImplementation(swizzledMethod),
 method_getTypeEncoding(swizzledMethod));
 
 if (didAddMethod) {
 class_replaceMethod(self,
 @selector(ja_URLSession:dataTask:didReceiveData:),
 method_getImplementation(originalMethod),
 method_getTypeEncoding(originalMethod));
 } else {
 method_exchangeImplementations(originalMethod, swizzledMethod);
 }
 }
 
 - (void)ja_URLSession:(NSURLSession *)session
 dataTask:(NSURLSessionDataTask *)dataTask
 didReceiveData:(NSData *)data {
 
 [self ja_URLSession:session dataTask:dataTask didReceiveData:data];
 
 // ...
 if (dataTask.response.expectedContentLength != -1 && self.isLock == false) {
 //        NSLog(@"data = %ld",data.length);
 //        NSLog(@"dataTask = %lld",dataTask.response.expectedContentLength);
 [[NSNotificationCenter defaultCenter] postNotificationName:kAFJAReceiveDataNotification object:data];
 [[NSNotificationCenter defaultCenter] postNotificationName:kAFJAReceiveResponseNotification object:dataTask];
 
 self.lock = true;
 
 }else {
 
 // NSLog(@"data = %ld",data.length);
 [[NSNotificationCenter defaultCenter] postNotificationName:kAFJAReceiveDataNotification object:data];
 }
 }
 
 - (BOOL)isLock {
 return (BOOL)[objc_getAssociatedObject(self, @selector(isLock)) doubleValue];
 }
 
 - (void)setLock:(BOOL)lock {
 objc_setAssociatedObject(self, @selector(setLock:), @(lock), OBJC_ASSOCIATION_ASSIGN);
 }
 
 @end
 
 */
- (void)setSessionDataDelegate:(id<NSURLSessionDataDelegate>)sessionDataDelegate {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sessionDataDelegate) {
            _sessionDataDelegate = sessionDataDelegate;
            id delegate = (id)sessionDataDelegate;
            Method originalMethod = class_getInstanceMethod([delegate class], @selector(URLSession:dataTask:didReceiveData:));
            Method swizzledMethod = class_getInstanceMethod([self class], @selector(ja_URLSession:dataTask:didReceiveData:));
            
            // Keep attention
            // 替换 id<NSURLSessionDataDelegate> 对象的类中的 ``URLSession:dataTask:didReceiveData:`` 方法的实现
            // 整段代码相当于给 id<NSURLSessionDataDelegate> 对象的类添加一个新方法 ``ja_URLSession:dataTask:didReceiveData:，
            // 然后用新添加的方法与原方法的实现进行交换操作
            // 一般在 +load 中实现 swizzing 方法交换，但是不想使用分类 AFHTTPSessionManager+JACoder
            // 因为有分类时，托管给 cocoaPods 编译成 lib 时，即使选择了依赖 AFN 还是会遇到类似命名空间的问题。
            // 水平有限，目前想不出其他方式，暂时不确定会有什么影响
            BOOL didAddMethod =
            class_addMethod([delegate class],
                            @selector(URLSession:dataTask:didReceiveData:),
                            method_getImplementation(swizzledMethod),
                            method_getTypeEncoding(swizzledMethod));
            
            Method setLockMethod = class_getInstanceMethod([self class], @selector(setLock:));
            class_addMethod([delegate class], @selector(setLock:), method_getImplementation(setLockMethod),method_getTypeEncoding(setLockMethod));
            
            Method isLockMethod = class_getInstanceMethod([self class], @selector(isLock));
            class_addMethod([delegate class], @selector(isLock), method_getImplementation(isLockMethod), method_getTypeEncoding(isLockMethod));
            
            if (didAddMethod) {
                class_replaceMethod([delegate class],
                                    @selector(ja_URLSession:dataTask:didReceiveData:),
                                    method_getImplementation(originalMethod),
                                    method_getTypeEncoding(originalMethod));
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }
    });
}

- (void)ja_URLSession:(__unused NSURLSession *)session
             dataTask:(__unused NSURLSessionDataTask *)dataTask
       didReceiveData:(NSData *)data  {
    
    // 这里的 self 是 id<NSURLSessionDataDelegate> 对象
    [self ja_URLSession:session dataTask:dataTask didReceiveData:data];
    
    if (dataTask.response.expectedContentLength != -1 && self.isLock == false) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kAFJAReceiveDataNotification object:data];
        [[NSNotificationCenter defaultCenter] postNotificationName:kAFJAReceiveResponseNotification object:dataTask];
        
        self.lock = true;
        
    }else {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kAFJAReceiveDataNotification object:data];
    }
}

- (BOOL)isLock {
    return (BOOL)[objc_getAssociatedObject(self, @selector(setLock:)) doubleValue];
}

- (void)setLock:(BOOL)lock {
    objc_setAssociatedObject(self, @selector(setLock:), @(lock), OBJC_ASSOCIATION_ASSIGN);
}

// ------------------------------- End ----------------------------------------------------

- (void)receiveWithNotification:(NSNotification *)noti {
    if ([noti.object isKindOfClass:[NSURLSessionDataTask class]]) {
        NSURLSessionDataTask *dataTask = (NSURLSessionDataTask *)noti.object;
        self.expectedContentLength = dataTask.response.expectedContentLength;
        
        if (self.estimatedProgress == 0 ) {
            if (self.records.count == 0) {
                self.estimatedProgress = 1.0;
            }else {
                for (NSData *record in self.records) {
                    self.estimatedProgress += (CGFloat)record.length / self.expectedContentLength;
                }
                self.records = [NSArray array];
            }
        }else {
            for (NSData *record in self.records) {
                self.estimatedProgress += (CGFloat)record.length / self.expectedContentLength;
            }
        }
        // NSLog(@"noti dataTask:%f",self.estimatedProgress);
    }
    
    if ([noti.object isKindOfClass:[NSData class]]) {
        NSData *data = (NSData *)noti.object;
        if (self.expectedContentLength != -1 && self.expectedContentLength != 0) {
            for (NSData *record in self.records) {
                self.estimatedProgress += (CGFloat)record.length / self.expectedContentLength;
            }
            self.estimatedProgress += (CGFloat)data.length / self.expectedContentLength;
            // NSLog(@"noti data:%f",self.estimatedProgress);
            self.records = [NSArray array];
        }else {
            NSMutableArray *recordsM = [NSMutableArray arrayWithArray:self.records];
            [recordsM addObject:data];
            self.records = [recordsM copy];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    dispatch_async(dispatch_get_main_queue(), ^{
        double newKey = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        [self.progressView.progressBarlayer flush:newKey];
        if (1 - newKey < 0.01) {
            [self finish];
        }
    });
}

- (void)flush:(CGFloat)progress {
    [self.progressView flush:progress];
}

- (void)finish {
    [self.progressView flush:1];
}

- (void)fail {
    [self.progressView flush:0];
}

- (NSArray *)records {
    if (_records == nil) {
        _records = [NSArray array];
    }
    
    return _records;
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveWithNotification:) name:kAFJAReceiveDataNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveWithNotification:) name:kAFJAReceiveResponseNotification object:nil];
    [self addObserver:self forKeyPath:JAkEstimatedProgress options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)dealloc {
    
    // http://stackoverflow.com/questions/1582383/how-can-i-tell-if-an-object-has-a-key-value-observer-attached
    @try {
        [self removeObserver:self forKeyPath:JAkEstimatedProgress];
    } @catch (NSException *exception) {
        // NSLog(@"%@",exception);
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

