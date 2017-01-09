//
//  YBImageGalleryTopView.m
//  CollectionView
//
//  Created by Caad on 2017/1/6.
//  Copyright © 2017年 X. All rights reserved.
//

#import "YBImageGalleryTopView.h"



@interface YBImageGalleryTopView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) BOOL isTopViewHiden;
@end

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
    _isTopViewHiden = NO;
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(12, 24, 60, 40);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backBtn.titleLabel.textColor = [UIColor whiteColor];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 24, self.frame.size.width - 200, 40)];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
}

- (void)backBtnAction:(UIButton *)sender
{
    _returnBtnCallBack ? _returnBtnCallBack():nil;
}

- (void)setTopTitle:(NSString *)topTitle
{
    _titleLabel.text = topTitle;
}

- (void)hideTopViewAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = self.frame;
            frame.origin.y -= frame.size.height;
            self.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        CGRect frame = self.frame;
        frame.origin.y -= frame.size.height;
        self.frame = frame;
    }
}

- (void)showTopViewAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = self.frame;
            frame.origin.y = 0;
            self.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        CGRect frame = self.frame;
        frame.origin.y = 0;
        self.frame = frame;
    }
}


- (void)hideOrShowTopViewAnimated:(BOOL)animated
{
    if (_isTopViewHiden) {
        [self showTopViewAnimated:animated];
        _isTopViewHiden = !_isTopViewHiden;
    }
    else
    {
        [self hideTopViewAnimated:animated];
        _isTopViewHiden = !_isTopViewHiden;
    }
}


@end
