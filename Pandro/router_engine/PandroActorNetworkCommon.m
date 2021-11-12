//
//  PandroActorNetworkCommon.m
//  Pandro
//
//  Created by chun on 2018/12/13.
//  Copyright © 2018年 chun. All rights reserved.
//

#import "PandroActorNetworkCommon.h"

@implementation PandroActorNetworkCommon

-(void)actorProcess
{
    NSString *urlString = @"https://www.baidu.com";
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url] returningResponse:nil error:&error];
    sleep(10);
    self.processFailedError = [[NSError alloc] init];
}
@end
