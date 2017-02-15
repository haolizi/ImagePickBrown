//
//  ViewController.m
//  ImageBrown
//
//  Created by chuang Hao on 2017/2/14.
//  Copyright © 2017年 Mr.Hao. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *addNetImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addNetImageBtn.frame = CGRectMake((SCREEN_WIDTH - 180)/2, 200, 180, 30);
    [addNetImageBtn setTitle:@"添加两张网络图片" forState:UIControlStateNormal];
    [addNetImageBtn setBackgroundColor:[UIColor redColor]];
    [addNetImageBtn addTarget:self action:@selector(addNetImageBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addNetImageBtn];
    
    UIButton *noNetImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    noNetImageBtn.frame = CGRectMake((SCREEN_WIDTH - 180)/2, 300, 180, 30);
    [noNetImageBtn setTitle:@"不添加网络图片" forState:UIControlStateNormal];
    [noNetImageBtn setBackgroundColor:[UIColor redColor]];
    [noNetImageBtn addTarget:self action:@selector(noNetImageBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:noNetImageBtn];
}

- (void)addNetImageBtnAction {
    NSArray *imageUrlArray = @[@"http://f.hiphotos.baidu.com/image/pic/item/a8014c086e061d9507500dd67ff40ad163d9cacd.jpg",
                               @"http://h.hiphotos.baidu.com/image/pic/item/203fb80e7bec54e7f14e9ce2bf389b504ec26aa8.jpg"];
    SecondViewController *secondVC = [[SecondViewController alloc] init];
    secondVC.netImageUrlArray = [imageUrlArray mutableCopy];
    [self.navigationController pushViewController:secondVC animated:YES];
}

- (void)noNetImageBtnAction {
    SecondViewController *secondVC = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:secondVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
