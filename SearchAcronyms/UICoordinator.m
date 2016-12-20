//
//  UICoordinator.m
//  SearchAcronyms
//
//  Created by Venkat on 12/19/16.
//  Copyright © 2016 Venkat. All rights reserved.
//

#import "UICoordinator.h"

@implementation UICoordinator {
    NSDictionary *errorDict;
}

+ (instancetype)sharedInstance
{
    static UICoordinator *sharedInst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInst = [[UICoordinator alloc] init];
    });
    return sharedInst;
}


- (id)init
{
    self = [super init];
    if (self) {
        errorDict = [self getContentsofPlist];
    }
    return self;
}

- (NSDictionary *) getContentsofPlist {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Error" ofType:@"plist"];
    errorDict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    return errorDict;
}



- (UIViewController *) getTopViewController {
    
    UINavigationController *rootNavigationController = (UINavigationController*)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    if([rootNavigationController respondsToSelector:@selector(topViewController)]){
        return [rootNavigationController topViewController];
    }
    return rootNavigationController;
    
}

- (void) showAlertWithError:(NSError *)error action: (UIAlertAction *)action  {
    
    NSString *errorCodeString = [NSString stringWithFormat:@"%ld", (long)error.code];
    NSDictionary *errorCodeDict = [[errorDict objectForKey:@"SearchAcronymErrors"] objectForKey:errorCodeString];
    NSString *title, *message;
    
    if([errorCodeString isEqualToString:@"2"]) {
        errorCodeDict = [[errorDict objectForKey:@"SearchAcronymErrors"] objectForKey:[NSString stringWithFormat:@"%ld", (long)2]];
    }
    
    title = [errorCodeDict objectForKey:@"errorHeading"];
    message = [errorCodeDict  objectForKey:@"errorString"];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = action;
    if(okAction == nil){
        okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    }
    [alertController addAction:okAction];
    
    [[self getTopViewController] presentViewController:alertController animated:YES completion:nil];
    
}



@end
