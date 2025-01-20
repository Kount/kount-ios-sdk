//
//  KCollectorTaskBase.h
//  KountDataCollector
//
//  Created by Keith Feldman on 1/13/16.
//  Copyright © 2016 Kount Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDataCollector_Internal.h"

#ifdef DEBUG
#define KCOLLECTOR_DEBUG_MESSAGE(format, ...) [self debugMessage:[NSString stringWithFormat:format, ## __VA_ARGS__]];
#else
#define KCOLLECTOR_DEBUG_MESSAGE(format, ...)
#endif

NS_ASSUME_NONNULL_BEGIN

typedef void (^KCollectorTaskBaseCompletionBlock)(BOOL success, NSError *_Nullable error, NSDictionary *collectedData, NSDictionary *softErrors);

@protocol KDataCollectorDebugDelegate;

@interface KCollectorTaskBase : NSObject

// Display name for debugging and such
@property (readonly) NSString *name; 

// Internal name used to send to the server for soft errors
@property (readonly) NSString *internalName;

// Flag if this collector has finished
@property BOOL done;

// The session ID associated with this collection
@property (strong) NSString *sessionID;

// Delegate to be used for development to debug output
@property (assign, nullable) id<KDataCollectorDebugDelegate> debugDelegate;

// Overridden by the inherited classes to do the collection
- (void)collect; 

// Method called to start the collection with a completion block
- (void)collectForSession:(NSString *)sessionID completion:(KCollectorTaskBaseCompletionBlock)completionBlock debugDelegate:(nullable id<KDataCollectorDebugDelegate>)debugDelegate;

// Called by inherited classes when they are done to call the completion handler
- (void)callCompletionBlock:(BOOL)success error:(nullable NSError *)error;

// Add a data point to be sent to the endpoint
- (void)addDataPoint:(nonnull NSObject *)object forKey:(nonnull NSString *)key;

// Add a soft error to be send to the endpoint
- (void)addSoftError:(nonnull NSString *)error;

#ifdef DEBUG
- (void)debugMessage:(nonnull NSString *)message;
#endif

@end

NS_ASSUME_NONNULL_END
