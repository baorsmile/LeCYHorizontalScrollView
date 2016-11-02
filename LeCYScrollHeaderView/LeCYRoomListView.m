//
//  LeCYRoomListView.m
//  LeCYScrollHeaderView
//
//  Created by dabao on 16/9/6.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "LeCYRoomListView.h"

@interface LeCYRoomListView ()
@property (nonatomic, strong) NSMutableArray *sources;
@end

@implementation LeCYRoomListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.displayTableView.delegate = self;
        self.displayTableView.dataSource = self;
    }
    return self;
}

- (NSMutableArray *)sources
{
    if (!_sources) {
        _sources = [@[] mutableCopy];
        
        for (NSInteger i = 0; i < 20; i ++) {
            [_sources addObject:[NSString stringWithFormat:@"%ld", i]];
        }
    }
    return _sources;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MY";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = self.sources[indexPath.row];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

@end
