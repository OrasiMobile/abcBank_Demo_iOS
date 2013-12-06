//
//  PayCardViewController.m
//  abcBankDemo
//
//  Created by Orasi Software on 5/22/13.
//  Copyright (c) 2013 Orasi Software. All rights reserved.
//

#import "PayCardViewController.h"
#import "CreditHistoryViewController.h"
@interface PayCardViewController ()
@property (nonatomic, strong, readwrite) IBOutlet UIActivityIndicatorView * activityIndicator;
@property abcBank_Network * sendPic;
@end

@implementation PayCardViewController

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
    self.accountsArray = [[NSArray alloc] initWithObjects: @"Checking", @"Savings", nil];
    self.FromPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    UIToolbar *toolbar =[[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleDefault;
    toolbar.translucent = YES;
    toolbar.tintColor = nil;
    [toolbar sizeToFit];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClicked:)];
     [toolbar setItems:[NSArray arrayWithObjects:done, nil]];
    [self.FromPicker selectRow:0 inComponent:0 animated:YES];
    self.FromPicker.delegate = self;
    self.FromPicker.dataSource = self;
    self.FromPicker.tag = 0;
    [self.FromPicker setShowsSelectionIndicator:YES];
    self.fromField.inputView = self.FromPicker;
     self.fromField.inputAccessoryView = toolbar;
    self.cardBalance.text = [self.brain CurrencyFromDouble:self.brain.CreditBalance];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)doneButtonClicked:(id)sender{
    [self.fromField resignFirstResponder];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 2;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.accountsArray objectAtIndex:row];
    
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    [pickerView setShowsSelectionIndicator:YES];
    
        self.fromField.text = [self.accountsArray objectAtIndex:row];
        [self.FromPicker selectRow:row inComponent:0 animated:NO];
}
-(IBAction)backgroundTouched:(id)sender
{
    [self.amountField resignFirstResponder];
    [self.fromField resignFirstResponder];
    
}
- (IBAction)SetTextFieldFrom:(id)sender {
    if ([self.fromField.text isEqualToString:@""]){
        self.fromField.text = [self.accountsArray objectAtIndex:[self.FromPicker selectedRowInComponent:0]];
    }
}
- (IBAction)toDidBeginEditing:(id)sender{
    
    [self.tableView setContentOffset:CGPointMake(0, 50) animated:YES];
}
- (IBAction)textViewDidBeginEditing:(id)sender{
    
    [self.tableView setContentOffset:CGPointMake(0, 100) animated:YES];
}
- (void)gotData
{
    //wait for data to come back
    
    [self.activityIndicator stopAnimating]; //sending stoped
    [self performSegueWithIdentifier:@"PayCardCredit" sender:self];
}

- (IBAction)makePayment:(id)sender {//for when user clicks the payment button indacating that information needs to move
    
    self.sendPic = [[abcBank_Network alloc] init];
    [self.activityIndicator startAnimating];
    self.sendPic.delegate = self;
    [self.sendPic startSend];
    
    [self.brain payfromAccount:self.fromField.text toAccount:@"Credit Card" amount:self.amountField.text];
     
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
           CreditHistoryViewController *vc = segue.destinationViewController;
        vc.brain = self.brain;
}
@end