//
//  CaptainFormPartsRealm.m
//  RealmExplorer
//
//  Created by Lincoln Six Echo on 04.11.15.
//  Copyright © 2015 appdoctors UG. All rights reserved.
//

#import "CaptainFormPartsRealm.h"

@implementation CaptainFormPartsRealm

- (NSInteger) schemaVersion {
    return kDB_SCHEMA_VERSION;
}

- (BOOL) encrypted {
    return ( kDB_SCHEMA_ENCRYPTED == 1 );
}

- (NSArray *)fields {
    return @[
             
             @{FXFormFieldKey:@"schemaVersion",
               FXFormFieldHeader: @"Database",
               FXFormFieldTitle: @"Schemaversion",
               FXFormFieldType: FXFormFieldTypeInteger,
               FXFormFieldEditable: @NO,},
             
             @{FXFormFieldKey:@"encrypted",
               FXFormFieldTitle: @"Encrypted",
               FXFormFieldType: FXFormFieldTypeBoolean,
               FXFormFieldEditable: @NO,FXFormFieldFooter:@"Please recognize, the current schema version because the app behaves differently for different schemas.\nWhen encryption is active, you canot run the app attached to a debugger/Xcode."},
             
             ];
}


@end
