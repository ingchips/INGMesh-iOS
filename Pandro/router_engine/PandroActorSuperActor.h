//
//  PandroActorSuperActor.h
//  Pandro
//
//  Created by chun on 2018/12/11.
//  Copyright © 2018年 chun. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PandroActorSuperActor : NSObject

@property(nonatomic, copy)NSString *actorName;
@property(nonatomic, strong)NSMutableDictionary *originParams;
@property(nonatomic, weak)NSObject *originObject;
@property(nonatomic, weak)NSThread *originThread;

@property(nonatomic)BOOL isCancel;

@property(nonatomic, strong)NSError *processFailedError;
@property(nonatomic, strong)NSObject *processSucceedResult;

-(void)actorProcess;

@end

