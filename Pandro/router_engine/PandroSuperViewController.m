//
//  PandroSuperViewController.m
//  Pandro
//
//  Created by chun on 2018/12/11.
//  Copyright © 2018年 chun. All rights reserved.
//

#import "PandroSuperViewController.h"
#import "UIColor+PandroColor.h"

@interface PandroSuperViewController ()

@end

@implementation PandroSuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"F1F1F1FF"];
    
    [self showNavBar];
    [self showNavBarLeftBackButton];
    [self.navigationController setNavigationBarHidden:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    
    
    [super viewWillAppear:animated];
}

-(void)dealloc
{
    [self cancelAllActor];
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
-(void)showNavBar
{
    float height = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    self.navBar = [[PandroNavBarView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44 + height)];
    [self.view addSubview:self.navBar];
}

-(void)showNavBarLeftBackButton
{
    [self.navBar.leftBtn addTarget:self action:@selector(clickLeftBtn) forControlEvents:UIControlEventTouchUpInside];
}

-(void)showNavBarTitle:(NSString *)title
{
    self.navBar.titlelabel.text = title;
}

#pragma mark event
-(void)clickLeftBtn
{
    [self popPage:nil command:nil];
}


#pragma mark router
-(void)gotoPage:(NSString *)pageName params:(NSMutableDictionary *)params command:(NSString *)command
{
    Class className = NSClassFromString(pageName);
    PandroSuperViewController *viewCon = [[className alloc] init];
    
    if (!viewCon)
    {
        return;
    }
    
    viewCon.pageParams = params;
    viewCon.pageCommand = command;
    
    [self.navigationController pushViewController:viewCon animated:YES];
    
}
-(void)popPage:(NSMutableDictionary *)params command:(NSString *)command
{
    NSMutableArray *arrayVC = self.navigationController.viewControllers;
    if (arrayVC.count >= 2)
    {
        PandroSuperViewController *lastVC = [arrayVC objectAtIndex:arrayVC.count - 2];
        //if (params)
        {
            lastVC.pageParams = params;
        }
        //if (command)
        {
            lastVC.pageCommand = command;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)popCountPage:(int)count params:(NSMutableDictionary *)params command:(NSString *)command
{
    NSMutableArray *arrayVC = self.navigationController.viewControllers;
    if (count >= arrayVC.count)
    {
        return;
    }
    int nIndex = arrayVC.count - count - 1;
    if (nIndex >= 0 && nIndex < arrayVC.count)
    {
        PandroSuperViewController *lastVC = [arrayVC objectAtIndex:nIndex];
        
        //if (params)
        {
            lastVC.pageParams = params;
        }
        //if (command)
        {
            lastVC.pageCommand = command;
        }
        
        [self.navigationController popToViewController:lastVC animated:YES];
    }
}
-(void)popToPage:(NSString *)pageName params:(NSMutableDictionary *)params command:(NSString *)command
{
    NSMutableArray *arrayVC = self.navigationController.viewControllers;
    if (arrayVC.count >= 2)
    {
        PandroSuperViewController *lastVC = nil;//[arrayVC objectAtIndex:arrayVC.count - 2];
        for (int i=arrayVC.count -1; i>=0; i--)
        {
            PandroSuperViewController *viewCon = [arrayVC objectAtIndex:i];
            NSString *className = NSStringFromClass([viewCon class]);
            
            if ([className isEqualToString:pageName])
            {
                lastVC = viewCon;
                break;
            }
        }
        //if (params)
        {
            lastVC.pageParams = params;
        }
        //if (command)
        {
            lastVC.pageCommand = command;
        }
        
        [self.navigationController popToViewController:lastVC animated:YES];
    }
    
    //    [self.navigationController popViewControllerAnimated:YES];
}

@end
