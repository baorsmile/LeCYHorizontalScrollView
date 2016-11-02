//
//  LeCYHorizontalBaseView.h
//  LeCYScrollHeaderView
//
//  Created by dabao on 16/9/7.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeCYHorizontalBaseView : UIView <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *displayTableView;

@end
