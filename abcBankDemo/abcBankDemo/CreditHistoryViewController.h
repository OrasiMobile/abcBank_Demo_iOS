//
//  CreditHistoryViewController.h
//  abcBankDemo
//
//  Created by Orasi Software on 5/20/13.
//  Copyright (c) 2013 Orasi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "abcBankBrain.h"

@interface CreditHistoryViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) abcBankBrain *brain;
@end

