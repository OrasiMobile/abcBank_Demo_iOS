//
//  PickerViewField.m
//  abcBankDemo
//
//  Created by Orasi Software on 5/22/13.
//  Copyright (c) 2013 Orasi Software. All rights reserved.
//

#import "PickerViewField.h"

@interface PickerViewField ()

@end

@implementation PickerViewField
@synthesize inputView = _inputView;
-(BOOL) canBecomeFirstResponder{
    return YES;
}



@end
