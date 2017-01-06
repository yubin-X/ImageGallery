//
//  ViewController.m
//  CollectionView
//
//  Created by Caad on 2017/1/5.
//  Copyright © 2017年 X. All rights reserved.
//


#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#import "ViewController.h"
#import "ImageCollectionCell.h"
#import "YBShowImageCollectionViewCell.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) id currentCell;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowlayout.minimumLineSpacing = 0;
    flowlayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowlayout];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
    
    
    [_collectionView registerClass:[YBShowImageCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([YBShowImageCollectionViewCell class])];
}


-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 32;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YBShowImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YBShowImageCollectionViewCell class]) forIndexPath:indexPath];

    cell.contentView.backgroundColor = [UIColor blackColor];//[UIColor colorWithRed:(arc4random()%156 + 100)/255.0 green:(arc4random()%156 + 100)/255.0 blue:(arc4random()%156 + 100)/255.0 alpha:1];
    cell.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld_full",indexPath.item]];
    
    NSLog(@"cellForItem:%@",indexPath);
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"willDisplayCell:%@",indexPath);
    YBShowImageCollectionViewCell *itemCell = (YBShowImageCollectionViewCell *)cell;
    [itemCell toScale:0.8 animated:NO];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didEndDisplaying:%@",indexPath);
    YBShowImageCollectionViewCell *itemCell = (YBShowImageCollectionViewCell *)cell;
    [itemCell toScale:1.0 animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollView");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    NSInteger index = (NSInteger)(x/SCREEN_WIDTH+0.5);
    YBShowImageCollectionViewCell *cell = (YBShowImageCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0 ]];
    [cell toScale:1.0 animated:YES];
}
@end
