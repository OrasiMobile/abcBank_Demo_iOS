//
//  PayCardViewController.h
//  abcBankDemo
//
//  Created by Orasi Software on 5/22/13.
//  Copyright (c) 2013 Orasi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "abcBankBrain.h"
#import "abcBank_Network.h"

@interface PayCardViewController : UIViewController <UIPickerViewDataSource,  UIPickerViewDelegate, abcBank_NetworkDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *amountField;
@property (weak, nonatomic) IBOutlet UITextField *fromField;
@property (weak, nonatomic) IBOutlet UITextField *cardBalance;
@property (strong, nonatomic) UIPickerView *FromPicker;
@property (weak, nonatomic) abcBankBrain *brain;
@property (retain, nonatomic) NSArray *accountsArray;
-(IBAction)backgroundTouched:(id)sender;
- (IBAction)SetTextFieldFrom:(id)sender;
- (IBAction)toDidBeginEditing:(id)sender;
- (IBAction)textViewDidBeginEditing:(id)sender;
@end
