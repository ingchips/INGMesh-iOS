//
//  LampPortalSettingHomeViewController.m
//  Pandro
//
//  Created by chun on 2019/2/27.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "LampPortalSettingHomeViewController.h"
#import "LampGroupSetNameView.h"
#import "MeshPlaceDatabase.h"


@interface LampPortalSettingHomeViewController ()
{
    int selectedIndex;
}

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIButton *addButton;

@property(nonatomic, strong)NSMutableArray *placeArray;

@end

@implementation LampPortalSettingHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showNavBarTitle:@"家庭列表"];
    
    [self.view addSubview:self.addButton];
    float topOffset = self.navBar.frame.size.height + 10;
    self.addButton.frame = CGRectMake(15, topOffset, self.view.frame.size.width - 30, 40);
    
    topOffset = topOffset + self.addButton.frame.size.height - 20;
    CGRect rect = CGRectMake(15, topOffset, self.view.frame.size.width-30, self.view.frame.size.height - topOffset);
    
    [self.view addSubview:self.tableView];
    self.tableView.frame = rect;
    
    [self loadHomeData];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark fun
-(void)loadHomeData
{
    self.placeArray = [[MeshPlaceDatabase shareInstance] placeArray];
    
    for (MeshPlaceModel *placeModel in self.placeArray)
    {
        if (placeModel.favorite)
        {
            selectedIndex = [self.placeArray indexOfObject:placeModel];
            break;
        }
    }
    [self.tableView reloadData];
}

#pragma mark click
-(void)clickAddBtn:(UIButton *)addBtn
{
    __weak typeof(self) weakSelf = self;
    
    CGRect rect = CGRectMake(0, self.navBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.navBar.frame.size.height);
    LampGroupSetNameView *nameView = [[LampGroupSetNameView alloc] initWithFrame:rect groupName:nil];
    
    rect.origin.y = self.view.frame.size.height;
    nameView.frame = rect;
    
    nameView.nameTipLabel.text = @"添加新家";
    nameView.textField.placeholder = @"新家庭名称";
    
    [self.view addSubview:nameView];
    __block CGRect animRect = rect;
    [UIView animateWithDuration:0.1 animations:^{
        //
        animRect.origin.y = weakSelf.navBar.frame.size.height;
        nameView.frame = animRect;
    }];
    
    nameView.clickedBlock = ^BOOL(NSString *name) {
        return [weakSelf clickAddBtn_innerName:name];
    };
}

-(BOOL)clickAddBtn_innerName:(NSString *)name
{
    if (!name || name.length == 0)
    {
        [self.view showAnimationTip:@"请输入家庭名称" topOffset:0];
        return NO;
    }
    
    NSString *addTip = [[MeshPlaceDatabase shareInstance] addPlace:name];
    if (!addTip)
    {
        [self loadHomeData];
        return YES;
    }
    [self.view showAnimationTip:addTip topOffset:0];
    return NO;
}

#pragma mark tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.placeArray.count;
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
    
    MeshPlaceModel *placeModel = [self.placeArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = placeModel.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedIndex == indexPath.row)
    {
        return;
    }
    
    MeshPlaceModel *lastModel = [self.placeArray objectAtIndex:selectedIndex];
    lastModel.favorite = NO;
    
    MeshPlaceModel *thisModel = [self.placeArray objectAtIndex:indexPath.row];
    thisModel.favorite = YES;
    
    [[MeshPlaceDatabase shareInstance] savaDatabase];
    
    [self loadHomeData];
}


#pragma mark setter and getter
-(UIButton *)addButton
{
    if (!_addButton)
    {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setTitle:@"输入添加" forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor bluePandroColor] forState:UIControlStateNormal];
        [_addButton setBackgroundColor:[UIColor whiteColor]];
        [_addButton.layer setCornerRadius:10];
        [_addButton.layer setMasksToBounds:YES];
        [_addButton addTarget:self action:@selector(clickAddBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

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
