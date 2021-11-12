//
//  LampPortalSettingViewController.m
//  Pandro
//
//  Created by chun on 2019/1/15.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "LampPortalSettingViewController.h"
#import "MeshPlaceDatabase.h"

@interface LampPortalSettingViewController ()

@property(nonatomic, strong)UITableView *tableView;

@end

@implementation LampPortalSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showNavBarTitle:@"设置"];
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(NSString *)favoritePlaceName
{
    NSMutableArray *placeArray = [[MeshPlaceDatabase shareInstance] placeArray];
    
    for (MeshPlaceModel *placeModel in placeArray)
    {
        if (placeModel.favorite)
        {
            return placeModel.name;
        }
    }
    return @"默认家庭";
}

#pragma mark tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    return 1;
}
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"高级功能";
    }
    else if (section == 1)
    {
        return @"关于我们";
    }
    return @"";
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifierForCell = @"identifierForCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierForCell];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifierForCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
        //cell.contentView.backgroundColor = [UIColor clearColor];
        
        CGRect rect = cell.frame;
        //cell.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width - 100, rect.size.height);
    }
    //cell.textLabel.textColor = [UIColor whiteColor];
    
    NSString *text = @"";
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            text = @"当前家庭";
            cell.detailTextLabel.text = [self favoritePlaceName];
        }
        else
        {
            text = @"设置语言";
            NSString *language = @"中文";
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"app_setting_language"] intValue] == 1)
            {
                language = @"English";
            }
            
            cell.detailTextLabel.text = language;
        }
        
    }
    else if (indexPath.section == 1)
    {
        text = @"关于我们";
    }
    
    cell.textLabel.text = text;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            [self gotoPage:PAGE_LAME_PORTAL_SET_HOME_VC params:nil command:@"init"];
        }
        else
        {
            [self gotoPage:PAGE_LAME_PORTAL_SET_LANGUAGE_VC params:nil command:@"init"];
        }
    }
    else if (indexPath.section == 1)
    {
        [self gotoPage:PAGE_LAME_PORTAL_SET_ABOUTUS_VC params:nil command:@"init"];
    }
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
