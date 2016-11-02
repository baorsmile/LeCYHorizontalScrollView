//
//  SecondViewController.m
//  LeCYScrollHeaderView
//
//  Created by dabao on 16/9/6.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "SecondViewController.h"
#import "LeCYLeadView.h"
#import "LeCYRoomListView.h"
#import "LeCYHorizontalScrollView.h"

@interface SecondViewController () <LeCYHorizontalScrollViewDelegate>
@property (nonatomic, strong) LeCYHorizontalScrollView *horizontalScrollView;
@property (nonatomic, strong) LeCYLeadView *leadView;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.horizontalScrollView];
    self.horizontalScrollView.horizontalHeaderView = self.leadView;
    
    [self.horizontalScrollView reloadData];
    
    __weak typeof(self) weakSelf = self;
    self.leadView.segmentedControlSelectedIndex = ^(NSInteger selectedIndex) {
        [weakSelf.horizontalScrollView changeIndexBySelected:selectedIndex];
    };

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (LeCYHorizontalScrollView *)horizontalScrollView
{
    if (!_horizontalScrollView) {
        
        CGRect frame = self.view.bounds;
        
        frame.size.height -= 49;
        
        _horizontalScrollView = [[LeCYHorizontalScrollView alloc] initWithFrame:frame];
        _horizontalScrollView.horizontalDelegate = self;
    }
    return _horizontalScrollView;
}

- (LeCYLeadView *)leadView
{
    if (!_leadView) {
        _leadView = [[LeCYLeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kLeadViewHeight)];
        _leadView.backgroundColor = [UIColor redColor];
    }
    return _leadView;
}

- (NSInteger)numberOfViewsInHorizontalScrollView:(LeCYHorizontalScrollView *)horizontalScrollView
{
    return 3;
}

- (CGFloat)heightForSelectorInHorizontalScrollView:(LeCYHorizontalScrollView *)horizontalScrollView
{
    return 60;
}

- (UIView *)horizontalScrollView:(LeCYHorizontalScrollView *)horizontalScrollView viewAtIndex:(NSInteger)index
{
    LeCYRoomListView *view = [[LeCYRoomListView alloc] initWithFrame:horizontalScrollView.bounds];
    return view;
}

- (void)horizontalScrollView:(LeCYHorizontalScrollView *)horizontalScrollView viewShowAtIndex:(NSInteger)index
{
    self.leadView.selectedIndex = index;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
