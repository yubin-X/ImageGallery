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


@interface YBImageGalleryView ()<UICollectionViewDelegate,UICollectionViewDataSource,YBShowImageCollectionViewCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) YBShowImageCollectionViewCell *willDisplayCell;
//@property (nonatomic, assign) NSInteger currentOffsetX;
//@property (nonatomic, assign) NSInteger OffsetXWhenCellWillDisplay;
@property (nonatomic, assign) BOOL showOnce;;


@property (nonatomic, strong) YBImageGalleryTopView *topView;
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

#pragma mark - add top view
- (void)addTopView
{
    _topView = [[YBImageGalleryTopView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 64)];
    _topView.backgroundColor = [UIColor blackColor];
    
    __weak typeof(self) weakSelf = self;
    _topView.returnBtnCallBack = ^(void){
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.alpha = 0.0;
        } completion:^(BOOL finished) {
            [weakSelf removeFromSuperview];
        }];
    };
    
    [self addSubview:_topView];
    
    [self setTopViewTitleWithCurrentIndex:0];
    
}

#pragma mark - UICollectionViewDataSource;
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfImageInGallery:)]) {
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
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(imageInGallery:atIndex:)])
    {
        cell.image = [self.dataSource imageInGallery:self atIndex:index];
    }
    else if (self.dataSource && [self.dataSource respondsToSelector:@selector(imageUrlInGallery:atIndex:)])
    {
        cell.imageURL = [self.dataSource imageUrlInGallery:self atIndex:index];
    }
    // delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(backgroundColorForIndex:)])
    {
        cell.backgroundColor = [self.delegate backgroundColorForIndex:index];
    }
    else if (self.backgroundColor)
    {
        _collectionView.backgroundColor = self.backgroundColor;
    }
    
    cell.delegate = self;
}
#pragma mark - UICollectionViewDelegate
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

#pragma UIScrollViewDelegate
// scrollView正在滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

// 找出当前显示的cell,设置cell中的scrollView的scale
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    NSInteger index = (NSInteger)(x/SCREEN_WIDTH+0.5); // 四舍五入
    YBShowImageCollectionViewCell *cell = (YBShowImageCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0 ]];
    [cell toScale:1.0 animated:YES];
    [self setTopViewTitleWithCurrentIndex:index];
}

- (void)reloadData
{
    [self.collectionView reloadData];
}

#pragma mark - YBShowImageCollectionViewCellDelegate
- (void)tapCell:(YBShowImageCollectionViewCell *)cell atIndex:(NSInteger)index
{
    [_topView hideOrShowTopViewAnimated:YES];
}
// MARK: - 设置topView的title
- (void)setTopViewTitleWithCurrentIndex:(NSInteger)index
{
    NSInteger count;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfImageInGallery:)]) {
        count = [self.dataSource numberOfImageInGallery:self];
    }
    
    NSString *title = [NSString stringWithFormat:@"%ld/%ld",index+1,count];
    [_topView setTopTitle:title];
    
}
// 设置顶部菜单栏的背景色
- (void)setTopViewBackgroundColor:(UIColor *)topViewBackgroundColor
{
    _topView.backgroundColor = topViewBackgroundColor;
}
@end
