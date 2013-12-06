//
//  BalancesViewController.h
//  abcBankDemo
//
//  Created by Orasi Software on 5/20/13.
//  Copyright (c) 2013 Orasi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "abcBankBrain.h"
#import "abcBank_Network.h"


@interface BalancesViewController : UIViewController <abcBank_NetworkDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) abcBankBrain *brain;
- (IBAction)LogOffClicked:(id)sender;
@end


