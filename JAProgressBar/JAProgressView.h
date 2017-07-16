//
//  JAProgressView.h
//  RssMoney
//
//  Created by Jason on 10/05/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "JAProgressBarLayer.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JAProgressViewDelegate <NSObject>

- (void)flush:(CGFloat)progress;
- (void)finish;
- (void)fail;

@optional
- (void)simulation;


@end

@interface JAProgressView : UIView <JAProgressViewDelegate>

@property (nonatomic,strong,readonly) JAProgressBarLayer *progressBarlayer;

@end

UIKIT_EXTERN NSString *JAEstimatedProgressNotification;

@interface JAProgressUIWebView : UIWebView <JAProgressViewDelegate>

@property (nonatomic,assign,readonly) long long expectedContentLength;
@property (nonatomic,strong,readonly) JAProgressView *progressView;

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

@end

UIKIT_EXTERN NSString *kAFJAReceiveDataNotification;       /// 接收到数据
UIKIT_EXTERN NSString *kAFJAReceiveResponseNotification;   /// 数据接收完成

@interface JAProgressWKWebView : WKWebView <JAProgressViewDelegate>

@property (nonatomic,strong,readonly) JAProgressView *progressView;

@end

NS_ASSUME_NONNULL_END
