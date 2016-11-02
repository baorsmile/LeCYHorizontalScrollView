//
//  LeCYLeadView.h
//  LeCYScrollHeaderView
//
//  Created by dabao on 16/9/2.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat kLeadViewHeight = 300;
static CGFloat kSegmentedContentHeight = 60;

@interface LeCYLeadView : UIView

@property (nonatomic, copy) void (^segmentedControlSelectedIndex)(NSInteger selectedIndex);

@property (nonatomic, assign) NSInteger selectedIndex;

@end
