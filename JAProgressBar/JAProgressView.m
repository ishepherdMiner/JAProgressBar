//
//  JAProgressView.m
//  RssMoney
//
//  Created by Jason on 10/05/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "JAProgressView.h"
#import <objc/message.h>

NSString *JAEstimatedProgressNotification = @"estimatedProgressNotification";

CGFloat const kNavBarHeight = 44;
CGFloat const kProgressBarHeight = 3.0;

@interface JAProgressView ()

@property (nonatomic,strong) JAProgressBarLayer *progressBarlayer;

@end

@implementation JAProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    CGRect fixedFrame = CGRectEqualToRect(CGRectZero, frame) ? CGRectMake(0, kNavBarHeight - kProgressBarHeight, [UIScreen mainScreen].bounds.size.width, kProgressBarHeight) : frame;
    
    if (self = [super initWithFrame:fixedFrame]) {
        [self setup];
        [self addObserver];
    }
    return self;
}

- (void)setup{    
    self.progressBarlayer = [[JAProgressBarLayer alloc] init];
    [self.layer addSublayer:self.progressBarlayer];
}

- (void)receiveWithNotification:(NSNotification *)notifcation {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([notifcation.object isKindOfClass:[NSProgress class]]) {
            NSProgress *progress = (NSProgress *)notifcation.object;
            [self.progressBarlayer flush:progress.fractionCompleted];
        }
    });
}

- (void)flush:(CGFloat)progress {
    [self.progressBarlayer flush:progress];
}

- (void)finish {
    [self.progressBarlayer flush:1];
}

- (void)fail {
    [self.progressBarlayer flush:0];
}

- (void)simulation {
    [self.progressBarlayer flush:0.25];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.progressBarlayer flush:0.75];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.progressBarlayer flush:0.90];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.progressBarlayer flush:1.0];
        });
    });
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveWithNotification:) name:JAEstimatedProgressNotification object:nil];
}

@end
