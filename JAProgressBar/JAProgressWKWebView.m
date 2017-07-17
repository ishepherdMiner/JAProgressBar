//
//  JAProgressWKWebView.m
//  Summary
//
//  Created by Jason on 08/05/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "JAProgressWKWebView.h"

@interface JAProgressWKWebView ()

@property (nonatomic,strong) JAProgressView *progressView;

@end
@implementation JAProgressWKWebView

- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration {
    
    CGRect fixedFrame = CGRectEqualToRect(CGRectZero, frame) ? CGRectMake(0, kNavBarHeight - kProgressBarHeight, [UIScreen mainScreen].bounds.size.width, kProgressBarHeight) : frame;
    if (self = [super initWithFrame:fixedFrame configuration:configuration]) {
        [self setup];
        [self addObserver:self forKeyPath:JAkEstimatedProgress options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    double newKey = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
    [self.progressView.progressBarlayer flush:newKey];
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

- (void)dealloc {
    @try {
        [self removeObserver:self forKeyPath:JAkEstimatedProgress];
    } @catch (NSException *exception) {
        // NSLog(@"%@",exception);
    }
}
@end
