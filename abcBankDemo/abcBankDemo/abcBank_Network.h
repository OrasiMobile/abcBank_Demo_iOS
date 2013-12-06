//
//  abcBank_Network.h
//  abcBankDemo
//
//  Created by Orasi Software on 6/10/13.
//  Copyright (c) 2013 Orasi Software. All rights reserved.
//

#import "abcBankAppDelegate.h"
@protocol abcBank_NetworkDelegate 

- (void)gotData;

@end

@interface abcBank_Network : abcBankAppDelegate {
    id<abcBank_NetworkDelegate> delegate;
}
- (void)startSend;
@property(nonatomic,assign)id delegate;
@end
