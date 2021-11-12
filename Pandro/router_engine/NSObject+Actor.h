//
//  NSObject+Actor.h
//  Pandro
//
//  Created by chun on 2018/12/11.
//  Copyright © 2018年 chun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PandroActorNameConfig.h"
#import "PandroActorSuperActor.h"


@interface NSObject (Actor)

-(void)startActor:(NSString *)actorName params:(NSMutableDictionary *)params;
-(void)cancelAllActor;


-(void)actorDidSucceed:(PandroActorSuperActor *)actor actorName:(NSString *)actorName params:(NSMutableDictionary *)params result:(id)result;
-(void)actorDidFailed:(PandroActorSuperActor *)actor actorName:(NSString *)actorName params:(NSMutableDictionary *)params error:(NSError *)error;

@end

