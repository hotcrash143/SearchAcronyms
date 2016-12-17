//
//  AcronymViewModel.h
//  SearchAcronyms
//
//  Created by Venkat on 12/17/16.
//  Copyright © 2016 Venkat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkFetcher.h"

@interface AcronymViewModel : NSObject

@property (nonatomic, strong) NSString *acronymText;

-(instancetype) init;
-(void) getAcronymMeanings: (NSString *)acronymText withCompletionBlock:(dataCompletionBlock)completion;

@end
