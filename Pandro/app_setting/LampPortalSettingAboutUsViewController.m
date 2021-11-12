//
//  LampPortalSettingAboutUsViewController.m
//  Pandro
//
//  Created by chun on 2019/1/22.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "LampPortalSettingAboutUsViewController.h"

@interface LampPortalSettingAboutUsViewController ()

@property(nonatomic, strong)UIImageView *imgView;
@property(nonatomic, strong)UILabel *versionLabel;

@end

@implementation LampPortalSettingAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showNavBarTitle:@"关于我们"];
    
    [self.view addSubview:self.imgView];
    
    float width = 80;
    self.imgView.frame = CGRectMake((self.view.frame.size.width-80)/2, (self.view.frame.size.height - 80)/2 - width/2, 80, 80);
    [self.view addSubview:self.versionLabel];
    
    float topOffset = self.imgView.frame.size.height + self.imgView.frame.origin.y;
    
    self.versionLabel.frame = CGRectMake(0, topOffset , self.view.frame.size.width, 70);
    NSString *version = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"INGCHIPS\r\n智能家居生活管家\r\n\r\n%@", version];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark setter and getter

-(UIImageView *)imgView
{
    if (!_imgView)
    {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgView.image = [UIImage loadImageWithName:@"app_about_icon"];
    }
    return _imgView;
}

-(UILabel *)versionLabel
{
    if (!_versionLabel)
    {
        _versionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _versionLabel.backgroundColor = [UIColor clearColor];
        _versionLabel.font = [UIFont systemFontOfSize:13];
        _versionLabel.textColor = [UIColor colorWithHexString:@"999999FF"];
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        _versionLabel.numberOfLines = 0;
    }
    
    return _versionLabel;
}

@end
