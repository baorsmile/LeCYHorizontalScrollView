//
//  LeCYHorizontalScrollView.m
//  LeCYScrollHeaderView
//
//  Created by dabao on 16/9/6.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "LeCYHorizontalScrollView.h"
#import "LeCYHorizontalBaseView.h"

static NSString *const kScrollViewContentOffset = @"contentOffset";

@interface LeCYHorizontalScrollView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *horizontalScrollView;
@property (nonatomic, strong) NSMutableArray<__kindof LeCYHorizontalBaseView *> *visibleViews;
@property (nonatomic, assign) CGFloat leadContentHeight;
@property (nonatomic, assign) NSInteger currentViewIndex;
@end

@implementation LeCYHorizontalScrollView

- (void)dealloc
{
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.visibleViews = [@[] mutableCopy];
        [self addSubview:self.horizontalScrollView];
    }
    return self;
}

- (UIScrollView *)horizontalScrollView
{
    if (!_horizontalScrollView) {
        _horizontalScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _horizontalScrollView.delegate = self;
        _horizontalScrollView.pagingEnabled = YES;
        _horizontalScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _horizontalScrollView;
}

- (void)setHorizontalHeaderView:(UIView *)horizontalHeaderView
{
    _horizontalHeaderView = horizontalHeaderView;
}

#pragma mark - Helper
- (void)reloadData
{
    if (   ![self.horizontalDelegate respondsToSelector:@selector(numberOfViewsInHorizontalScrollView:)]
        || ![self.horizontalDelegate respondsToSelector:@selector(horizontalScrollView:viewAtIndex:)]) {
        return;
    }
    
    [self removeVisibleViews];
    
    NSInteger numViews = [self.horizontalDelegate numberOfViewsInHorizontalScrollView:self];
    
    for (NSInteger i = 0; i < numViews; i ++) {
      
        LeCYHorizontalBaseView *view = (LeCYHorizontalBaseView *)[self.horizontalDelegate horizontalScrollView:self viewAtIndex:i];
        
        CGRect viewFrame = view.frame;
        
        viewFrame.origin = CGPointMake(i * viewFrame.size.width, 0);
        
        view.frame = viewFrame;
        
        [self.horizontalScrollView addSubview:view];
        
        if (self.horizontalHeaderView) {
            // 添加空白页
            UIView *stanceView = [[UIView alloc] initWithFrame:self.horizontalHeaderView.bounds];
            view.displayTableView.tableHeaderView = stanceView;
            
            if (i == 0) {
                [view.displayTableView addSubview:self.horizontalHeaderView];
            }
        }
        
        [self.visibleViews addObject:view];
        
        
        //添加监听者
        [view.displayTableView addObserver: self
                                forKeyPath: kScrollViewContentOffset
                                   options: NSKeyValueObservingOptionNew
                                   context: nil];

    }
    
    self.horizontalScrollView.contentSize = CGSizeMake(self.bounds.size.width * numViews, self.bounds.size.height);
}

- (void)changeIndexBySelected:(NSInteger)selectedIndex
{
    [self scrollViewWillBeginDragging:self.horizontalScrollView];
    [self.horizontalScrollView setContentOffset:CGPointMake(selectedIndex * self.bounds.size.width, 0) animated:YES];
}

- (void)removeVisibleViews
{
    for (LeCYHorizontalBaseView *view in self.visibleViews) {
        [view removeFromSuperview];
        [view.displayTableView removeObserver:self forKeyPath:kScrollViewContentOffset];
    }
    
    [self.visibleViews removeAllObjects];
}

- (CGFloat)leadContentHeight
{
    if ([self.horizontalDelegate respondsToSelector:@selector(heightForSelectorInHorizontalScrollView:)]) {
        return CGRectGetHeight(self.horizontalHeaderView.bounds) - [self.horizontalDelegate heightForSelectorInHorizontalScrollView:self];
    }
    return CGRectGetHeight(self.horizontalHeaderView.bounds);
}

/**
 *  监听属性值发生改变时回调
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (![keyPath isEqualToString:@"contentOffset"]) { return; }
    
    if (self.visibleViews.count > self.currentViewIndex) {
        LeCYHorizontalBaseView *currentHorizontalView = self.visibleViews[self.currentViewIndex];
        if (currentHorizontalView.displayTableView == object) {
            [self resetLeadView:currentHorizontalView.displayTableView];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndScrollingAnimation");
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDragging");
    if (self.horizontalScrollView == scrollView) {
        if ([self.subviews containsObject:self.horizontalHeaderView]) {
            return;
        }
        
        NSInteger currentIndex = scrollView.contentOffset.x / self.bounds.size.width;
        LeCYHorizontalBaseView *currentHorizontalView = self.visibleViews[currentIndex];
        
        CGFloat contentOffsetY = currentHorizontalView.displayTableView.contentOffset.y;
        
        CGRect headerFrame = self.horizontalHeaderView.frame;
        
        if (contentOffsetY >= self.leadContentHeight) {
            // 顶部栏吸顶状态
            headerFrame.origin = CGPointMake(0, -self.leadContentHeight);
            
            for (NSInteger i = 0; i < self.visibleViews.count; i ++) {
                if (i != currentIndex) {
                    LeCYHorizontalBaseView *otherHorizontalView = self.visibleViews[i];
                    if (otherHorizontalView.displayTableView.contentOffset.y <= self.leadContentHeight) {
                        otherHorizontalView.displayTableView.contentOffset = CGPointMake(0, self.leadContentHeight);
                    }
                }
            }
            
        } else {
            // 顶部栏显示全部或者部分
            headerFrame.origin.y = -contentOffsetY;
            
            for (NSInteger i = 0; i < self.visibleViews.count; i ++) {
                if (i != currentIndex) {
                    LeCYHorizontalBaseView *otherHorizontalView = self.visibleViews[i];
                    otherHorizontalView.displayTableView.contentOffset = currentHorizontalView.displayTableView.contentOffset;
                }
            }
        }
        
        self.horizontalHeaderView.frame = headerFrame;
        [self addSubview:self.horizontalHeaderView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating");
    if (self.horizontalScrollView == scrollView) {
        NSInteger currentIndex = scrollView.contentOffset.x / self.horizontalScrollView.bounds.size.width;
        LeCYHorizontalBaseView *currentHorizontalView = self.visibleViews[currentIndex];
        [currentHorizontalView.displayTableView addSubview:self.horizontalHeaderView];
        [self resetLeadView:currentHorizontalView.displayTableView];
        self.currentViewIndex = currentIndex;
        if ([self.horizontalDelegate respondsToSelector:@selector(horizontalScrollView:viewShowAtIndex:)]) {
            [self.horizontalDelegate horizontalScrollView:self viewShowAtIndex:currentIndex];
        }
    }
}

#pragma mark - Helper
- (void)resetLeadView:(UITableView *)scrollView
{
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    
    CGRect headerFrame = self.horizontalHeaderView.frame;
    
    if (contentOffsetY >= self.leadContentHeight) {
        headerFrame.origin = CGPointMake(0, contentOffsetY - self.leadContentHeight);
        self.horizontalHeaderView.frame = headerFrame;
    } else {
        if (headerFrame.origin.y == 0) {
            return;
        }
        headerFrame.origin = CGPointMake(0, 0);
        self.horizontalHeaderView.frame = headerFrame;
    }
}

@end

