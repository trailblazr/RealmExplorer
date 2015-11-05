//
//  DatabaseModel.m
//  RealmExplorer
//
//  Created by Lincoln Six Echo on 02.11.15.
//  Copyright © 2015 appdoctors UG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseModel.h"


@implementation DBCaptain
// None needed
@end


#if kDB_IS_MIN_SCHEMA_3
@implementation DBYacht
// Define "owners" as the inverse relationship to DBCaptain.yachts
- (NSArray *)owners {
    return [self linkingObjectsOfClass:@"DBCaptain" forProperty:@"yachts"];
}
@end
#endif