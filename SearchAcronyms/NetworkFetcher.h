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

+ (void) requestWith: (NSMutableURLRequest *)request andCompletionBlock:(dataCompletionBlock)completion;
+ (void) showAlertWithTitle: (NSString *)title message: (NSString *)message action: (UIAlertAction *)action;

@end
