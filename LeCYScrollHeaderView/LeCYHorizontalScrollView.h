//
//  LeCYHorizontalScrollView.h
//  LeCYScrollHeaderView
//
//  Created by dabao on 16/9/6.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LeCYHorizontalScrollView;

@protocol LeCYHorizontalScrollViewDelegate <NSObject>
/**
 *  view个数
 *
 *  @param horizontalScrollView
 *
 *  @return 个数
 */
- (NSInteger)numberOfViewsInHorizontalScrollView:(LeCYHorizontalScrollView *)horizontalScrollView;

/**
 *  选择器的高度
 *
 *  @param horizontalScrollView
 *
 *  @return 高度
 */
- (CGFloat)heightForSelectorInHorizontalScrollView:(LeCYHorizontalScrollView *)horizontalScrollView;

/**
 *  展示的index
 *
 *  @param horizontalScrollView
 *  @param index                位置
 */
- (void)horizontalScrollView:(LeCYHorizontalScrollView *)horizontalScrollView viewShowAtIndex:(NSInteger)index;

/**
 *  返回view
 *
 *  @param horizontalScrollView
 *  @param index                位置
 *
 *  @return LeCYHorizontalBaseView
 */
- (UIView *)horizontalScrollView:(LeCYHorizontalScrollView *)horizontalScrollView viewAtIndex:(NSInteger)index;
@end

@interface LeCYHorizontalScrollView : UIView
@property (nonatomic, weak) id <LeCYHorizontalScrollViewDelegate> horizontalDelegate;
@property (nonatomic, strong) UIView *horizontalHeaderView;
@property (nonatomic, assign, readonly) NSInteger currentViewIndex;

- (void)reloadData;

- (void)changeIndexBySelected:(NSInteger)selectedIndex;
@end
