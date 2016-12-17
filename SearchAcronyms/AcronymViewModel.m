//
//  AcronymViewModel.m
//  SearchAcronyms
//
//  Created by Venkat on 12/17/16.
//  Copyright © 2016 Venkat. All rights reserved.
//

#import "AcronymViewModel.h"

@interface AcronymViewModel ()

@property (nonatomic, strong) NSMutableOrderedSet *acronymMeaningsSet;

@end

@implementation AcronymViewModel

-(instancetype) init {
    
    self = [super init];
    
    if(self != nil) {
        self.acronymMeaningsSet = [[NSMutableOrderedSet alloc] init];
    }
    
    return self;
}


-(void) getAcronymMeanings: (NSString *)acronymText withCompletionBlock:(dataCompletionBlock)completion {
    
    NSString *baseString = @"http://www.nactem.ac.uk/software/acromine/dictionary.py";
    NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@?sf=%@", baseString, self.acronymText]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    [NetworkFetcher requestWith:request andCompletionBlock:^(NSArray *data, NSError *error) {
        
        [self resetAcronymSet];
        
        if([data count] > 0){
            [self loadSetFromDictionary:data];
        }
        if(completion) {
            NSArray *finalList = [self.acronymMeaningsSet count] > 0 ? [self.acronymMeaningsSet array] : nil;
            completion(finalList, nil);
        }
    }];
    
    
}


-(void) loadSetFromDictionary:(NSArray *)data {
    
    NSAssert([self.acronymText caseInsensitiveCompare:[data[0] objectForKey:@"sf"]] == NSOrderedSame, @"Error during Parsing");
    
    for (NSDictionary *outerDict in [data[0] objectForKey:@"lfs"]) {
        
        for (NSDictionary *innerVarsDict in [outerDict objectForKey:@"vars"]) {
            
            [self.acronymMeaningsSet addObject:[innerVarsDict objectForKey:@"lf"]];
            
        }
    }
}

-(void) resetAcronymSet {
    
    [self.acronymMeaningsSet removeAllObjects];
}

@end
