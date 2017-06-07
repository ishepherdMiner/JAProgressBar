//
//  JAProgressUIWebView.h
//  Summary
//
//  Created by Jason on 08/05/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "JAProgressBarLayer.h"

NS_ASSUME_NONNULL_BEGIN

@class JAProgressView;

@interface JAProgressUIWebView : UIWebView

@property (nonatomic,assign,readonly) long long expectedContentLength;
@property (nonatomic,strong,readonly) JAProgressView *progressView;
@property (nonatomic,strong,readonly) JAProgressBarLayer *progressBarlayer;

/**
 * 运行时替换该代理对象的 ``URLSession:dataTask:didReceiveData:`` 方法实现监听网络请求进度
 * AFN中有 
 *
 * \@interface AFURLSessionManager : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate, NSSecureCoding, NSCopying>
 * 只要拿到 manager 对象赋值即可
 *
 */
@property (nonatomic,strong) id<NSURLSessionDataDelegate> sessionDataDelegate;
@property (nonatomic,assign,getter=isLock) BOOL lock;

- (void)finish;
- (void)flush:(CGFloat)progress;
- (void)fail;

@end

UIKIT_EXTERN NSString *kAFJAReceiveDataNotification;       /// 接收到数据
UIKIT_EXTERN NSString *kAFJAReceiveResponseNotification;   /// 数据接收完成

NS_ASSUME_NONNULL_END
