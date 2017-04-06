//
//  YBImageGalleryTopView.m
//  CollectionView
//
//  Created by Caad on 2017/1/6.
//  Copyright © 2017年 X. All rights reserved.
//

#import "YBImageGalleryTopView.h"
#import "UIColor+GalleryColor.h"


@interface YBImageGalleryTopView ()
@property (nonatomic, strong) UIButton *returnBackBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *separatorLine;
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
    self.backgroundColor = [UIColor topViewBackgroundColor];
    _isTopViewHiden = NO;
    _returnBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _returnBackBtn.frame = CGRectMake(12, 24, 60, 40);
    [_returnBackBtn setTitle:@"返回" forState:UIControlStateNormal];
    [_returnBackBtn setTitleColor:[UIColor topViewReturnBackButtonTitleColor] forState:UIControlStateNormal];
    [_returnBackBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_returnBackBtn];
    
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMakeWithCenter(self.center, CGSizeMake(50, 30))];
    _titleLabel.textColor = [UIColor topViewTitleColor];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    
    _separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
    _separatorLine.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:_separatorLine];
    
    
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
        [UIView animateWithDuration:0.1 animations:^{
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

CGRect CGRectMakeWithCenter(CGPoint center,CGSize size)
{
    CGFloat x = center.x - size.width/2;
    CGFloat y = center.y - size.height/2;
    return CGRectMake(x, y, size.width, size.height);
}

- (void)showTopViewAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.1 animations:^{
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

- (void)layoutSubviews
{
    _returnBackBtn.frame = CGRectMake(12, 24, 60, 40);
    _titleLabel.frame = CGRectMakeWithCenter(self.center, CGSizeMake(50, 30));
    _separatorLine.frame =  CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5);
}



@end
