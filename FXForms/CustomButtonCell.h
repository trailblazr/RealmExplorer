//
//  CustomButtonCell.h
//  CustomButtonExample
//
//  Created by Nick Lockwood on 07/04/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "FXForms.h"

@interface CustomButtonCell : FXFormBaseCell {

    UIButton *cellButton;
}

@property (nonatomic, strong) IBOutlet UIButton *cellButton;

@end
