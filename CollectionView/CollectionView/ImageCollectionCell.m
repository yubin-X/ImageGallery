//
//  ImageCollectionCell.m
//  CollectionView
//
//  Created by Caad on 2017/1/5.
//  Copyright © 2017年 X. All rights reserved.
//

#import "ImageCollectionCell.h"

@interface ImageCollectionCell ()
@property (nonatomic, assign) BOOL isScaled;
@end

@implementation ImageCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgScrollView.minimumZoomScale = 0.5;
    self.imgScrollView.maximumZoomScale = 4;
    self.imgScrollView.delegate = self;
    self.imageView.userInteractionEnabled = YES;
    
    // 单击手势
    UITapGestureRecognizer *singleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleGestureAction)];
    singleGesture.numberOfTapsRequired = 1;
    // 双击手势
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleGestureAction)];
    doubleTapGesture.numberOfTapsRequired = 2;
    
    // 双击手势响应失败之后再响应单击手势
    [singleGesture requireGestureRecognizerToFail:doubleTapGesture];
    [self.imageView addGestureRecognizer:singleGesture];
    [self.imageView addGestureRecognizer:doubleTapGesture];

}
// 单击手势事件
- (void)singleGestureAction
{
//    [self removeFromSuperViewAnimated:YES];
}
// 双击手势事件
- (void)doubleGestureAction
{
    if (!self.isScaled)
    {
        [UIView animateWithDuration:0.4 animations:^{
            self.imgScrollView.zoomScale = 2.0;
        } completion:^(BOOL finished) {
            self.isScaled = YES;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.4 animations:^{
            self.imgScrollView.zoomScale = 1.0;
        } completion:^(BOOL finished) {
            self.isScaled = NO;
        }];
    }
}



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



@end
