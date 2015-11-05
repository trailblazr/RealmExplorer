//
//  CaptainForm.m
//  RealmExplorer
//
//  Created by Lincoln Six Echo on 04.11.15.
//  Copyright © 2015 appdoctors UG. All rights reserved.
//

#import "CaptainForm.h"

@implementation CaptainForm

- (NSDictionary *)basicsField {
    return @{FXFormFieldInline: @YES, FXFormFieldHeader: @"Captain"};
}

- (NSDictionary *)realmField {
    return @{FXFormFieldInline: @YES, FXFormFieldHeader: @"Database"};
}

@end
