//
//  ImageCollectionCell.h
//  CollectionView
//
//  Created by Caad on 2017/1/5.
//  Copyright © 2017年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCollectionCell : UICollectionViewCell<UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *imgScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
