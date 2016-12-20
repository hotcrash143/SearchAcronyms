//
//  NetworkFetcher.m
//  SearchAcronyms
//
//  Created by Venkat on 12/17/16.
//  Copyright © 2016 Venkat. All rights reserved.
//

#import "NetworkFetcher.h"
#import "AcronymViewModel.h"

@implementation NetworkFetcher

+ (void) requestWith: (NSMutableURLRequest *)request andCompletionBlock:(dataCompletionBlock)completion {
    
    AFHTTPRequestOperation *JSONOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    JSONOperation.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    JSONOperation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    [JSONOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(completion) {
            completion(responseObject, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(completion) {
            completion(nil, error);
        }
        
    }];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [JSONOperation start];
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
            {
                NSError *noInternetError = [NSError errorWithDomain:@"SearchAcronymErrors" code:0 userInfo:nil];
                if(completion) {
                    completion(nil, noInternetError);
                }
            }
                break;
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

@end
