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

UIKIT_EXTERN CGFloat const kNavBarHeight;
UIKIT_EXTERN CGFloat const kProgressBarHeight;

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

NS_ASSUME_NONNULL_END
