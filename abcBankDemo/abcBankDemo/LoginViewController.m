//
//  LogonViewController.m
//  abcBank
//
//  Created by Orasi Software on 5/6/13.
//  Copyright (c) 2013 Orasi Software. All rights reserved.
//

#import "LoginViewController.h"
#import "abcBankBrain.h"
#import "BalancesViewController.h"


@interface LoginViewController ()
@property (nonatomic, strong, readwrite) IBOutlet UIActivityIndicatorView * activityIndicator;
@property abcBank_Network * sendPic;
@end

@implementation LoginViewController
@synthesize UserIDTextField = _UserIDTextField;
@synthesize PasswordTextField = _PasswordTextField;
@synthesize UsernamePasswordFlag = _UsernamePasswordFlag;
@synthesize activityIndicator = _activityIndicator;
@synthesize sendPic = _sendPic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    self.UserIDTextField.text = @"";
    self.PasswordTextField.text = @"";
    self.UsernamePasswordFlag.text = @"";
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.UsernamePasswordFlag.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) logonSuccses //loging in work get data flow started
{
    //start sending big data
    self.sendPic = [[abcBank_Network alloc] init];
    [self.activityIndicator startAnimating];
    self.sendPic.delegate = self;
    [self.sendPic startSend];
    
}
- (void) gotData //called by the abcBank_Network deleage when data has finshed reciveing failed or not
{
    //wait for data to come back
    
    [self.activityIndicator stopAnimating]; //sending stoped
    [self performSegueWithIdentifier:@"Logon" sender:self];
    
    
}
- (IBAction)LogonButtonPressed {
    
    NSArray *userNames = [NSArray arrayWithObjects: @"Demo", @"Alex", @"Mary", nil];
    int count = [userNames count];
    bool correctLogin = FALSE;
    
    for(int i = 0; i < count; i++){
        if([self.UserIDTextField.text isEqualToString:[userNames objectAtIndex: i]]){
            correctLogin = TRUE;
            break;
        }else{
            //Continue
        }
    }
    
    
    if (correctLogin == TRUE){
        //@to-do
        
        if ([self.PasswordTextField.text isEqualToString:@"demo1234"]){
            [self logonSuccses];
            
        }else{
            self.UsernamePasswordFlag.text = @"Incorrect Username or Password.  Please try again.";
            
        }
        
    }else{
        self.UsernamePasswordFlag.text = @"Incorrect Username or Password.   Please try again.";
    }
    
    
    

}
- (IBAction)textFieldReturn:(id)sender {
    [self.UserIDTextField resignFirstResponder];
    [self.PasswordTextField resignFirstResponder];
}
-(IBAction)backgroundTouched:(id)sender
{
    [self.UserIDTextField resignFirstResponder];
    [self.PasswordTextField resignFirstResponder];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    BalancesViewController *vc = [segue destinationViewController];
    abcBankBrain *brain = [[abcBankBrain alloc] init];
    [brain LoadDefaultValues];
    vc.brain = brain;

}
@end