//
//  MeshIconSelViewController.m
//  Pandro
//
//  Created by chun on 2018/12/25.
//  Copyright © 2018年 chun. All rights reserved.
//

#import "MeshIconSelViewController.h"
#import "MeshIconSelCell.h"

@interface MeshIconSelViewController ()

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *iconArray;

@end

@implementation MeshIconSelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.iconArray = [[NSMutableArray alloc] init];
    [_iconArray addObjectsFromArray:@[@"ic_rest", @"ic_bed", @"ic_search", @"ic_home", @"ic_menu"]];
    
    [self.view addSubview:self.tableView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.width / 4.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.iconArray.count + 3)/4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifierForCell = @"identifierForCell";
    MeshIconSelCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierForCell];
    if (!cell)
    {
        cell = [[MeshIconSelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierForCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i=0;i <4;i++)
    {
        int nIndex = 4 * indexPath.row + i;
        if (nIndex < self.iconArray.count)
        {
            [array addObject:[self.iconArray objectAtIndex:nIndex]];
        }
    }
    
    [cell showContentFromArray:array];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark setter and getter
-(UITableView *)tableView
{
    if (!_tableView)
    {
        CGRect rect = CGRectMake(0, self.navBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navBar.frame.size.height);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.separatorColor = [UIColor clearColor];
    
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


@end
