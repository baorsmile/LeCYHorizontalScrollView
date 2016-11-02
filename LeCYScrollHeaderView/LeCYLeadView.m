//
//  LeCYLeadView.m
//  LeCYScrollHeaderView
//
//  Created by dabao on 16/9/2.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "LeCYLeadView.h"

@interface LeCYLeadView ()
@property (nonatomic, strong) UIView *segmentBackgroundView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@end

@implementation LeCYLeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.segmentBackgroundView];
        [self.segmentBackgroundView addSubview:self.segmentedControl];
    }
    return self;
}

#pragma mark - Get
- (UIView *)segmentBackgroundView
{
    if (!_segmentBackgroundView) {
        _segmentBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, kLeadViewHeight - 60, self.bounds.size.width, kSegmentedContentHeight)];
        _segmentBackgroundView.backgroundColor = [UIColor orangeColor];
    }
    return _segmentBackgroundView;
}

- (UISegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"推荐", @"最新", @"关注"]];
        _segmentedControl.frame = CGRectMake(0, 0, 300, 40);
        _segmentedControl.center = CGPointMake(self.segmentBackgroundView.bounds.size.width/2, self.segmentBackgroundView.bounds.size.height/2);
        _segmentedControl.selectedSegmentIndex = 0;
        [_segmentedControl addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (void)valueChange:(UISegmentedControl *)control
{
    NSLog(@"control %ld", control.selectedSegmentIndex);
    if (self.segmentedControlSelectedIndex) {
        self.segmentedControlSelectedIndex(control.selectedSegmentIndex);
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex == selectedIndex) { return; }
    _selectedIndex = selectedIndex;
    self.segmentedControl.selectedSegmentIndex = selectedIndex;
}
@end
