//
//  PostRequest.m
//  KountDataCollector
//
//  Created by Vamsi Krishna on 27/08/20.
//  Copyright © 2020 Kount Inc. All rights reserved.
//

#import "PostRequest.h"

@implementation PostRequest

// MARK: POST Request Method

//Posting payload to server.
- (void)postingDataToServer:(NSData *)postData postURL:(NSString *)postEnvironmentURL {
    
    BOOL debug = [[KDataCollector sharedCollector] debug];//DMD-750
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:postEnvironmentURL]
      cachePolicy:NSURLRequestUseProtocolCachePolicy
      timeoutInterval:10.0];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:postData];

    [request setHTTPMethod:@"POST"];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            if (debug) {
                NSLog(@"%@", error);
                NSError *parseError = nil;
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:postData options:0 error:&parseError];
                NSLog(@"%@",responseDictionary);
            }
        }
        else {
            if (debug) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                NSLog(@"%@",httpResponse);
                NSError *parseError = nil;
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:postData options:0 error:&parseError];
                NSLog(@"%@",responseDictionary);
            }
            dispatch_semaphore_signal(sema);
        }
    }];
    [dataTask resume];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_NOW);
}

@end
