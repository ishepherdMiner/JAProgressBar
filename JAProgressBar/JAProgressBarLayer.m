//
//  JAProgressBarLayer.m
//  Daily_ui_objc_set
//
//  Created by Jason on 11/05/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "JAProgressBarLayer.h"

NSString *JAkEstimatedProgress = @"estimatedProgress";

@implementation JAProgressBarLayer

- (instancetype)init {
    if (self = [super init]) {
        self.lineWidth = 3;
        self.strokeColor = [UIColor greenColor].CGColor;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, self.lineWidth)];
        [path addLineToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width, self.lineWidth)];
        
        self.path = path.CGPath;
        self.strokeEnd = 0;
    }
    return self;
}

- (void)flush:(CGFloat)progress {
    if (progress < 1 && progress > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.strokeEnd = progress;
        });
    }else {
        self.strokeEnd = progress;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{            
            if (progress == 1) {
                self.hidden = true;
                [self removeFromSuperlayer];
            }
        });
    }
}

@end
