//
//  FirstViewController.m
//  Pandro
//
//  Created by chun on 2018/12/13.
//  Copyright © 2018年 chun. All rights reserved.
//

#import "FirstViewController.h"
#import "PandroBlueToothManager.h"
#import "MeshPlaceDatabase.h"
//#import "MeshMainControlMenuView.h"
#import "PandroEngine.h"
#import "LampDeviceSetColorView.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    [self showNavBarTitle:@"first"];

    self.view.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    CGRect rect = CGRectMake(50, 100, self.view.frame.size.width - 100, 50);
    PandroSliderView *sliderView = [[PandroSliderView alloc] initWithFrame:rect];
    [self.view addSubview:sliderView];
    
    /*
    CGRect rect = CGRectMake(50, 300, 300, 100);
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:rect];
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 2.0f);
    progressView.transform = transform;//设定宽高
    progressView.backgroundColor = [UIColor grayColor];
    progressView.tintColor = [UIColor redColor];
    progressView.progressViewStyle = UIProgressViewStyleBar;
    progressView.progressImage = [UIImage loadImageWithName:@"lamp_device_set_cold_1"];
    [self.view addSubview:progressView];
    progressView.progress = 0.6;
    
    */
    
//    return;
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 100, 100, 100);
    [btn setTitle:@"goto" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    
    
    [btn addTarget:self action:@selector(clickGoto) forControlEvents:UIControlEventTouchUpInside];
    
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 200, 100, 100);
        [btn setTitle:@"actor" forState:UIControlStateNormal];
        [self.view addSubview:btn];
        
        
        [btn addTarget:self action:@selector(clickActor) forControlEvents:UIControlEventTouchUpInside];
    }
    
    {
        CGRect  rect = CGRectMake(0, 300, 50, 50);
        UIView *view = [[UIView alloc] initWithFrame:rect];
        [self.view addSubview:view];
        
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        imgView.tintColor = [UIColor whiteColor];
        imgView.image = nil;
        [view addSubview:imgView];
        UIImage *image = [[UIImage loadImageWithName:@"ic_setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        imgView.image = image;
        
    }
    
    {
        CGRect rect = CGRectMake(0, 400, self.view.frame.size.width, self.view.frame.size.height-400);
        LampDeviceSetColorView *colorView = [[LampDeviceSetColorView alloc] initWithFrame:rect];
        [self.view addSubview:colorView];
        
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *command = [self pageCommand];
    NSString *paras = [self pageParams];
    
    NSLog(@"");
    
}

-(void)clickLeftBtn
{
    //[self popPage:nil command:nil];
    //[MeshMainControlMenuView showMenuViewInView:self.view];
    
    [self gotoPage:PAGE_GC_COLOR_SEL_VIEWCONTROLLER params:nil command:@"init"];
}

-(void)clickGoto
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"1548053092495" forKey:@"placeId"];
    
    [self gotoPage:PAGE_LAME_GROUP_SET_VC params:dict command:@"init"];
    
    //[self gotoPage:PAGE_DEVICE_LIST_VIEWCONTROLLER params:dict command:@"init"];
    
    //[self gotoPage:PAGE_AREA_LIST_VIEWCONTROLLER params:dict command:@"init"];
    
    //[self gotoPage:PAGE_PLACE_ADD_VIEWCONTROLLER params:nil command:@"init"];
    //[self gotoPage:PAGE_PLACE_LIST_VIEWCONTROLLER params:nil command:@"init"];
    
    
}

-(void)clickActor
{
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"m.taobao.buy" forKey:@"api"];
    //[self startActor:ACTOR_NETWORK_API_TAOBAO params:dict];
}

-(void)actorDidSucceed:(PandroActorSuperActor *)actor actorName:(NSString *)actorName params:(NSMutableDictionary *)params result:(id)result
{
    
}

-(void)actorDidFailed:(PandroActorSuperActor *)actor actorName:(NSString *)actorName params:(NSMutableDictionary *)params error:(NSError *)error
{
    
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
