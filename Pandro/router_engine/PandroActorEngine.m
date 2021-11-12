//
//  PandroActorEngine.m
//  Pandro
//
//  Created by chun on 2018/12/11.
//  Copyright © 2018年 chun. All rights reserved.
//

#import "PandroActorEngine.h"
#import "PandroActorSuperActor.h"
#import "NSObject+Actor.h"

@interface PandroActorEngine ()

@property(nonatomic, strong)NSRecursiveLock *lock;
@property(nonatomic, strong)NSMutableArray *actorArrays;
@property(nonatomic, strong)NSOperationQueue *operationQueue;

@end

@implementation PandroActorEngine


+(PandroActorEngine *)shareInstance
{
    static PandroActorEngine *shareEngeerMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareEngeerMgr = [[PandroActorEngine alloc] init];
    });
    return shareEngeerMgr;
}

-(id)init
{
    self = [super init];
    
    _lock = [[NSRecursiveLock alloc] init];
    _operationQueue = [[NSOperationQueue alloc] init];
    [_operationQueue setMaxConcurrentOperationCount:15];
    
    self.actorArrays = [[NSMutableArray alloc] init];
    
    return self;
}

+(void)engineCancelActorFromOriginObject:(NSObject *)object
{
    PandroActorEngine *shareEngine = [PandroActorEngine shareInstance];
    
    [shareEngine.lock lock];
    
    for (int i=0; i<shareEngine.actorArrays.count; i++)
    {
        PandroActorSuperActor *actor = [shareEngine.actorArrays objectAtIndex:i];
        if ([actor.originObject isEqual:object])
        {
            actor.isCancel = YES;
        }
    }
    
    [shareEngine.lock unlock];
}

+(void)engineStartActor:(NSString *)actorName  params:(NSMutableDictionary *)params callerObj:(NSObject *)object
{
    Class className = NSClassFromString(actorName);
    PandroActorSuperActor *actorObj = [[className alloc] init];
    
    if (!actorObj || ![actorObj isKindOfClass:[PandroActorSuperActor class]])
    {
        return;
    }
    actorObj.originObject = object;
    actorObj.originThread = [NSThread currentThread];
    actorObj.originParams = params;
    actorObj.actorName = actorName;
    
    [[PandroActorEngine shareInstance] engineStartActorInner:actorObj];
    
}

-(void)engineStartActorInner:(PandroActorSuperActor *)actor
{
    
    [self addActor:actor];
    
    __weak PandroActorEngine *weakSelf = self;
    
    [self.operationQueue addOperationWithBlock:^{
        [weakSelf engineStartActorInnerBlock:actor];
    }];
}

-(void)engineStartActorInnerBlock:(PandroActorSuperActor *)actor
{
    if (actor.isCancel)
    {
        [self deleteActor:actor];
        return;
    }
    
    [actor actorProcess];
    
    [self performSelector:@selector(actorHasProcessed:) onThread:actor.originThread withObject:actor waitUntilDone:NO];
    
}

-(void)actorHasProcessed:(PandroActorSuperActor *)actor
{
    if (actor.processFailedError)
    {
        [actor.originObject actorDidFailed:actor actorName:actor.actorName params:actor.originParams error:actor.processFailedError];
    }
    else
    {
        [actor.originObject actorDidSucceed:actor actorName:actor.actorName params:actor.originParams result:actor.processSucceedResult];
    }
}

-(void)addActor:(PandroActorSuperActor *)actor
{
    [_lock lock];
    
    [self.actorArrays addObject:actor];
    
    [_lock unlock];
}
-(void)deleteActor:(PandroActorSuperActor *)actor
{
    [_lock lock];
    
    [self.actorArrays removeObject:actor];
    
    [_lock unlock];
}


@end
