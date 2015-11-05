//
//  DatabaseFactory.h
//  RealmExplorer
//
//  Created by Lincoln Six Echo on 04.11.15.
//  Copyright © 2015 appdoctors UG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface DatabaseFactory : NSObject {

}

+ (NSString*) databasePathForSchemaVersion:(NSUInteger)schemaVersion;
+ (BOOL) databaseExistsForSchemaVersion:(NSUInteger)schemaVersion;
+ (void) databaseMigrateToSchemaVersion:(NSUInteger)targetSchemaVersion;
+ (NSInteger) databaseCurrentSchemaVersion;
+ (BOOL) databaseNeedsToMigrate;
+ (NSException*) databaseSetup;

@end
