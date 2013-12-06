//
//  TransferViewController.h
//  abcBankDemo
//
//  Created by Orasi Software on 5/20/13.
//  Copyright (c) 2013 Orasi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "abcBankBrain.h"
#import "abcBank_Network.h"

@interface TransferViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, abcBank_NetworkDelegate>
@property (weak, nonatomic) abcBankBrain *brain;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *toField;

@property (weak, nonatomic) IBOutlet UILabel *transferErrorFlag;
@property (weak, nonatomic) IBOutlet UITextField *fromField;

@property (weak, nonatomic) IBOutlet UITextField *AmountField;
@property (retain, nonatomic) NSArray *accountsArray;
@property (strong, nonatomic) UIPickerView *ToPicker;
@property (strong, nonatomic) UIPickerView *FromPicker;
- (IBAction)textViewDidBeginEditing:(id)sender;

- (IBAction)textFieldReturn:(id)sender;
- (IBAction)toDidBeginEditing:(id)sender;
- (IBAction)backgroundTouched:(id)sender;
- (IBAction)SetTextFieldFrom:(id)sender;
- (IBAction)SetTextFieldTo:(id)sender;
- (IBAction)submitButtonClicked;
@end
