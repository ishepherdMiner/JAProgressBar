//
//  JAWKViewController.m
//  JAProgressBar
//
//  Created by Jason on 12/05/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "JAWKViewController.h"
#import "JAProgressView.h"

@interface JAWKViewController () <WKNavigationDelegate>

@property (nonatomic,strong) JAProgressWKWebView *webView;

@end

@implementation JAWKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1.0];
    self.automaticallyAdjustsScrollViewInsets = false;
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    JAProgressWKWebView *webView = [[JAProgressWKWebView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) configuration:theConfiguration];
    webView.tintColor = [UIColor groupTableViewBackgroundColor];
    webView.navigationDelegate = self;
    [self.view addSubview:_webView = webView];
    [self.navigationController.navigationBar addSubview:webView.progressView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSURL *nsurl=[NSURL URLWithString:self.urlString];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [_webView loadRequest:nsrequest];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    [_webView finish];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
