//
//  YachtFormPartFeatures.m
//  RealmExplorer
//
//  Created by Lincoln Six Echo on 04.11.15.
//  Copyright © 2015 appdoctors UG. All rights reserved.
//

#import "YachtFormPartFeatures.h"
#import "CustomButtonCell.h"

@implementation YachtFormPartFeatures


- (NSArray *)fields {
    return @[
             
             //we want to add a group header for the field set of fields
             //we do that by adding the header key to the first field in the group
             
             @{FXFormFieldKey: @"yearBuild", FXFormFieldTitle: @"Baujahr", FXFormFieldPlaceholder:@"2005", FXFormFieldType: FXFormFieldTypeInteger},
             
             @{FXFormFieldKey: @"yearBought", FXFormFieldTitle: @"Kaufjahr", FXFormFieldPlaceholder:@"2010", FXFormFieldType: FXFormFieldTypeInteger},
             
             @{FXFormFieldKey: @"manufacturer", FXFormFieldTitle: @"Hersteller", FXFormFieldPlaceholder:@"Dingy"},

             @{FXFormFieldKey: @"lengthInMeters", FXFormFieldTitle: @"Länge (m)", FXFormFieldPlaceholder:@"7,00 m", FXFormFieldType: FXFormFieldTypeFloat},
             @{FXFormFieldKey: @"depthInMeters", FXFormFieldTitle: @"Tiefgang (m)", FXFormFieldPlaceholder:@"2,00 m", FXFormFieldType: FXFormFieldTypeFloat},
             @{FXFormFieldKey: @"widthInMeters", FXFormFieldTitle: @"Breite (m)", FXFormFieldPlaceholder:@"1,80 m", FXFormFieldType: FXFormFieldTypeFloat},
             @{FXFormFieldKey: @"comment", FXFormFieldTitle: @"Anmerkungen", FXFormFieldPlaceholder:@"", FXFormFieldType: FXFormFieldTypeLongText},
             ];
}

@end
