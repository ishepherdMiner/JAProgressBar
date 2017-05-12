//
//  JAProgressWKWebView.m
//  Summary
//
//  Created by Jason on 08/05/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "JAProgressWKWebView.h"
#import "JAProgressView.h"

@interface JAProgressWKWebView ()

@property (nonatomic,strong) JAProgressView *progressView;
@property (nonatomic,strong) JAProgressBarLayer *progressBarlayer;

@end
@implementation JAProgressWKWebView

- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration {
    if (self = [super initWithFrame:frame configuration:configuration]) {
        [self setup];
        [self addObserver:self forKeyPath:JAkEstimatedProgress options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)setup {
    self.progressView = [[JAProgressView alloc] init];
    self.progressBarlayer = self.progressView.progressBarlayer;
    [self.layer addSublayer:self.progressBarlayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.progressView.superview) {
        [self.progressView.layer addSublayer:self.progressBarlayer];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    double newKey = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
    [self.progressBarlayer flush:newKey];
}

- (void)flush:(CGFloat)progress {
    [self.progressBarlayer flush:progress];
}

- (void)finish {
    [self.progressBarlayer finish];
}

- (void)dealloc {
    @try {
        [self removeObserver:self forKeyPath:JAkEstimatedProgress];
    } @catch (NSException *exception) {
        // NSLog(@"%@",exception);
    }
}
@end
