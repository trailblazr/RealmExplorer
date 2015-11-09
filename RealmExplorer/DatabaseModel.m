//
//  DatabaseModel.m
//  RealmExplorer
//
//  Created by Lincoln Six Echo on 02.11.15.
//  Copyright © 2015 appdoctors UG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseModel.h"


#pragma mark - ENTITY: DBAutoGeneric

@implementation DBAutoGeneric

+ ( NSString * )primaryKey; {
    return @"PKID";
}

/* PROPERTIES */
+ (NSArray *)indexedProperties {
    return @[];
}

+ (NSDictionary *)defaultPropertyValues {
    // WILL GENERATE A UNIQUE PRIMARY KEY AS DEFAULT VALUE ON FIRST INSERT INTO DB &
    // SET CREATION DATE AUTOMAGICALLY FOR YOU ON ALL ENTITIES
    return @{@"PKID" : [[NSUUID UUID] UUIDString], @"dateCreated" : [NSDate date]};
}

+ (NSArray *)ignoredProperties {
    return @[];
}

- (void) entityPrepareForSave {
    self.dateChanged = [NSDate date];
}

@end


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