//
//  KCollectorTaskBase.m
//  KountDataCollector
//
//  Created by Keith Feldman on 1/13/16.
//  Copyright © 2016 Kount Inc. All rights reserved.
//

#import "KCollectorTaskBase.h"

@interface KCollectorTaskBase ()
@property (copy) KCollectorTaskBaseCompletionBlock completionBlock;
@property (strong) NSMutableDictionary *data;
@property (strong) NSMutableDictionary *softErrors;
@end

#pragma mark

@implementation KCollectorTaskBase

- (id)init 
{
    self = [super init];
    if (self) {
        self.data = [NSMutableDictionary dictionary];
        self.softErrors = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark Data Collection

- (void)collectForSession:(NSString *)sessionID completion:(KCollectorTaskBaseCompletionBlock)completionBlock debugDelegate:(id<KDataCollectorDebugDelegate>)debugDelegate 
{
    NSAssert(self.internalName != nil, @"internalName is nil!");
    NSAssert(self.name != nil, @"name is nil!");
    NSAssert(completionBlock != nil, @"completeBlock is nil!");
    NSAssert(sessionID != nil, @"sessionID is nil!");
    self.completionBlock = completionBlock;
    self.sessionID = sessionID;
    self.debugDelegate = debugDelegate;
    self.done = NO;
    KCOLLECTOR_DEBUG_MESSAGE(@"Starting");
    if (self.debugDelegate && [self.debugDelegate respondsToSelector:@selector(collectorStarted:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.debugDelegate collectorStarted:self.name];
        });
    }
    [self collect];
}

- (void)callCompletionBlock:(BOOL)success error:(NSError *)error 
{
    KCOLLECTOR_DEBUG_MESSAGE(@"Completed with %@", success ? @"Success" : @"Failure");
    self.done = YES;
    if (self.debugDelegate && [self.debugDelegate respondsToSelector:@selector(collectorDone:success:error:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.debugDelegate collectorDone:self.name success:success error:error];
        });
    }
    if (!success) {
        if (error) {
            KCOLLECTOR_DEBUG_MESSAGE(@"ERROR (%ld): %@", (long)error.code, error.localizedDescription);
        }
    }
  
/* Begin KIOS-53 - Comment the below code for debug mode as it is generating a custom error everytime completion block is called.
#ifdef DEBUG
#if defined(_NSAssertBody)
    NSString *assertString = [NSString stringWithFormat:@"Handler called twice in same collector (%@)", self.name];
    NSAssert(self.completionBlock != nil, assertString);
#endif
#endif
KIOS-53 End */
    
    if (self.completionBlock) {
        self.completionBlock(success, error, self.data, self.softErrors);
        self.completionBlock = nil; // Clear out the completionBlock since it should only be called once
    }
}

- (void)collect 
{
    NSAssert(NO, @"Collect not implemented by collector.");
}

#pragma mark Data & Error Handling

- (void)addDataPoint:(NSObject *)object forKey:(NSString *)key 
{
    if ([object isKindOfClass:[NSString class]]) {
        [self.data setObject:object forKey:key];
    }
    else if ([object isKindOfClass:[NSNumber class]]) {
        NSNumber *number = (NSNumber *)object;
        [self.data setObject:[number stringValue] forKey:key];
    }
    else {
        NSAssert(NO, @"Invalid Data Point");
    }
}

- (void)addSoftError:(NSString *)error
{
    [self.softErrors setObject:error forKey:self.internalName];
}

#pragma mark Debug Messaging

#ifdef DEBUG
- (void)debugMessage:(NSString *)message 
{
    if (self.debugDelegate) {
        if ([self.debugDelegate respondsToSelector:@selector(collectorDebugMessage:)]) {
            NSString *modifiedMessage = [NSString stringWithFormat:@"(%@) <%@> %@", self.sessionID, self.name, message];
            NSLog(@"%@", modifiedMessage);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.debugDelegate collectorDebugMessage:modifiedMessage];
            });
        }
    }
}
#endif

@end
