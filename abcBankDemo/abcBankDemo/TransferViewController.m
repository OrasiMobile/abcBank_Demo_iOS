//
//  TransferViewController.m
//  abcBankDemo
//
//  Created by Orasi Software on 5/20/13.
//  Copyright (c) 2013 Orasi Software. All rights reserved.
//

#import "TransferViewController.h"
#import "SavingsHistoryViewController.h"
#import "CreditHistoryViewController.h"
#import "CheckingHistoryViewController.h"
@interface TransferViewController ()
@property abcBank_Network * sendPic;
@property (nonatomic, strong, readwrite) IBOutlet UIActivityIndicatorView * activityIndicator;
@end

@implementation TransferViewController
@synthesize ToPicker;
@synthesize FromPicker;
@synthesize brain;
@synthesize sendPic;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.accountsArray = [[NSArray alloc] initWithObjects: @"Checking", @"Savings", @"Credit Card",nil];
    self.FromPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.ToPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    UIToolbar *toolbar =[[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleDefault;
    toolbar.translucent = YES;
    toolbar.tintColor = nil;
    [toolbar sizeToFit];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClicked:)];
    [toolbar setItems:[NSArray arrayWithObjects:done, nil]];
    
    self.FromPicker.delegate = self;
    self.FromPicker.dataSource = self;
    self.FromPicker.tag = 0;
    self.ToPicker.tag = 1;
    self.ToPicker.delegate = self;
    self.ToPicker.dataSource = self;
    [self.ToPicker selectRow:1 inComponent:0 animated:YES];
    [self.FromPicker selectRow:1 inComponent:0 animated:YES];
    [self.ToPicker setShowsSelectionIndicator:YES];
    [self.FromPicker setShowsSelectionIndicator:YES];
    self.toField.inputView = self.ToPicker;
    self.fromField.inputView = self.FromPicker;
    self.toField.inputAccessoryView = toolbar;
    self.fromField.inputAccessoryView = toolbar;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)textFieldReturn:(id)sender {
    [self.AmountField resignFirstResponder];
    
}
-(IBAction)backgroundTouched:(id)sender
{
    [self.AmountField resignFirstResponder];
    [self.toField resignFirstResponder];
    [self.fromField resignFirstResponder];
    
}

- (IBAction)SetTextFieldFrom:(id)sender {
    if ([self.fromField.text isEqualToString:@"From Account"]){
        self.fromField.text = [self.accountsArray objectAtIndex:[self.FromPicker selectedRowInComponent:0]];
    }
    
}
- (IBAction)SetTextFieldTo:(id)sender {
    if ([self.toField.text isEqualToString:@"To Account"])
    self.toField.text = [self.accountsArray objectAtIndex:[self.ToPicker selectedRowInComponent:0]];
    
}
-(void)gotData//time to move screens
{
    //there is a % for the user to change to field text before segueway
    [self.activityIndicator stopAnimating];
    if ([self.toField.text isEqualToString:@"Checking"]){
        [self performSegueWithIdentifier:@"TransCheck" sender:self];
    }
    if ([self.toField.text isEqualToString:@"Savings"]){
        [self performSegueWithIdentifier:@"TransSave" sender:self];
    }
    if ([self.toField.text isEqualToString:@"Credit Card"]){
        [self performSegueWithIdentifier:@"TransCredit" sender:self];
    }
}
- (IBAction)submitButtonClicked { // when the user presses submit, move the money
    if ([self.toField.text isEqualToString:self.fromField.text]){
            self.transferErrorFlag.text = @"Pay To and Pay From must be seperate accounts.";
    }else{
        if ([self.AmountField.text isEqualToString:@""]){
            self.transferErrorFlag.text= @"Amount must not be left blank";
        }else{
        [self.brain transferfromAccount:self.fromField.text toAccount:self.toField.text amount:self.AmountField.text];
           //send data
            self.sendPic = [[abcBank_Network alloc] init];
            [self.activityIndicator startAnimating];
            self.sendPic.delegate = self;
            [self.sendPic startSend];
        }}
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"TransSave"]){
        SavingsHistoryViewController *vc = segue.destinationViewController;
        vc.brain = self.brain;
    }
    if([segue.identifier isEqualToString:@"TransCredit"]){
        CreditHistoryViewController *vc = segue.destinationViewController;
        vc.brain = self.brain;
    }
    if([segue.identifier isEqualToString:@"TransCheck"]){
        CheckingHistoryViewController *vc = segue.destinationViewController;
        vc.brain = self.brain;
    }
    
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 3;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.accountsArray objectAtIndex:row];
   
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    [pickerView setShowsSelectionIndicator:YES];
    
    if (pickerView.tag == 0){
        self.fromField.text = [self.accountsArray objectAtIndex:row];
        [self.FromPicker selectRow:row inComponent:0 animated:NO];
    }else{
        self.toField.text = [self.accountsArray objectAtIndex:row];
        [self.ToPicker selectRow:row inComponent:0 animated:NO];
   
    }
    
   
}
-(IBAction)doneButtonClicked:(id)sender{
   
    [self.toField resignFirstResponder];
    [self.fromField resignFirstResponder];
}

- (IBAction)toDidBeginEditing:(id)sender{
    
    [self.tableView setContentOffset:CGPointMake(0, 50) animated:YES];
}
- (IBAction)textViewDidBeginEditing:(id)sender{
   
    [self.tableView setContentOffset:CGPointMake(0, 100) animated:YES];
}
@end
