//
//  JAProgressWKWebView.h
//  Summary
//
//  Created by Jason on 08/05/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "JAProgressBarLayer.h"

NS_ASSUME_NONNULL_BEGIN

@class JAProgressView;
@protocol JAProgressViewDelegate;

@interface JAProgressWKWebView : WKWebView <JAProgressViewDelegate>

@property (nonatomic,strong,readonly) JAProgressView *progressView;
@property (nonatomic,strong,readonly) JAProgressBarLayer *progressBarlayer;

- (void)finish;
- (void)flush:(CGFloat)progress;
- (void)fail;

@end

NS_ASSUME_NONNULL_END
