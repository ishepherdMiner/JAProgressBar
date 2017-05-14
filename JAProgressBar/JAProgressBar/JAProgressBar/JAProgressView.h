//
//  JAProgressView.h
//  RssMoney
//
//  Created by Jason on 10/05/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JAProgressBarLayer.h"
#import "JAProgressUIWebView.h"
#import "JAProgressWKWebView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JAProgressView : UIView

@property (nonatomic,strong,readonly) JAProgressBarLayer *progressBarlayer;


- (void)flush:(CGFloat)progress;
- (void)finish;
- (void)fail;

@end


UIKIT_EXTERN NSString *JAEstimatedProgressNotification;

NS_ASSUME_NONNULL_END
