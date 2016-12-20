//
//  AcronymViewController.h
//  SearchAcronyms
//
//  Created by Venkat on 12/17/16.
//  Copyright © 2016 Venkat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AcronymViewModel.h"
#import "UICoordinator.h"

@interface AcronymViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *acronymTextField;
@property (weak, nonatomic) IBOutlet UITableView *acronymMeaningsTableView;


- (IBAction)acronymSearch:(id)sender;
@end

