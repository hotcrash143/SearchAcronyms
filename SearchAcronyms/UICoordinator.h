//
//  UICoordinator.h
//  SearchAcronyms
//
//  Created by Venkat on 12/19/16.
//  Copyright © 2016 Venkat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UICoordinator : NSObject

+ (instancetype)sharedInstance;
- (void) showAlertWithError:(NSError *)error action: (UIAlertAction *)action;

@end
