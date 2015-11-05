//
//  CustomButtonCell.m
//  CustomButtonExample
//
//  Created by Nick Lockwood on 07/04/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "CustomButtonCell.h"


@interface CustomButtonCell ()


@end


@implementation CustomButtonCell

@synthesize cellButton;

//note: we could override -awakeFromNib or -initWithCoder: if we wanted
//to do any customisation in code, but in this case we don't need to

//if we were creating the cell programamtically instead of using a nib
//we would override -initWithStyle:reuseIdentifier: to do the configuration

- (void)layoutSubviews {
    [self.cellButton setTitle:self.field.title forState:UIControlStateNormal];
    self.cellButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0];
    self.field.value = cellButton;
}

- (IBAction)buttonAction
{
    if (self.field.action) self.field.action(self);
}

@end
