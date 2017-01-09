//
//  TestViewController.m
//  CollectionView
//
//  Created by Caad on 2017/1/6.
//  Copyright © 2017年 X. All rights reserved.
//

#import "TestViewController.h"
#import "YBImageGalleryView.h"


@interface TestViewController ()<YBImageGalleryViewDataSource>

@property (nonatomic, strong) NSArray *pictureArr;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 50, 60, 30);
    [button setTitle:@"预览" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}


- (void)btnAction:(UIButton *)sender
{
    [self abcd];
}

- (void)abcd
{
    YBImageGalleryView *view = [[YBImageGalleryView alloc] initWithFrame:self.view.bounds];
    view.dataSource = self;
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:view];
    
    
    _pictureArr = @[@"http://p1.bqimg.com/567571/b6f92749812259d0.jpg",
                    @"http://p1.bpimg.com/4851/b6f92749812259d0.jpg",
                    @"http://p1.bpimg.com/4851/b6f92749812259d0.jpg",
                    @"http://p1.bpimg.com/4851/5f834f86e10b7b33.jpg",
                    @"http://p1.bpimg.com/4851/a24348b318659984.jpg",
                    @"http://p1.bpimg.com/4851/7e38d493395e8216.jpg",
                    @"http://p1.bpimg.com/4851/5a292d93f7da8ff6.jpg"
                    ];

}

- (NSInteger)numberOfImageInGallery:(YBImageGalleryView *)gallery
{
    return _pictureArr.count;
}

//- (UIImage *)imageInGallery:(YBImageGalleryView *)gallery atIndex:(NSInteger)index
//{
//    return [UIImage imageNamed:[NSString stringWithFormat:@"%ld_full",index]];
//}

- (NSString *)imageUrlInGallery:(YBImageGalleryView *)gallery atIndex:(NSInteger)index
{
    return _pictureArr[index];
}
@end
