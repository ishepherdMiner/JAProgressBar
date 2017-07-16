//
//  JAProgressBarLayer.h
//  Daily_ui_objc_set
//
//  Created by Jason on 11/05/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *JAkEstimatedProgress;

@interface JAProgressBarLayer : CAShapeLayer

- (void)flush:(CGFloat)progress;

@end

NS_ASSUME_NONNULL_END
