//
//  LeCYHorizontalBaseView.m
//  LeCYScrollHeaderView
//
//  Created by dabao on 16/9/7.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "LeCYHorizontalBaseView.h"

@implementation LeCYHorizontalBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.displayTableView];
    }
    return self;
}


#pragma mark - Get
- (UITableView *)displayTableView
{
    if (!_displayTableView) {
        _displayTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    }
    return _displayTableView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.displayTableView.frame = self.bounds;
}

@end
