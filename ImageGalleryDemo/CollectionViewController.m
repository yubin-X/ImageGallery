//
//  CollectionViewController.m
//  ImageGalleryDemo
//
//  Created by Caad on 2017/4/6.
//  Copyright © 2017年 X. All rights reserved.
//

#import "CollectionViewController.h"
#import "YBImageGalleryView.h"
#import <UIImageView+WebCache.h>
#import "CollectionViewCell.h"

@interface CollectionViewController ()<YBImageGalleryViewDelegate,YBImageGalleryViewDataSource>

@property (nonatomic,strong) NSArray *pictureArr;
@property (nonatomic, strong) YBImageGalleryView *gallery;

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"CELL";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeFakeData];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    //同一行相邻两个cell的最小间距
    layout.minimumInteritemSpacing = 5;
    //最小两行之间的间距
    layout.minimumLineSpacing = 5;
    layout.itemSize = CGSizeMake(100, 100);
    self.collectionView.collectionViewLayout = layout;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)makeFakeData
{
    _pictureArr = @[@"http://p1.bqimg.com/567571/b6f92749812259d0.jpg",
                    @"http://p1.bpimg.com/4851/b6f92749812259d0.jpg",
                    @"http://p1.bpimg.com/4851/b6f92749812259d0.jpg",
                    @"http://p1.bpimg.com/4851/5f834f86e10b7b33.jpg",
                    @"http://p1.bpimg.com/4851/a24348b318659984.jpg",
                    @"http://p1.bpimg.com/4851/7e38d493395e8216.jpg",
                    @"http://p1.bpimg.com/4851/5a292d93f7da8ff6.jpg"
                    ];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _pictureArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSString *imageUrlStr = [_pictureArr objectAtIndex:indexPath.item];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"UIImage:%@",image);
    }];

    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self beginShowImageGalleryWithImageIndex:indexPath.item];
}

#pragma mark - ImageGallery 

- (void)beginShowImageGalleryWithImageIndex:(NSInteger)index
{
    YBImageGalleryView *view = [[YBImageGalleryView alloc] initWithFrame:self.view.bounds];
    view.currentIndex = index;
    view.dataSource = self;
    [self.view addSubview:view];
    _gallery = view;
}

- (NSInteger)numberOfImageInGallery:(YBImageGalleryView *)gallery
{
    return _pictureArr.count;
}
// 通过图片地址加载图片
- (NSString *)imageUrlInGallery:(YBImageGalleryView *)gallery atIndex:(NSInteger)index
{
    return _pictureArr[index];
}

- (void)viewWillLayoutSubviews
{
    _gallery.frame = self.view.bounds;
}


@end
