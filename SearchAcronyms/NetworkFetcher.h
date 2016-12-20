//
//  NetworkFetcher.h
//  SearchAcronyms
//
//  Created by Venkat on 12/17/16.
//  Copyright © 2016 Venkat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>

typedef void (^dataCompletionBlock)(id data, NSError *error);

@interface NetworkFetcher : NSObject

extern NSString *noInternetErrorDomain;
extern NSString *noDataFoundErrorDomain;

+ (void) requestWith: (NSMutableURLRequest *)request andCompletionBlock:(dataCompletionBlock)completion;

@end
