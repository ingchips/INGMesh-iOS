//
//  LampDeviceAddViewController.m
//  Pandro
//
//  Created by chun on 2019/2/28.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "LampDeviceAddViewController.h"
#import "LampDeviceAddSearchingView.h"
#import "LampDeviceAddSearchNilView.h"
#import "LampDeviceAddListView.h"
#import "LampDeviceAddConnectingView.h"
#import "LampDeviceAddConnectFailView.h"
#import "LampDeviceAddConnectSuccView.h"

#import "PandroBlueToothManager.h"
#import "PandroBlueToothMeshMgrBridge.h"
#import "PandroBlueToothMeshMgrOC.h"

@interface LampDeviceAddViewController ()
{
    CGRect contentRect;
    BOOL searchResult;
}

@property(nonatomic, strong)NSMutableArray *connectDeviceArray;

@property(nonatomic, strong)LampDeviceAddSearchingView *searchIngView;
@property(nonatomic, strong)LampDeviceAddSearchNilView *searchFailView;
@property(nonatomic, strong)LampDeviceAddListView *searchListView;

@property(nonatomic, strong)LampDeviceAddConnectingView *connectingView;
@property(nonatomic, strong)LampDeviceAddConnectFailView *connectFailView;
@property(nonatomic, strong)LampDeviceAddConnectSuccView *connectSucceedView;


@property(nonatomic, strong)NSTimer *searchTimer;

@end

@implementation LampDeviceAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
    PandroBlueToothManager *blueToothMgr = [PandroBlueToothManager shareInstance];
    blueToothMgr.delegate = self;
    [blueToothMgr scanBlueTooth];
    */
    
    [self showNavBarTitle:@"智能灯组"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    contentRect = CGRectMake(0, self.navBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navBar.frame.size.height);
    
    
    [self.view bringSubviewToFront:self.searchIngView];
    
    searchResult = NO;
    __weak typeof(self) weakSelf = self;
    
    [[PandroBlueToothMeshMgrOC shareInstance] startScan];
    [PandroBlueToothMeshMgrBridge shareInstance].delegate = self;
    
    [self startSearchTimeout];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logDevice:) name:@"logDevice" object:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[PandroBlueToothMeshMgrOC shareInstance] stopScan];

}
-(void) logDevice:(NSNotification *)notification
{
    NSString *logDeviceStr = notification.userInfo[@"log"];

    __weak __typeof(self) weakself= self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakself.connectingView.labLog.text = [NSString stringWithFormat:@"%@\n%@",weakself.connectingView.labLog.text,logDeviceStr];
    });
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark connect function
-(void)clickDirectGoto:(UIButton *)btn
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:0], nil];
    [self clickConnectDevice:array];

}

-(void)clickTryConnectAgain:(UIButton *)btn
{
    [self clickConnectDevice:self.connectDeviceArray];
}

-(void)clickConnectDevice:(NSMutableArray *)deviceArray
{
    self.connectDeviceArray = deviceArray;
    
    [self.connectingView setHidden:NO];
    [self.view bringSubviewToFront:self.connectingView];
    
    [[PandroBlueToothMeshMgrOC shareInstance] connectMeshNodeArray:self.connectDeviceArray];
}

#pragma mark search function
-(void)startSearchTimeout
{
    __weak typeof(self) weakSelf = self;
    self.searchTimer = [NSTimer scheduledTimerWithTimeInterval:30 repeats:NO block:^(NSTimer * _Nonnull timer) {
        //
        searchResult = NO;
        
        [weakSelf processSearchNext];
        
    }];
}

-(void)clickTrySearchAgain:(UIButton *)btn
{
    [self.searchIngView setHidden:NO];
    [self.view bringSubviewToFront:self.searchIngView];
    [[PandroBlueToothMeshMgrOC shareInstance] stopScan];
    [[PandroBlueToothMeshMgrOC shareInstance] startScan];
    [self startSearchTimeout];
}

-(void)processSearchNext
{
    if (!searchResult)
    {
        [self.searchFailView setHidden:NO];
        [self.view bringSubviewToFront:self.searchFailView];
    }
    else
    {
        [self.searchListView setHidden:NO];
        [self.searchListView showBlueToothDeviceContent];
        [self.view bringSubviewToFront:self.searchListView];
    }
}
#pragma mark PandroBlueToothMeshMgrBridgeDelegate

-(void)blueToothDevicesHasFinded
{
    [self.searchTimer invalidate];
    self.searchTimer = nil;
    
    searchResult = YES;
    [self processSearchNext];
}

-(void)blueToothDevicesMeshProxySucceed
{
    [self.connectSucceedView setHidden:NO];
    [self.view bringSubviewToFront:self.connectSucceedView];
    __weak typeof(self) weakSelf = self;
    [NSTimer scheduledTimerWithTimeInterval:2 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [weakSelf.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count-2] animated:YES];
//        [weakSelf gotoPage:PAGE_LAME_MESH_HOME_VC params:nil command:@"init"];
    }];
}

-(void)blueToothDevicesMeshProxyFailed
{
    [self.connectFailView setHidden:NO];
    [self.view bringSubviewToFront:self.connectFailView];
}


#pragma mark PandroBlueTooth delgeate
-(void)discoverBlueDevice:(CBPeripheral *)peripheral
{
    //[self.searchArray addObject:peripheral];
}

#pragma mark getter and setter
-(LampDeviceAddSearchingView *)searchIngView
{
    if (!_searchIngView)
    {
        CGRect rect = CGRectMake(0, self.navBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        _searchIngView = [[LampDeviceAddSearchingView alloc] initWithFrame:contentRect];
        [self.view addSubview:_searchIngView];
    }
    
    return _searchIngView;
}

-(LampDeviceAddSearchNilView *)searchFailView
{
    if (!_searchFailView)
    {
        _searchFailView = [[LampDeviceAddSearchNilView alloc] initWithFrame:contentRect];
        [self.view addSubview:_searchFailView];
    }
    return _searchFailView;
}

-(LampDeviceAddListView *)searchListView
{
    if (!_searchListView)
    {
        _searchListView = [[LampDeviceAddListView alloc] initWithFrame:contentRect];
        [self.view addSubview:_searchListView];
    }
    return _searchListView;
}

-(LampDeviceAddConnectingView *)connectingView
{
    if (!_connectingView)
    {
        _connectingView = [[LampDeviceAddConnectingView alloc] initWithFrame:contentRect];
        [self.view addSubview:_connectingView];
    }
    return _connectingView;
}

-(LampDeviceAddConnectFailView *)connectFailView
{
    if (!_connectFailView)
    {
        _connectFailView = [[LampDeviceAddConnectFailView alloc] initWithFrame:contentRect];
        [self.view addSubview:_connectFailView];
    }
    return _connectFailView;
}

-(LampDeviceAddConnectSuccView *)connectSucceedView
{
    if (!_connectSucceedView)
    {
        _connectSucceedView = [[LampDeviceAddConnectSuccView alloc] initWithFrame:contentRect];
        [self.view addSubview:_connectSucceedView];
    }
    return _connectSucceedView;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"logDevice" object:self];

}
@end
