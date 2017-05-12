//
//  JAProgressUIWebView.m
//  Summary
//
//  Created by Jason on 08/05/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "JAProgressUIWebView.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "AFHTTPSessionManager+JACoder.h"
#import "JAProgressView.h"

@interface JAProgressUIWebView ()

@property (nonatomic,assign) long long expectedContentLength;
@property (nonatomic,strong) JAProgressView *progressView;
@property (nonatomic,strong) JAProgressBarLayer *progressBarlayer;

@property (nonatomic,strong) NSArray *records;
@property (nonatomic,assign) CGFloat estimatedProgress;
@end

@implementation JAProgressUIWebView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
        [self addObserver];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.progressView.superview) {
        [self.progressView.layer addSublayer:self.progressBarlayer];
    }
}

- (void)receiveWithNotification:(NSNotification *)noti {
    if ([noti.object isKindOfClass:[NSURLSessionDataTask class]]) {
        NSURLSessionDataTask *dataTask = (NSURLSessionDataTask *)noti.object;
        self.expectedContentLength = dataTask.response.expectedContentLength;
        
        if (self.estimatedProgress == 0 ) {
            if (self.records.count == 0) {
                self.estimatedProgress = 1.0;
            }else {
                for (NSData *record in self.records) {
                    self.estimatedProgress += (CGFloat)record.length / self.expectedContentLength;
                }
                self.records = [NSArray array];
            }
        }else {
            for (NSData *record in self.records) {
                self.estimatedProgress += (CGFloat)record.length / self.expectedContentLength;
            }
        }
        // NSLog(@"noti dataTask:%f",self.estimatedProgress);
    }
    
    if ([noti.object isKindOfClass:[NSData class]]) {
        NSData *data = (NSData *)noti.object;
        if (self.expectedContentLength != -1 && self.expectedContentLength != 0) {
            for (NSData *record in self.records) {
                self.estimatedProgress += (CGFloat)record.length / self.expectedContentLength;
            }
            self.estimatedProgress += (CGFloat)data.length / self.expectedContentLength;
            // NSLog(@"noti data:%f",self.estimatedProgress);
            self.records = [NSArray array];
        }else {
            NSMutableArray *recordsM = [NSMutableArray arrayWithArray:self.records];
            [recordsM addObject:data];
            self.records = [recordsM copy];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    dispatch_async(dispatch_get_main_queue(), ^{
        double newKey = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];        
        [self.progressBarlayer flush:newKey];
        if (1 - newKey < 0.01) {
            [self finish];
        }
    });
}

- (void)flush:(CGFloat)progress {
    [self.progressBarlayer flush:progress];
}

- (void)setup {
    self.progressView = [[JAProgressView alloc] init];
    self.progressBarlayer = self.progressView.progressBarlayer;;
    [self.layer addSublayer:self.progressBarlayer];
}

- (void)finish {
    [self.progressBarlayer finish];
}

- (NSArray *)records {
    if (_records == nil) {
        _records = [NSArray array];
    }
    
    return _records;
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveWithNotification:) name:kAFJAReceiveDataNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveWithNotification:) name:kAFJAReceiveResponseNotification object:nil];
    [self addObserver:self forKeyPath:JAkEstimatedProgress options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)dealloc {
    
    // http://stackoverflow.com/questions/1582383/how-can-i-tell-if-an-object-has-a-key-value-observer-attached
    @try {
       [self removeObserver:self forKeyPath:JAkEstimatedProgress];
    } @catch (NSException *exception) {
        // NSLog(@"%@",exception);
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
