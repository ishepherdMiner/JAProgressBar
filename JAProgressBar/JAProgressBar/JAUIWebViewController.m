//
//  JAUIWebViewController.m
//  JAProgressBar
//
//  Created by Jason on 12/05/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "JAUIWebViewController.h"
#import "JAProgressView.h"
#import <UIKit+AFNetworking.h>

@interface JAUIWebViewController () <UIWebViewDelegate>

@property (nonatomic,strong) JAProgressUIWebView *webView;

@end

@implementation JAUIWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1.0];
    _webView = [[JAProgressUIWebView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
    _webView.scalesPageToFit = true;
    _webView.delegate = self;
    
    [self.view addSubview:_webView];
    [self.navigationController.navigationBar addSubview:_webView.progressView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSURL *nsurl=[NSURL URLWithString:self.urlString];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    NSProgress *progress = [[NSProgress alloc] init];
    [_webView loadRequest:nsrequest progress:&progress success:^NSString * _Nonnull(NSHTTPURLResponse * _Nonnull response, NSString * _Nonnull HTML) {
        return @"";
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"加载完成");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_webView fail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
