//
//  abcBankBrain.h
//  abcBank
//
//  Created by Orasi Software on 5/7/13.
//  Copyright (c) 2013 Orasi Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface abcBankBrain : NSObject
@property (strong, nonatomic) NSMutableArray *CreditCardHistory;
@property (strong, nonatomic) NSMutableArray *CreditCardDates;
@property (strong, nonatomic) NSMutableArray *CheckingHistory;
@property (strong, nonatomic) NSMutableArray *CheckingDates;
@property (strong, nonatomic) NSMutableArray *SavingsHistory;
@property (strong, nonatomic) NSMutableArray *SavingsDates;
@property (nonatomic) double CheckingBalance;
@property (nonatomic) double SavingsBalance;
@property (nonatomic) double CreditBalance;
@property (nonatomic) double CreditLimit;
-(void)LoadDefaultValues;
+(NSString *)GetDateFromToday:(NSInteger) daysFromToday;
-(NSString *)CurrencyFromDouble:(double) dbl;
-(void)transferfromAccount:(NSString *)fromAccout toAccount:(NSString *)toAccount amount:(NSString *)amount;
-(void)payfromAccount:(NSString *)fromAccout toAccount:(NSString *)toAccount amount:(NSString *)amount;
+(NSMutableArray *)cycleArray:(NSMutableArray *)array;

@end
