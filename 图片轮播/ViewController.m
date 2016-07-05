//
//  ViewController.m
//  图片轮播
//
//  Created by chenjun on 16/7/5.
//  Copyright © 2016年 cloudssky. All rights reserved.
//

#import "ViewController.h"
#import "CJCarouselView.h"

#define width 300
#define height 200

@interface ViewController () <imgeClickDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CJCarouselView *v = [[CJCarouselView alloc] init];
    v.frame = CGRectMake(10, 100, 300, 200);
    NSMutableArray *muArr = [NSMutableArray array];
    for (int i = 1; i < 6; i++) {
        [muArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"00%d.jpg", i]]];
    }
    v.dataSourceArray = [NSArray arrayWithArray:muArr];
    v.currentPageColor = [UIColor redColor];
    v.otherPageColor = [UIColor greenColor];
    v.delegate = self;
    [self.view addSubview:v];
    v.backgroundColor = [UIColor darkTextColor];
}

- (void)clickImage:(int)index {
    NSLog(@"选中%d图", index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
