//
//  NSObject+Actor.m
//  Pandro
//
//  Created by chun on 2018/12/11.
//  Copyright © 2018年 chun. All rights reserved.
//

#import "NSObject+Actor.h"
#import "PandroActorEngine.h"

@implementation NSObject (Actor)

-(void)startActor:(NSString *)actorName params:(NSMutableDictionary *)params
{
    
    [PandroActorEngine engineStartActor:actorName params:params callerObj:self];
    
}
-(void)cancelAllActor
{
    [PandroActorEngine engineCancelActorFromOriginObject:self];
}


-(void)actorDidSucceed:(PandroActorSuperActor *)actor actorName:(NSString *)actorName params:(NSMutableDictionary *)params result:(id)result
{
    
}

-(void)actorDidFailed:(PandroActorSuperActor *)actor actorName:(NSString *)actorName params:(NSMutableDictionary *)params error:(NSError *)error
{
    
}

@end
