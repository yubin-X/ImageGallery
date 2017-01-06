//
//  YBShowImageCollectionViewCell.m
//  CollectionView
//
//  Created by Caad on 2017/1/5.
//  Copyright © 2017年 X. All rights reserved.
//

#import "YBShowImageCollectionViewCell.h"
#import "UIImageView+WebCache.h"


@interface YBShowImageCollectionViewCell ()<UIScrollViewDelegate>
@property(nonatomic,assign) BOOL isScaled;
@end

@implementation YBShowImageCollectionViewCell

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
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.delegate = self;
    _scrollView.minimumZoomScale = 0.5;
    _scrollView.maximumZoomScale = 4.0;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_scrollView];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.userInteractionEnabled = YES;
    _imageView.backgroundColor = [UIColor clearColor];
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
    NSLog(@"你点我了");
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
- (void)caculateImageViewFrameWithImage:(UIImage *)image
{
    //  根据图片的宽度与容器的宽度来计算imageView的宽高
    CGFloat tempImgVWidth = image.size.width > self.scrollView.frame.size.width ? self.scrollView.frame.size.width:image.size.width;
    CGFloat tempImgVHeight = tempImgVWidth * image.size.height / image.size.width;
    
    // 再根据算出来的imageView的高度与容器的高度来计算最终的imageView的宽高
    CGFloat imgVHeight = tempImgVHeight > self.scrollView.frame.size.height ? self.scrollView.frame.size.height : tempImgVHeight;
    CGFloat imgVWidth  = image.size.width * imgVHeight / image.size.height;
    
    CGFloat imgX = (self.scrollView.frame.size.width - imgVWidth)/2;
    CGFloat imgY = (self.scrollView.frame.size.height - imgVHeight)/2;
    self.imageView.frame = CGRectMake(imgX, imgY, imgVWidth, imgVHeight);
}

// 设置图片
- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
    [self caculateImageViewFrameWithImage:image];
}
// 设置图片路径
- (void)setImageURL:(NSString *)imageURL
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image)
        {
            [self caculateImageViewFrameWithImage:image];
        }
    }];
}

// 回复到原来的比例
- (void)scaleToOriginalRatio
{
    [UIView animateWithDuration:0.2 animations:^{
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
        [UIView animateWithDuration:0.2 animations:^{
            self.scrollView.zoomScale = scale;
        } completion:^(BOOL finished) {
        }];
    }
    else
    {
        self.scrollView.zoomScale = scale;
    }
}

@end
