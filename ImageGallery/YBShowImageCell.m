//
//  YBShowImageCollectionViewCell.m
//  CollectionView
//
//  Created by Caad on 2017/1/5.
//  Copyright © 2017年 X. All rights reserved.
//

#import "YBShowImageCell.h"
#import "UIImageView+WebCache.h"


@interface YBShowImageCell ()<UIScrollViewDelegate>
@property(nonatomic,assign) BOOL isScaled;
//@property (nonatomic,strong) UIScrollView *scrollView;
//@property (nonatomic,strong) UIImageView *imageView;
@end

@implementation YBShowImageCell

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
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    _scrollView.delegate = self;
    _scrollView.minimumZoomScale = 0.5;
    _scrollView.maximumZoomScale = 4.0;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_scrollView];
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height)];
    }
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.userInteractionEnabled = YES;
    [_scrollView addSubview:_imageView];
    
    [self addGestureFor:_imageView];
}

#pragma mark - UITapGestureRecognizer
- (void)addGestureFor:(UIView *)view
{
    // 单击手势
    UITapGestureRecognizer *singleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleGestureAction)];
    singleGesture.numberOfTapsRequired = 1;
    // 双击手势
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleGestureAction)];
    doubleTapGesture.numberOfTapsRequired = 2;
    
    // 双击手势响应失败之后再响应单击手势
    [singleGesture requireGestureRecognizerToFail:doubleTapGesture];
    [view addGestureRecognizer:singleGesture];
    [view addGestureRecognizer:doubleTapGesture];
}
// 单击手势事件
- (void)singleGestureAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapCell:atIndex:)]) {
        [self.delegate tapCell:self atIndex:self.index];
    }
}
// 双击手势事件
- (void)doubleGestureAction
{
    if (!self.isScaled)
    {
        [UIView animateWithDuration:0.4 animations:^{
            self.scrollView.zoomScale = 2.0;
        } completion:^(BOOL finished) {
            self.isScaled = YES;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.4 animations:^{
            self.scrollView.zoomScale = 1.0;
        } completion:^(BOOL finished) {
            self.isScaled = NO;
        }];
    }
}
#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
// 让UIImageView在UIScrollView缩放后居中显示
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,scrollView.contentSize.height * 0.5 + offsetY);
}

// 计算imageView的frame,让imageView的宽高比等于image的宽高比
- (void)adjustImageViewFrameWithImage:(UIImage *)image
{
    self.scrollView.zoomScale = 1.0;
    _imageView.frame = self.scrollView.frame;

    
    
    if (!image) {
        return;
    }
    // 图片宽高比大于imageView的宽高比
    CGRect adjustedImageViewFrame ;
    if ((image.size.width/image.size.height) > (_imageView.frame.size.width/_imageView.frame.size.height)) {
        CGFloat imageViewH = _imageView.frame.size.width *image.size.height/image.size.width;
        // 让imageView的垂直方向居中
        CGFloat y = (_imageView.frame.size.height - imageViewH) / 2;
        adjustedImageViewFrame = CGRectMake(0,y , _imageView.frame.size.width, imageViewH);
    }
    // 图片宽高比小于imageView的宽高比
    else
    {
        CGFloat imageViewW = _imageView.frame.size.height * image.size.width/image.size.height;
        // 让imageView 水平方向居中
        CGFloat x = (_imageView.frame.size.width - imageViewW) / 2;
        adjustedImageViewFrame = CGRectMake(x, 0, imageViewW, _imageView.frame.size.height);
    }
    self.imageView.frame = adjustedImageViewFrame;
}

// 设置图片
- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
    [self adjustImageViewFrameWithImage:image];
}
// 设置图片路径
- (void)setImageURL:(NSString *)imageURL
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image)
        {
            [self adjustImageViewFrameWithImage:image];
        }
    }];
}

// 回复到原来的缩放比例
- (void)scaleToOriginalRatio
{
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.zoomScale = 1.0;
    } completion:^(BOOL finished) {
        self.isScaled = NO;
    }];
}
// 缩放到设定的比例
- (void)toScale:(CGFloat)scale animated:(BOOL)animated
{
    if (animated)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.zoomScale = scale;
        } completion:^(BOOL finished) {
        }];
    }
    else
    {
        self.scrollView.zoomScale = scale;
    }
}

- (void)layoutSubviews
{
    _scrollView.frame = self.bounds;
    [self adjustImageViewFrameWithImage:self.imageView.image];
}

@end
