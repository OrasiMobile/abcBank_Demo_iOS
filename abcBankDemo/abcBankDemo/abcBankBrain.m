
//
//  abcBankBrain.m
//  abcBank
//
//  Created by Orasi Software on 5/7/13.
//  Copyright (c) 2013 Orasi Software. All rights reserved.
//

#import "abcBankBrain.h"

@implementation abcBankBrain
@synthesize CheckingBalance;
@synthesize SavingsBalance;
@synthesize CreditBalance;
@synthesize CreditLimit;
@synthesize CheckingDates;
@synthesize CheckingHistory;
@synthesize SavingsDates;
@synthesize SavingsHistory;
@synthesize CreditCardDates;
@synthesize CreditCardHistory;

-(void)LoadDefaultValues
{
    NSMutableArray *checkingHistory = [[NSMutableArray alloc] initWithObjects:@"Mcdonalds",@"-$7.45", @"Target", @"-$108.68",@"FootLocker", @"-$87.02",
                                       @"Direct Deposit", @"$4500.00", @"IKEA", @"-$584.45", @"House Payment", @"-$975.12",
                                       @"Check #1234", @"$75.00", @"McDonalds",  @"-$7.45",@"WalMart", @"-$35.19", @"Harrah's", @"-$2,500.00", nil];
    NSMutableArray *checkingDates = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
    
    NSMutableArray *savingsHistory = [[NSMutableArray alloc] initWithObjects:@"Withdrawal", @"-$1000.00", @"Interest Accrued", @"$98.68", @"Deposit", @"$45.00", @"Deposit", @"$3000.00", @"Deposit", @"$10,000.00", nil];
    NSMutableArray *savingDates = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"", nil];
    
    NSMutableArray *creditCardHistory = [[NSMutableArray alloc] initWithObjects:@"Duke Engergy", @"-$145.15", @"Payment", @"$30.00",@"ABC Store", @"-$74.13", @"Best Buy", @"-$1,345.55",@"Wal-Mart", @"-$4.87",@"ABC Store", @"-$5.72",@"Apple Store", @"-$487.21",@"Steakhouse", @"-$55.98",@"Gas Station", @"-$45.05",@"Target", @"-$10.14", nil];
    NSMutableArray *creditCardDates = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
    [creditCardDates replaceObjectAtIndex:0 withObject:  [self.class GetDateFromToday:0]];
    [creditCardDates replaceObjectAtIndex:1 withObject:  [self.class GetDateFromToday:1]];
    [creditCardDates replaceObjectAtIndex:2 withObject:  [self.class GetDateFromToday:1]];
    [creditCardDates replaceObjectAtIndex:3 withObject:  [self.class GetDateFromToday:2]];
    [creditCardDates replaceObjectAtIndex:4 withObject:  [self.class GetDateFromToday:3]];
    [creditCardDates replaceObjectAtIndex:5 withObject:  [self.class GetDateFromToday:4]];
    [creditCardDates replaceObjectAtIndex:6 withObject:  [self.class GetDateFromToday:5]];
    [creditCardDates replaceObjectAtIndex:7 withObject:  [self.class GetDateFromToday:6]];
    [creditCardDates replaceObjectAtIndex:8 withObject:  [self.class GetDateFromToday:6]];
    [creditCardDates replaceObjectAtIndex:9 withObject:  [self.class GetDateFromToday:7]];
        
    [savingDates replaceObjectAtIndex:0 withObject:  [self.class GetDateFromToday:0]];
    [savingDates replaceObjectAtIndex:1 withObject:  [self.class GetDateFromToday:3]];
    [savingDates replaceObjectAtIndex:2 withObject:  [self.class GetDateFromToday:6]];
    [savingDates replaceObjectAtIndex:3 withObject:  [self.class GetDateFromToday:6]];
    [savingDates replaceObjectAtIndex:4 withObject:  [self.class GetDateFromToday:9]];
    
    [checkingDates replaceObjectAtIndex:0 withObject:  [self.class GetDateFromToday:0]];
    [checkingDates replaceObjectAtIndex:1 withObject:  [self.class GetDateFromToday:0]];
    [checkingDates replaceObjectAtIndex:2 withObject:  [self.class GetDateFromToday:1]];
    [checkingDates replaceObjectAtIndex:3 withObject:  [self.class GetDateFromToday:2]];
    [checkingDates replaceObjectAtIndex:4 withObject:  [self.class GetDateFromToday:2]];
    [checkingDates replaceObjectAtIndex:5 withObject:  [self.class GetDateFromToday:2]];
    [checkingDates replaceObjectAtIndex:6 withObject:  [self.class GetDateFromToday:3]];
    [checkingDates replaceObjectAtIndex:7 withObject:  [self.class GetDateFromToday:3]];
    [checkingDates replaceObjectAtIndex:8 withObject:  [self.class GetDateFromToday:4]];
    [checkingDates replaceObjectAtIndex:9 withObject:  [self.class GetDateFromToday:5]];
    self.CheckingBalance = 5525.12;
    self.SavingsBalance = 45789.65;
    self.CreditBalance = 9012.25;
    self.CreditLimit = 10000.00;
    
    self.CreditCardHistory = creditCardHistory;
    self.CreditCardDates = creditCardDates;
    
    self.SavingsDates = savingDates;
    self.SavingsHistory = savingsHistory;
    
    self.CheckingHistory = checkingHistory;
    self.CheckingDates = checkingDates;
}

