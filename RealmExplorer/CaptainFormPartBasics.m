//
//  CaptainFormPartBasics.m
//  RealmExplorer
//
//  Created by Lincoln Six Echo on 04.11.15.
//  Copyright © 2015 appdoctors UG. All rights reserved.
//

#import "CaptainFormPartBasics.h"
#import "CustomButtonCell.h"

@implementation CaptainFormPartBasics

- (NSArray *)fields {
    return @[
             
#if kDB_IS_MIN_SCHEMA_0
             @{FXFormFieldKey: @"index", FXFormFieldTitle: @"Index", FXFormFieldType: FXFormFieldTypeInteger,FXFormFieldEditable:@NO,},
             
             @{FXFormFieldKey: @"userid", FXFormFieldTitle: @"UserID", FXFormFieldPlaceholder: @"User ID", FXFormFieldType: FXFormFieldTypeText, FXFormFieldAction:@"validateAndSave:"},
             
             @{FXFormFieldKey: @"password", FXFormFieldTitle: @"Password", FXFormFieldType: FXFormFieldTypePassword, FXFormFieldAction:@"validateAndSave:"},
             
             @{FXFormFieldKey: @"date", FXFormFieldTitle: @"Date created", FXFormFieldType: FXFormFieldTypeDate, FXFormFieldDefaultValue: [NSDate date], FXFormFieldAction:@"validateAndSave:"},
#endif
#if kDB_IS_MIN_SCHEMA_1
             @{FXFormFieldKey: @"age", FXFormFieldTitle: @"Age", FXFormFieldType: FXFormFieldTypeInteger, FXFormFieldDefaultValue: [NSNumber numberWithInt:25] , FXFormFieldAction:@"validateAndSave:"},
#endif

#if kDB_IS_MIN_SCHEMA_2
             @{FXFormFieldKey: @"gender", FXFormFieldTitle: @"Gender", FXFormFieldType: FXFormFieldTypeOption, FXFormFieldOptions: @[@"male", @"female", @"it's Complicated"], FXFormFieldAction:@"validateAndSave:"},
#endif
#if kDB_IS_MIN_SCHEMA_3
             @{FXFormFieldKey: @"yachtNames", FXFormFieldTitle: @"Yachts", FXFormFieldInline: @NO, FXFormFieldAction:@"editYacht"},
#endif
#if kDB_IS_MIN_SCHEMA_4
             @{FXFormFieldKey: @"avatarImage", FXFormFieldTitle: @"Avatar", FXFormFieldType: FXFormFieldTypeImage, FXFormFieldAction:@"validateAndSave:",FXFormFieldFooter:@"Enter new & change existing data by tapping an entry."},
#endif
             ];
}


- (NSArray *)extraFields {
    return @[
            @{FXFormFieldKey: @"saveButton", FXFormFieldTitle: @"Save changes", FXFormFieldCell: [CustomButtonCell class], FXFormFieldHeader: @"", FXFormFieldAction: @"submitCaptainFormPartBasics"},
             
             ];
}

- (NSArray*) excludedFields {
    if( NO ) {
    return @[
#if kDB_IS_MIN_SCHEMA_1
    @"age",
#endif
    ];
    }
    else {
        return @[];
    }
}

@end
