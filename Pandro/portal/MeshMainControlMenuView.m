//
//  MeshMainControlMenuView.m
//  Pandro
//
//  Created by chun on 2018/12/20.
//  Copyright © 2018年 chun. All rights reserved.
//

#import "MeshMainControlMenuView.h"
#import "UIView+PandroView.h"
#import "PandroSuperViewController.h"

@interface MeshMainControlMenuView ()

@property(nonatomic, strong)UITableView *tableView;

@end

@implementation MeshMainControlMenuView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.8];
    [self addTarget:self action:@selector(clickSelfBackground:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.tableView];
    
    return self;
}




static MeshMainControlMenuView *kStaticInstance = nil;
+(MeshMainControlMenuView *)shareInstance
{
    return kStaticInstance;
}

+(void)showMenuViewInView:(UIView *)view
{
    if (!kStaticInstance)
    {
        kStaticInstance = [[MeshMainControlMenuView alloc] initWithFrame:view.frame];
        [view addSubview:kStaticInstance];
    }
    
    [kStaticInstance showMenuView];
    
}

#pragma mark show and hide
-(void)showMenuView
{
    CGRect rect = kStaticInstance.frame;
    rect.origin.x = - rect.size.width;
    self.frame = rect;
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        //
        CGRect rectAnim = weakSelf.frame;
        rectAnim.origin.x = 0;
        weakSelf.frame = rectAnim;
    }];
}

-(void)clickSelfBackground:(id)sender
{
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        //
        CGRect rectAnim = weakSelf.frame;
        rectAnim.origin.x = - weakSelf.frame.size.width;
        weakSelf.frame = rectAnim;
    }];
}

#pragma mark tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifierForCell = @"identifierForCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierForCell];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierForCell];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d cell", indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PandroSuperViewController *viewCon = [self selfViewController];
    [self clickSelfBackground:nil];
    
}

#pragma mark setter and getter
-(UITableView *)tableView
{
    if (!_tableView)
    {
        CGRect rect = CGRectMake(0, 0, self.frame.size.width * 3.0 / 4.0, self.frame.size.height);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
