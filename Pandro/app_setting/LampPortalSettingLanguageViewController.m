//
//  LampPortalSettingLanguageViewController.m
//  Pandro
//
//  Created by chun on 2019/1/22.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "LampPortalSettingLanguageViewController.h"

@interface LampPortalSettingLanguageViewController ()
{
    int selectedIndex;
}

@property(nonatomic, strong)UITableView *tableView;

@end

@implementation LampPortalSettingLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    selectedIndex = [[[NSUserDefaults standardUserDefaults] valueForKey:@"app_setting_language"] intValue];
    
    [self showNavBarTitle:@"设置语言"];
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
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifierForCell = @"identifierForCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierForCell];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierForCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        //cell.backgroundColor = [UIColor secondBlackPandroColor];
    }
    //cell.textLabel.textColor = [UIColor whiteColor];
    
    if (indexPath.row == selectedIndex)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSString *text = @"";

    if (indexPath.row == 0)
    {
        text = @"简体中文";
    }
    else
    {
        text = @"English";
    }
    
    cell.textLabel.text = text;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = indexPath.row;
    
    [self.tableView reloadData];
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d", selectedIndex] forKey:@"app_setting_language"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark setter and getter
-(UITableView *)tableView
{
    if (!_tableView)
    {
        CGRect rect = CGRectMake(15, self.navBar.frame.size.height, self.view.frame.size.width-30, self.view.frame.size.height - self.navBar.frame.size.height);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [UIColor littleGrayPandroColor];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.layer.shadowColor = [UIColor bluePandroColor].CGColor;
        _tableView.layer.shadowOffset = CGSizeMake(5, 5);
        _tableView.layer.shadowRadius = 2;
        _tableView.layer.shadowOpacity = 0.2;
    }
    return _tableView;
}

@end
