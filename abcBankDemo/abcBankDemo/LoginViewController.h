//
//  LogonViewController.h
//  abcBank
//
//  Created by Orasi Software on 5/6/13.
//  Copyright (c) 2013 Orasi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "abcBank_Network.h"


@interface LoginViewController : UIViewController <abcBank_NetworkDelegate> {
    
}

@property (weak, nonatomic) IBOutlet UITextField *UserIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *PasswordTextField;
@property (weak, nonatomic) IBOutlet UILabel *UsernamePasswordFlag;

- (IBAction)LogonButtonPressed;
- (IBAction)textFieldReturn:(id)sender;
-(IBAction)backgroundTouched:(id)sender;
@end
