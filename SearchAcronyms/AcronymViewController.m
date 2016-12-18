//
//  AcronymViewController.m
//  SearchAcronyms
//
//  Created by Venkat on 12/17/16.
//  Copyright © 2016 Venkat. All rights reserved.
//

#import "AcronymViewController.h"

@interface AcronymViewController ()

@property (nonatomic, strong) NSArray *acronymMeaningsArray;
@property (nonatomic, strong) AcronymViewModel *viewModel;

@end

@implementation AcronymViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.acronymMeaningsArray = [[NSArray alloc] init];
    self.viewModel = [[AcronymViewModel alloc] init];
    [self.acronymTextField becomeFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.acronymMeaningsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.acronymMeaningsTableView dequeueReusableCellWithIdentifier:@"acronymCell"];
    cell.textLabel.text = self.acronymMeaningsArray[indexPath.row];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,30)];
    headerView.backgroundColor=[UIColor grayColor];
    headerView.layer.borderColor=[UIColor blackColor].CGColor;
    headerView.layer.borderWidth=1.0f;
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10,100,20)];
    leftLabel.textAlignment = NSTextAlignmentRight;
    leftLabel.text = self.acronymTextField.text;
    leftLabel.textColor = [UIColor whiteColor];
    leftLabel.backgroundColor = [UIColor clearColor];
    
    [headerView addSubview:leftLabel];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, headerView.frame.size.width-120.0, headerView.frame.size.height)];
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.text = [NSString stringWithFormat:@"Count - %lu", (unsigned long)self.acronymMeaningsArray.count];
    rightLabel.textColor=[UIColor whiteColor];
    rightLabel.backgroundColor = [UIColor clearColor];
    
    [headerView addSubview:rightLabel];
    
    return headerView;
    
}

- (IBAction)acronymSearch:(id)sender {
    
    if(self.acronymTextField.text.length > 0){
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.viewModel setAcronymText:self.acronymTextField.text];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self.viewModel getAcronymMeanings:self.acronymTextField.text withCompletionBlock:^(id meaningsArray, NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.acronymMeaningsArray = (NSArray *)meaningsArray;
                    [self.acronymMeaningsTableView reloadData];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            }];
        });
    }
    else {
        [NetworkFetcher showAlertWithTitle:@"**** Warning ****" message:@"Please enter text to search" action:nil];
    }
}

@end
