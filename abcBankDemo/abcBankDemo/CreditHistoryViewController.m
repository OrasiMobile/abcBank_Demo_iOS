//
//  CreditHistoryViewController.m
//  abcBankDemo
//
//  Created by Orasi Software on 5/20/13.
//  Copyright (c) 2013 Orasi Software. All rights reserved.
//

#import "CreditHistoryViewController.h"
#import "TransferViewController.h"
@interface CreditHistoryViewController ()
@end

@implementation CreditHistoryViewController

@synthesize myTableView;
@synthesize brain;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //Instantiate our NSMutableArray
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0){
        return 1;
    }else{
        return brain.CreditCardDates.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //   UITableViewCell *cell = [[UITableViewCell alloc] init];
    NSString *cellIdentifier = @"";
    if (indexPath.section == 1) {
        cellIdentifier = @"HistoryCell";
        
    }else{
        cellIdentifier = @"BalanceCell";
        
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (indexPath.section == 1) {
        
        if(cell== nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        UILabel *date = (UILabel *)[cell viewWithTag:1];
        UILabel *location = (UILabel *)[cell viewWithTag:2];
        UILabel *amount = (UILabel *)[cell viewWithTag:3];
        
        [date setText:[brain.CreditCardDates objectAtIndex:indexPath.row]];
        
        [location setText:[brain.CreditCardHistory objectAtIndex:(indexPath.row)*2]];
        [amount setText:[brain.CreditCardHistory objectAtIndex:(indexPath.row)*2+1]];
        NSString * string = amount.text;
        
        
        
        if ([string rangeOfString:@"-"].location != NSNotFound){
            amount.textColor = [UIColor redColor];
        }
    }else{
        
        
        if(cell== nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        UILabel *balance = (UILabel *)[cell viewWithTag:3];
        balance.text = [brain CurrencyFromDouble:brain.CreditBalance];
        
        
    }
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView  titleForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return @"Credit-Card Account";
    }else{
        return @"Credit-Card History";
    }
}

@end

