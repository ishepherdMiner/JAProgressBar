//
//  ViewController.m
//  JAProgressBar
//
//  Created by Jason on 12/05/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "ViewController.h"
#import "JAUIViewController.h"
#import "JAWKViewController.h"
#import "JAUIWebViewController.h"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *datas;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datas = @[@"UIWebView",@"WKWebView",@"UIView"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JAProgressBarCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JAProgressBarCell"];
    }
    cell.textLabel.text = self.datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            JAUIWebViewController *vc = [[JAUIWebViewController alloc] init];
            vc.urlString = @"https://www.bing.com";
            [self.navigationController pushViewController:vc animated:true];
        }
            break;
        case 1:{
            JAWKViewController *vc = [[JAWKViewController alloc] init];
            vc.urlString = @"https://www.bing.com";
            [self.navigationController pushViewController:vc animated:true];
        }
            break;
        case 2:
        {
            JAUIViewController *vc = [[JAUIViewController alloc] init];
            [self.navigationController pushViewController:vc animated:true];
        }
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
