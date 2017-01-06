//
//  YBImageGalleryTopView.m
//  CollectionView
//
//  Created by Caad on 2017/1/6.
//  Copyright © 2017年 X. All rights reserved.
//

#import "YBImageGalleryTopView.h"

@implementation YBImageGalleryTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(12, 24, 60, 40);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backBtn.titleLabel.textColor = [UIColor whiteColor];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 24, self.frame.size.width - 200, 40)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:titleLabel];
}

- (void)backBtnAction:(UIButton *)sender
{
    
}

@end