+(NSString *)GetDateFromToday:(NSInteger) daysFromToday
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *today = [NSDate date];
    NSDateComponents *dc =[[NSDateComponents alloc] init];
    daysFromToday = -daysFromToday;
    dc.day = daysFromToday;
    NSDate *date = [gregorian dateByAddingComponents:dc toDate:today options:0];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yy"];
    
    NSString *newDate = [df stringFromDate:date];
    return newDate;
}
-(NSString *)CurrencyFromDouble:(double) dbl{

    NSString *money;
    NSDecimalNumber *amount;
    amount = [NSDecimalNumber decimalNumberWithMantissa:dbl*100 exponent:-2 isNegative:NO];
    money = amount.stringValue;
   NSString *dollar = @"$";
    money = [dollar stringByAppendingString:money];
    return money;
    
}
-(void)transferfromAccount:(NSString *)fromAccout toAccount:(NSString *)toAccount amount:(NSString *)amount{
    if ([fromAccout isEqualToString:@"Checking"]){
        self.CheckingHistory = [self.class cycleArray:self.CheckingHistory];
        [self.CheckingHistory replaceObjectAtIndex:0 withObject:@"Transfer"];
        NSString *dollar = @"-$";
        NSString *outAmount = [dollar stringByAppendingString:amount];
        [self.CheckingHistory replaceObjectAtIndex:1 withObject:outAmount];
        self.CheckingBalance = self.CheckingBalance - [amount doubleValue];
        self.CheckingDates = [self.class cycleDataArray:self.CheckingDates];
        
    }
    if ([fromAccout isEqualToString:@"Savings"]){
        self.SavingsHistory = [self.class cycleArray:self.SavingsHistory];
        [self.SavingsHistory replaceObjectAtIndex:0 withObject:@"Transfer"];
        NSString *dollar = @"-$";
        NSString *outAmount = [dollar stringByAppendingString:amount];
        [self.SavingsHistory replaceObjectAtIndex:1 withObject:outAmount];
        self.SavingsBalance= self.SavingsBalance - [amount doubleValue];
        self.SavingsDates = [self.class cycleDataArray:self.SavingsDates];
    }
    if ([fromAccout isEqualToString:@"Credit Card"]){
        self.CreditCardHistory = [self.class cycleArray:self.CreditCardHistory];
        [self.CreditCardHistory replaceObjectAtIndex:0 withObject:@"Transfer"];
        NSString *dollar = @"-$";
        NSString *outAmount = [dollar stringByAppendingString:amount];
        [self.CreditCardHistory replaceObjectAtIndex:1 withObject:outAmount];
        self.CreditBalance = self.CreditBalance - [amount doubleValue];
        self.CreditCardDates = [self.class cycleDataArray:self.CreditCardDates];
    }
    if ([toAccount isEqualToString:@"Checking"]){
        self.CheckingHistory = [self.class cycleArray:self.CheckingHistory];
        [self.CheckingHistory replaceObjectAtIndex:0 withObject:@"Transfer"];
        NSString *dollar = @"$";
        NSString *outAmount = [dollar stringByAppendingString:amount];
        [self.CheckingHistory replaceObjectAtIndex:1 withObject:outAmount];
        self.CheckingBalance = self.CheckingBalance + [amount doubleValue];
        self.CheckingDates = [self.class cycleDataArray:self.CheckingDates];
    }
    if ([toAccount isEqualToString:@"Savings"]){
        self.SavingsHistory = [self.class cycleArray:self.SavingsHistory];
        [self.SavingsHistory replaceObjectAtIndex:0 withObject:@"Transfer"];
        NSString *dollar = @"$";
        NSString *outAmount = [dollar stringByAppendingString:amount];
        [self.SavingsHistory replaceObjectAtIndex:1 withObject:outAmount];
        self.SavingsBalance = self.SavingsBalance + [amount doubleValue];
        self.SavingsDates = [self.class cycleDataArray:self.SavingsDates];
    }
    if ([toAccount isEqualToString:@"Credit Card"]){
        self.CreditCardHistory = [self.class cycleArray:self.CreditCardHistory];
        [self.CreditCardHistory replaceObjectAtIndex:0 withObject:@"Transfer"];
        NSString *dollar = @"$";
        NSString *outAmount = [dollar stringByAppendingString:amount];
        [self.CreditCardHistory replaceObjectAtIndex:1 withObject:outAmount];
        self.CreditBalance = self.CreditBalance + [amount doubleValue];
        self.CreditCardDates = [self.class cycleDataArray:self.CreditCardDates];
    }
}
+(NSMutableArray *)cycleArray:(NSMutableArray *)array{
    int i;
    for (i= array.count-1; i>1; i=i-2){
        [array replaceObjectAtIndex:i withObject:[array objectAtIndex:i-2]];
        [array replaceObjectAtIndex:i-1 withObject:[array objectAtIndex:i-3]];
        
    }
    return array;
}
+(NSMutableArray *)cycleDataArray:(NSMutableArray *)array{
    int i;
    for(i=array.count-1; i>0; i--){
        [array replaceObjectAtIndex:i withObject:[array objectAtIndex:i-1]];
    }
    [array replaceObjectAtIndex:0 withObject:[self.class GetDateFromToday:0]];
    return array;
}
-(void)payfromAccount:(NSString *)fromAccout toAccount:(NSString *)toAccount amount:(NSString *)amount{
    if ([fromAccout isEqualToString:@"Checking"]){
        self.CheckingHistory = [self.class cycleArray:self.CheckingHistory];
        [self.CheckingHistory replaceObjectAtIndex:0 withObject:@"Card Payment"];
        NSString *dollar = @"-$";
        NSString *outAmount = [dollar stringByAppendingString:amount];
        [self.CheckingHistory replaceObjectAtIndex:1 withObject:outAmount];
        self.CheckingBalance = self.CheckingBalance - [amount doubleValue];
        self.CheckingDates = [self.class cycleDataArray:self.CheckingDates];
        
    }
    if ([fromAccout isEqualToString:@"Savings"]){
        self.SavingsHistory = [self.class cycleArray:self.SavingsHistory];
        [self.SavingsHistory replaceObjectAtIndex:0 withObject:@"Card Payment"];
        NSString *dollar = @"-$";
        NSString *outAmount = [dollar stringByAppendingString:amount];
        [self.SavingsHistory replaceObjectAtIndex:1 withObject:outAmount];
        self.SavingsBalance= self.SavingsBalance - [amount doubleValue];
        self.SavingsDates = [self.class cycleDataArray:self.SavingsDates];
    }

    if ([toAccount isEqualToString:@"Credit Card"]){
        self.CreditCardHistory = [self.class cycleArray:self.CreditCardHistory];
        [self.CreditCardHistory replaceObjectAtIndex:0 withObject:@"Payment"];
        NSString *dollar = @"$";
        NSString *outAmount = [dollar stringByAppendingString:amount];
        [self.CreditCardHistory replaceObjectAtIndex:1 withObject:outAmount];
        self.CreditBalance = self.CreditBalance + [amount doubleValue];
        self.CreditCardDates = [self.class cycleDataArray:self.CreditCardDates];
    }
}



@end
