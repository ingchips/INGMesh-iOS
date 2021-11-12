//
//  MeshDeviceAddViewController.m
//  Pandro
//
//  Created by chun on 2019/1/8.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "MeshDeviceAddViewController.h"
#import "MeshPlaceDatabase.h"

@interface MeshDeviceAddViewController ()

@property(nonatomic, copy)NSString *placeId;

@property(nonatomic, strong)UITextField *nameField;

@end

@implementation MeshDeviceAddViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initContentUI];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)initContentUI
{
    //tip name
    float offset = self.navBar.frame.size.height;
    float leftOffset = 15;
    CGRect rect = CGRectMake(leftOffset, offset + 20, self.view.frame.size.width - 2 * leftOffset, 20);
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:rect];
    tipLabel.text = @"device Name";
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textColor = [UIColor bluePandroColor];
    tipLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:tipLabel];
    offset = offset + 40;
    
    //name
    [self.view addSubview:self.nameField];
    self.nameField.frame = CGRectMake(leftOffset, offset, self.view.frame.size.width - 2 * leftOffset, 40);
    offset = offset + 40;
    
    //line
    rect = CGRectMake(leftOffset, offset, self.view.frame.size.width - 2 * leftOffset, 0.5);
    [self.view addSubview:[UIView lineView:rect color:[UIColor littleGrayPandroColor]]];
    
    offset = offset + 100;
    
    //save
    rect = CGRectMake(leftOffset, offset, self.view.frame.size.width - 2 * leftOffset, 40);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"save" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor bluePandroColor]];
    [btn.layer setCornerRadius:10];
    [btn.layer setMasksToBounds:YES];
    btn.frame = rect;
    [btn addTarget:self action:@selector(clickSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self processCommand:self.pageCommand params:self.pageParams];
    
}

-(void)processCommand:(NSString *)command params:(NSDictionary *)params
{
    if ([command isEqualToString:@"init"])
    {
        self.placeId = [params valueForKey:@"placeId"];
    }
}

#pragma mark click

-(void)clickSaveBtn:(id)sender
{
    if (self.nameField.text.length == 0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"input" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"cancel" style:0 handler:^(UIAlertAction * action) {
            //
        }]];
        [self presentViewController:alertController animated:YES completion:^{
            //
        }];
        
        return;
    }
    
    NSString *errorMsg = [[MeshPlaceDatabase shareInstance] addDeviceForPlace:self.placeId deviceName:self.nameField.text];
    if (errorMsg)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:errorMsg delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
        [alertView show];
        
        return;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.placeId forKey:@"placeId"];
    [self popPage:dict command:@"init"];
}


#pragma mark getter and setter
-(UITextField *)nameField
{
    if (!_nameField)
    {
        _nameField = [[UITextField alloc] initWithFrame:CGRectZero];
        _nameField.font = [UIFont systemFontOfSize:20];
        _nameField.placeholder = @"name";
    }
    return _nameField;
}


@end
