//
//  YBImageGalleryView.h
//  CollectionView
//
//  Created by Caad on 2017/1/6.
//  Copyright © 2017年 X. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YBImageGalleryView;

#pragma mark - YBImageGalleryViewDataSource
@protocol YBImageGalleryViewDataSource <NSObject>

@required
/* 画廊中图片的数量 */
- (NSInteger)numberOfImageInGallery:(YBImageGalleryView *)gallery;
@optional

/*
 
 下面的两个代理方法,只需要根据实际情况实现一种即可
 
 1:如果直接加载图片则使用 `imageInGallery:atIndex:` 代理方法
 2:如果是通过图片的URL来加载图片则使用 `imageUrlInGallery:atIndex` 代理方法
 注意: URL加载图片是使用的SDWebImage框架来实现的,所以在使用本库来展示图片时要导入SDWebImage第三方库
 
 */
- (UIImage *)imageInGallery:(YBImageGalleryView *)gallery atIndex:(NSInteger)index;
- (NSString *)imageUrlInGallery:(YBImageGalleryView *)gallery atIndex:(NSInteger)index;
@end

@protocol YBImageGalleryViewDelegate <NSObject>

/** 设置每张图片的背景色 */
- (UIColor *)backgroundColorForIndex:(NSInteger)index;

@end


#pragma mark - YBImageGalleryView

@interface YBImageGalleryView : UIView
/**
 * 显示图片的视图的背景色
 1:背景色当实现代理`backgroundColorForIndex:`时,设置此属性无效
 2:当没有实现上述代理时,每张图片的背景色为此属性的值
 3:当两者都没设置时,默认为白色背景
 */
@property (nonatomic, strong) UIColor *cellBackgroundColor;
@property (nonatomic, weak) id<YBImageGalleryViewDataSource> dataSource;
@property (nonatomic, weak) id<YBImageGalleryViewDelegate> delegate;
@property (nonatomic, strong) UIColor *topViewBackgroundColor;
@property (nonatomic, assign) NSInteger currentIndex;
- (void)reloadData;

@end
