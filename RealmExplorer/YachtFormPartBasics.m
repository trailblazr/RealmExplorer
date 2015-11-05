//
//  YachtFormPartBasics.m
//  RealmExplorer
//
//  Created by Lincoln Six Echo on 04.11.15.
//  Copyright © 2015 appdoctors UG. All rights reserved.
//

#import "YachtFormPartBasics.h"
#import "CustomButtonCell.h"

@implementation YachtFormPartBasics

- (NSArray *)fields {
    return @[
             
             @{FXFormFieldKey: @"yacht", FXFormFieldTitle: @"Yachtname", FXFormFieldPlaceholder: @"Nautilus", FXFormFieldType: FXFormFieldTypeText,FXFormFieldAction:@"validateAndSave:"},
             
             @{FXFormFieldKey: @"callsign", FXFormFieldTitle: @"Callsign", FXFormFieldPlaceholder: @"DK1337", FXFormFieldType: FXFormFieldTypeText,FXFormFieldAction:@"validateAndSave:"},
             
             @{FXFormFieldKey: @"mmsi", FXFormFieldTitle: @"MMSI", FXFormFieldPlaceholder: @"192837465", FXFormFieldType: FXFormFieldTypeText,FXFormFieldAction:@"validateAndSave:"},
             
             @{FXFormFieldKey: @"active", FXFormFieldTitle: @"in Operation", FXFormFieldType: FXFormFieldTypeBoolean,FXFormFieldAction:@"validateAndSave:",FXFormFieldFooter:@"Enter new & change existing data by tapping an entry."},
             ];
}

- (NSArray *)extraFields {
    return @[
             @{FXFormFieldKey: @"saveButton", FXFormFieldTitle: @"Save changes", FXFormFieldCell: [CustomButtonCell class], FXFormFieldHeader: @"", FXFormFieldAction: @"submitYachtFormPartBasics"},
             
             ];
}

@end
