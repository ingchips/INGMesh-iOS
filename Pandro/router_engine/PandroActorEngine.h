//
//  PandroActorEngine.h
//  Pandro
//
//  Created by chun on 2018/12/11.
//  Copyright © 2018年 chun. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface PandroActorEngine : NSObject

+(PandroActorEngine *)shareInstance;

+(void)engineStartActor:(NSString *)actorName  params:(NSMutableDictionary *)params callerObj:(NSObject *)object;
+(void)engineCancelActorFromOriginObject:(NSObject *)object;

@end


