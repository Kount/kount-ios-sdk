//
//  DebugMessages.h
//  KountDataCollector
//
//  Created by Felipe Plaza on 08-03-24.
//  Copyright © 2024 Kount Inc. All rights reserved.
//

#import "KDataCollector_Internal.h"

@interface DebugMessages : NSObject

+ (void)debugMessage:(NSString *)string isDebug:(BOOL)debug debugDelegate:(id<KDataCollectorDebugDelegate>)debugDelegate;

@end
