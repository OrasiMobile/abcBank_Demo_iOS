//
//  BalancesViewController.m
//  abcBankDemo
//
//  Created by Orasi Software on 5/20/13.
//  Copyright (c) 2013 Orasi Software. All rights reserved.
//

#import "BalancesViewController.h"
#import "SavingsHistoryViewController.h"
#import "CheckingHistoryViewController.h"
#import "CreditHistoryViewController.h"
#import "TransferViewController.h"
#import "PayCardViewController.h"
#import "LoginViewController.h"
@interface BalancesViewController ()
@property abcBank_Network * sendPic;
@property (nonatomic, strong, readwrite) IBOutlet UIActivityIndicatorView * activityIndicator;
@end

@implementation BalancesViewController
@synthesize sendPic;
@synthesize myTableView;
@synthesize brain;
int rowNum;
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.myTableView deselectRowAtIndexPath:[self.myTableView indexPathForSelectedRow] animated:YES];
    [self.myTableView reloadData];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //Instantiate our NSMutableArray
   
    
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"SavingsHistory"]){
        SavingsHistoryViewController *vc = segue.destinationViewController;
        vc.brain = self.brain;
    }
    if([segue.identifier isEqualToString:@"CreditHistory"]){
        CreditHistoryViewController *vc = segue.destinationViewController;
        vc.brain = self.brain;
    }
    if([segue.identifier isEqualToString:@"CheckingHistory"]){
        CheckingHistoryViewController *vc = segue.destinationViewController;
        vc.brain = self.brain;
    }
    if([segue.identifier isEqualToString:@"Transfers"]){
        TransferViewController *vc = segue.destinationViewController;
        vc.brain = self.brain;
    }
    if([segue.identifier isEqualToString:@"PayCard"]){
        PayCardViewController *vc = segue.destinationViewController;
        vc.brain = self.brain;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    NSString *cellIdentifier = @"HistoryCell";      

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (indexPath.row == 0) {
        
        UILabel *name = (UILabel *)[cell viewWithTag:1];
        UILabel *balance = (UILabel *)[cell viewWithTag:2];
        
        
        [name setText:@"Savings"];
        [balance setText:[brain CurrencyFromDouble:brain.SavingsBalance]];
       
    }
    if (indexPath.row == 1) {
        
        UILabel *name = (UILabel *)[cell viewWithTag:1];
        UILabel *balance = (UILabel *)[cell viewWithTag:2];
        
        
        [name setText:@"Checking"];
        [balance setText:[brain CurrencyFromDouble:brain.CheckingBalance]];
        
    }
    if (indexPath.row == 2) {
        
        UILabel *name = (UILabel *)[cell viewWithTag:1];
        UILabel *balance = (UILabel *)[cell viewWithTag:2];
        
        
        [name setText:@"Credit Card"];
        [balance setText:[brain CurrencyFromDouble:brain.CreditBalance]];
        
    }
    
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView  titleForHeaderInSection:(NSInteger)section{
    
        return @"Account Balances";
    
}
-(void)gotData
{
    [self.activityIndicator stopAnimating]; //sending stoped
    if (rowNum == 0){
        [self performSegueWithIdentifier:@"SavingsHistory" sender:self];
    }
    if (rowNum == 1){
        [self performSegueWithIdentifier:@"CheckingHistory" sender:self];
    }
    if (rowNum == 2){
        [self performSegueWithIdentifier:@"CreditHistory" sender:self];
    }
}

//if user select object in the table, go to a view that shows more details on that object.
-(void)tableView:(UITableView *)tableView  didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //start data transfer and let the user know
    self.sendPic = [[abcBank_Network alloc] init];
    [self.activityIndicator startAnimating];
    self.sendPic.delegate = self;
    [self.sendPic startSend];
    if (indexPath.row == 0){
        rowNum = 0;
    }
    if (indexPath.row == 1){
        rowNum = 1;
    }
    if (indexPath.row == 2){
        rowNum = 2;
    }
}
- (IBAction)LogOffClicked:(id)sender {
    for (UIViewController *viewController in self.navigationController.viewControllers){
        if(![viewController isKindOfClass:[LoginViewController class]]){
            [viewController.navigationController popViewControllerAnimated:(YES)];
        }
    }

}
@end
