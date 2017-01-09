//
//  YBShowImageCollectionViewCell.h
//  CollectionView
//
//  Created by Caad on 2017/1/5.
//  Copyright © 2017年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBShowImageCollectionViewCell;
@protocol YBShowImageCollectionViewCellDelegate <NSObject>

- (void)tapCell:(YBShowImageCollectionViewCell *)cell atIndex:(NSInteger)index;

@end

@interface YBShowImageCollectionViewCell : UICollectionViewCell

@property (nonatomic,assign) NSInteger index;
@property (nonatomic, weak) id<YBShowImageCollectionViewCellDelegate> delegate;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,copy)   NSString *imageURL;

- (void)toScale:(CGFloat)scale animated:(BOOL)animated;

@end
