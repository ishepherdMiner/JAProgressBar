//
//  JAUIViewController.m
//  JAProgressBar
//
//  Created by Jason on 12/05/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "JAUIViewController.h"
#import "AFNetworking.h"
#import <JAProgressBar.h>

@interface JAUIViewController ()

@property (nonatomic,strong) JAProgressView *progressView;

@end

@implementation JAUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1.0];
    _progressView = [[JAProgressView alloc] init];
    [self.navigationController.navigationBar addSubview:_progressView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[AFHTTPSessionManager manager] GET:@"http://api.map.baidu.com/telematics/v3/weather?location=%E5%98%89%E5%85%B4&output=json&ak=5slgyqGDENN7Sy7pw29IUvrZ" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_progressView flush:downloadProgress.fractionCompleted];
        });
        
        // or
        // [[NSNotificationCenter defaultCenter] postNotificationName:JAEstimatedProgressNotification object:downloadProgress];

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
