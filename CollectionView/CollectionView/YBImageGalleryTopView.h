//
//  YBImageGalleryTopView.h
//  CollectionView
//
//  Created by Caad on 2017/1/6.
//  Copyright © 2017年 X. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^CallBack)();

@protocol TopViewDelegate <NSObject>



@end

@interface YBImageGalleryTopView : UIView
/** 设置标题 */
@property (nonatomic, copy) NSString * topTitle;
/** 点击返回按钮的回调事件 */
@property (nonatomic, copy) CallBack returnBtnCallBack;

// 隐藏或显示顶部的菜单栏
- (void)hideTopViewAnimated:(BOOL)animated;
- (void)showTopViewAnimated:(BOOL)animated;
- (void)hideOrShowTopViewAnimated:(BOOL)animated;
@end
