//
//  YBImageGalleryView.m
//  CollectionView
//
//  Created by Caad on 2017/1/6.
//  Copyright © 2017年 X. All rights reserved.
//

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#ifdef DEBUG
#define YBLog(...) NSLog(__VA_ARGS__)
#else
#define YBLog(a...) do { } while(0)
#endif

#import "YBImageGalleryView.h"
#import "YBShowImageCollectionViewCell.h"
#import "YBImageGalleryTopView.h"


@interface YBImageGalleryView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) YBShowImageCollectionViewCell *willDisplayCell;
//@property (nonatomic, assign) NSInteger currentOffsetX;
//@property (nonatomic, assign) NSInteger OffsetXWhenCellWillDisplay;
@property (nonatomic, assign) BOOL showOnce;;

@end

@implementation YBImageGalleryView
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
    _showOnce = YES;
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowlayout.minimumLineSpacing = 0;
    flowlayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowlayout];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_collectionView];
    
    
    [self addTopView];
    
    [_collectionView registerClass:[YBShowImageCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([YBShowImageCollectionViewCell class])];
}

- (void)addTopView
{
    YBImageGalleryTopView *topView = [[YBImageGalleryTopView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 64)];
    [self addSubview:topView];
}






- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if ([self.dataSource respondsToSelector:@selector(numberOfImageInGallery:)]) {
         return [self.dataSource numberOfImageInGallery:self];
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YBShowImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YBShowImageCollectionViewCell class]) forIndexPath:indexPath];
    [self adjustCell:cell AtIndex:indexPath.item];
    return cell;
}

- (void)adjustCell:(YBShowImageCollectionViewCell *)cell AtIndex:(NSInteger)index
{
    // dataSource
    if ([self.dataSource respondsToSelector:@selector(imageInGallery:atIndex:)])
    {
        cell.image = [self.dataSource imageInGallery:self atIndex:index];
    }
    else if ([self.dataSource respondsToSelector:@selector(imageUrlInGallery:atIndex:)])
    {
        cell.imageURL = [self.dataSource imageUrlInGallery:self atIndex:index];
    }
    // delegate
    if ([self.delegate respondsToSelector:@selector(backgroundColorForIndex:)])
    {
        cell.backgroundColor = [self.delegate backgroundColorForIndex:index];
    }
    else if (self.backgroundColor)
    {
        _collectionView.backgroundColor = self.backgroundColor;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
}

// cell 将要显示
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    YBShowImageCollectionViewCell *itemCell = (YBShowImageCollectionViewCell *)cell;
    _willDisplayCell = itemCell;
    if (_showOnce)
        _showOnce = NO;
    else
    {
        [itemCell toScale:0.8 animated:NO];
    }
}

// cell 停止显示
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    YBShowImageCollectionViewCell *itemCell = (YBShowImageCollectionViewCell *)cell;
    [itemCell toScale:1.0 animated:NO];
}
// scrollView正在滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

// 找出当前显示的cell,设置cell中的scrollView的scale
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    NSInteger index = (NSInteger)(x/SCREEN_WIDTH+0.5);
    YBShowImageCollectionViewCell *cell = (YBShowImageCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0 ]];
    [cell toScale:1.0 animated:YES];
}

- (void)reloadData
{
    [self.collectionView reloadData];
}

@end