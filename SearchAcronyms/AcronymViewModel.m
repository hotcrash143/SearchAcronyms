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
    
    [NetworkFetcher requestWith:request andCompletionBlock:^(id data, NSError *error) {
        
        [self resetAcronymSet];
        
        NSArray *arrayData = (NSArray *)data;
        if([arrayData count] > 0){
            [self loadSetFromArrayData:arrayData];
            completion(self.acronymMeaningsSet, nil);
        }
        else if ([arrayData count] == 0 && !error){
            NSError *noDataError = nil;
            noDataError = [NSError errorWithDomain:@"SearchAcronymErrors" code:1 userInfo:nil];
            completion(nil, noDataError);
        }
        else{
            completion(nil, error);
        }
    }];
    
    
}


-(void) loadSetFromArrayData:(NSArray *)data {
    
    for (NSDictionary *outerDict in [data[0] objectForKey:@"lfs"]) {
        
        [self.acronymMeaningsSet addObject:[outerDict objectForKey:@"lf"]];
        
        for (NSDictionary *innerVarsDict in [outerDict objectForKey:@"vars"]) {
            
            [self.acronymMeaningsSet addObject:[innerVarsDict objectForKey:@"lf"]];
            
        }
    }
}

-(void) resetAcronymSet {
    
    [self.acronymMeaningsSet removeAllObjects];
}


@end
