//
//  INGPortalViewController.m
//  Pandro
//
//  Created by chun on 2019/2/27.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "INGPortalViewController.h"

@interface INGPortalViewController ()

@end

@implementation INGPortalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navBar setHidden:YES];
    
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
    //background
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    imageView.image = [UIImage loadImageWithName:@"app_home_bg"];
    
    [self.view addSubview:imageView];
    
    //setting
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn setImage:[UIImage loadImageWithName:@"app_setting"] forState:UIControlStateNormal];
    settingBtn.frame = CGRectMake(self.view.frame.size.width - 54, 30, 44, 44);
    [settingBtn addTarget:self action:@selector(clickSetting:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:settingBtn];
    
    float topOffset = 200;
    float height = 90;
    float offset = 15;
    for (int i=0; i<1; i++)
    {
        CGRect rect = CGRectMake(offset, topOffset + (height + offset) * i, self.view.frame.size.width - 2 * offset, height);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = rect;
        [self.view addSubview:btn];
        NSString *tipText = @"智能灯组";
        NSString *imageName = @"app_home_lamp";
        if (i == 1)
        {
            imageName = @"app_home_lock";
            tipText = @"场景二";
        }
        else if (i == 2)
        {
            imageName = @"app_home_cloth";
            tipText = @"场景三";
        }
        [btn setImage:[UIImage loadImageWithName:imageName] forState:UIControlStateNormal];
        
        rect = CGRectMake(btn.frame.size.width - 100, 0, 100, height);
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:rect];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.textColor = [UIColor blackPandroColor];
        tipLabel.font = [UIFont systemFontOfSize:16];
        tipLabel.text = tipText;
        [btn addSubview:tipLabel];
        
        if (i == 0)
        {
            [btn addTarget:self action:@selector(clickGotoLamp:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
//            not pop up this indication for app store release
//            [btn addTarget:self action:@selector(clickGotoOther:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    //header2 label
    {
        rect = CGRectMake(30, 75, self.view.frame.size.width, 100);
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:rect];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.font = [UIFont systemFontOfSize:20];
        tipLabel.numberOfLines = 0;
        tipLabel.text = @"Hi~ 欢迎使用\r\n INGCHIPS 智能生活管家";
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tipLabel.text];
        
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 10.0;
        
        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:paragraphStyle
                                 range:NSMakeRange(0, attributedString.length)];
        
        tipLabel.attributedText = attributedString;
        
        [self.view addSubview:tipLabel];
    }
    
    //bottom label
    {
        rect = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 15);
        UILabel *bottomLabel = [[UILabel alloc] initWithFrame:rect];
        bottomLabel.backgroundColor = [UIColor clearColor];
        bottomLabel.textColor = [UIColor colorWithHexString:@"A9AEBDFF"];
        bottomLabel.font = [UIFont systemFontOfSize:10];
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        bottomLabel.text = @"智能家居生活管家";
        [self.view addSubview:bottomLabel];
    }
    
}

#pragma mark click
-(void)clickSetting:(UIButton *)btn
{
    [self gotoPage:PAGE_LAME_PORTAL_SET_VC params:nil command:@"init"];
}

-(void)clickGotoLamp:(UIButton *)btn
{
    [self gotoPage:PAGE_LAME_MESH_HOME_VC params:nil command:@"init"];
}

-(void)clickGotoOther:(UIButton *)btn
{
    [self.view showAnimationTip:@"敬请期待" topOffset:0];
}

@end
