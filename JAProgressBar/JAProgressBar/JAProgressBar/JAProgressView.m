//
//  JAProgressView.m
//  RssMoney
//
//  Created by Jason on 10/05/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "JAProgressView.h"

NSString *JAEstimatedProgressNotification = @"estimatedProgressNotification";

@interface JAProgressView ()

@property (nonatomic,strong) JAProgressBarLayer *progressBarlayer;

@end

@implementation JAProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    CGRect fixedFrame = CGRectMake(0, 41, [UIScreen mainScreen].bounds.size.width, 3);
    if (self = [super initWithFrame:fixedFrame]) {
        
        [self setup];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveWithNotification:) name:JAEstimatedProgressNotification object:nil];
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
    [self.progressBarlayer finish];
}

@end


