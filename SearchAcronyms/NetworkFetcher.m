//
//  NetworkFetcher.m
//  SearchAcronyms
//
//  Created by Venkat on 12/17/16.
//  Copyright © 2016 Venkat. All rights reserved.
//

#import "NetworkFetcher.h"

@implementation NetworkFetcher

+ (void) requestWith: (NSMutableURLRequest *)request andCompletionBlock:(dataCompletionBlock)completion {
    
    AFHTTPRequestOperation *JSONOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    JSONOperation.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    JSONOperation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    [JSONOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *dictData = (NSArray *)responseObject;
        
        if(completion) {
            completion(dictData, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self showAlertWithTitle:@"**** Error ****" message:@"Please try again with a different text" action:nil];
        
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
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    if(completion){
                        completion(nil, nil);
                    }
                }];
                [self showAlertWithTitle:@"No Internet Connection" message:@"Your internet connection appers to offline. Please try again later" action:action];
            }
                
                
                break;
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    
}

+ (UIViewController *) getTopViewController {
    
    UINavigationController *rootNavigationController = (UINavigationController*)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    if([rootNavigationController respondsToSelector:@selector(topViewController)]){
        return [rootNavigationController topViewController];
    }
    return rootNavigationController;
    
}

+ (void) showAlertWithTitle: (NSString *)title message: (NSString *)message action: (UIAlertAction *)action {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = action;
    if(action == nil){
        okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    }
    [alertController addAction:okAction];
    
    [[self getTopViewController] presentViewController:alertController animated:YES completion:nil];
    
}

@end
