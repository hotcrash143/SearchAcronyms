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

@implementation AcronymViewController {
    UIImageView *imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.acronymMeaningsArray = [[NSArray alloc] init];
    self.viewModel = [[AcronymViewModel alloc] init];
    self.acronymTextField.delegate = self;
    self.acronymMeaningsTableView.separatorColor = [UIColor blackColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BGImage"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.acronymMeaningsTableView setFrame:self.acronymMeaningsTableView.frame];
    self.acronymMeaningsTableView.backgroundView = imageView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.acronymMeaningsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.acronymMeaningsTableView dequeueReusableCellWithIdentifier:@"acronymCell"];
    if(!cell){
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"acronymCell"];
    }
    cell.textLabel.text = self.acronymMeaningsArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Count - %lu", (unsigned long)self.acronymMeaningsArray.count];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.acronymTextField becomeFirstResponder];
}

- (IBAction)acronymSearch:(id)sender {
    
    if(self.acronymTextField.text.length > 0){
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.viewModel setAcronymText:self.acronymTextField.text];
        
        [self.viewModel getAcronymMeanings:self.acronymTextField.text withCompletionBlock:^(id meaningsArray, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(meaningsArray) {
                    self.acronymMeaningsArray = (NSArray *)meaningsArray;
                }
                else if(error){
                    [[UICoordinator sharedInstance] showAlertWithError:error action:nil];
                }
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.acronymMeaningsTableView reloadData];
            });
        }];
    }
    else {
        NSError *error = [NSError errorWithDomain:@"SearchAcronymErrors" code:3 userInfo:nil];
        [[UICoordinator sharedInstance] showAlertWithError:error action:nil];
    }
    
    [self.acronymTextField resignFirstResponder];
}

@end
