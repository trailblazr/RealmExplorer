//
//  DatabaseFactory.m
//  RealmExplorer
//
//  Created by Lincoln Six Echo on 04.11.15.
//  Copyright © 2015 appdoctors UG. All rights reserved.
//

#import "DatabaseFactory.h"
#import "DatabaseModel.h"

@implementation DatabaseFactory

+ (NSString*) databasePathForSchemaVersion:(NSUInteger)schemaVersion {
    NSString *databaseName = kDB_SCHEMA_ENCRYPTED ? kDB_FILENAME_CRYPT : kDB_FILENAME_PLAIN;
    NSString *databaseFilename = [NSString stringWithFormat:@"%@%03d%@%@", kDB_FILENAME_VERSION_PREFIX, (int)schemaVersion, kDB_FILENAME_VERSION_SUFFIX, databaseName]; // e.g. Schema0_FormCheckPlain.realm
    return [NSString stringWithFormat:@"%@/%@", USER_DOCUMENT_FOLDER, databaseFilename];
}

+ (BOOL) databaseExistsForSchemaVersion:(NSUInteger)schemaVersion {
    NSString *fileToCheck = [DatabaseFactory databasePathForSchemaVersion:schemaVersion];
    @try {
        return [[NSFileManager defaultManager] fileExistsAtPath:fileToCheck];
    }
    @catch (NSException *exception) {
        return NO;
    }
}

+ (void) databaseMigrateToSchemaVersion:(NSUInteger)targetSchemaVersion {
    NSInteger currentSchemaVersion = [DatabaseFactory databaseCurrentSchemaVersion];
    if( currentSchemaVersion == kDB_SCHEMA_VERSION_UNDEFINED ) {
        currentSchemaVersion = 0;
    }
    NSLog( @"DB: INITIATING MIGRATION FROM %i TO %i …", (int)currentSchemaVersion, (int)targetSchemaVersion );
    // TO BE CONTINUED...
    
    
    RLMMigrationBlock migrationBlock =  ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        NSLog(@"DB: MIGRATING...");
        if (targetSchemaVersion == 0) {
            NSLog(@"DB: MIGRATION TO SCHEMA 0 ...");
            // DOES NOTHING
        }
        if (targetSchemaVersion == 1) {
            NSLog(@"DB: MIGRATION TO SCHEMA 1 ...");
            [migration enumerateObjects:DBCaptain.className block:^(RLMObject *oldObject, RLMObject *newObject) {
                // add age
                newObject[@"age"] = [NSNumber numberWithInt:35];
                // overwrite existing users with new userid
                newObject[@"userid"] = @"Aragon"; // v1
            }];
        }
        if (targetSchemaVersion == 2) {
            NSLog(@"DB: MIGRATION TO SCHEMA 2 ...");
            [migration enumerateObjects:DBCaptain.className block:^(RLMObject *oldObject, RLMObject *newObject) {
                newObject[@"gender"] = @"female"; // v2
            }];
        }
        if (targetSchemaVersion == 3) {
            NSLog(@"DB: MIGRATION TO SCHEMA 3 ...");
            // nothing to do
        }
        if (targetSchemaVersion == 4) {
            NSLog(@"DB: MIGRATION TO SCHEMA 4 ...");
            // nothing to do
        }
        NSLog(@"DB: MIGRATION COMPLETE.");
    };
    
    // CONFIGURE OLD REALM AND OPEN REALM
    RLMRealmConfiguration *realmConfigLegacy = [[RLMRealmConfiguration alloc] init];
    realmConfigLegacy.path = [DatabaseFactory databasePathForSchemaVersion:currentSchemaVersion];
    realmConfigLegacy.schemaVersion = currentSchemaVersion;
    // realmConfigLegacy.migrationBlock = migrationBlock;
    [RLMRealmConfiguration setDefaultConfiguration:realmConfigLegacy];
    
    // CREATE COPY OF DB FILE FOR NEW MIGRATION
    [[NSFileManager defaultManager] removeItemAtPath:[DatabaseFactory databasePathForSchemaVersion:targetSchemaVersion] error:nil];
    [[NSFileManager defaultManager] copyItemAtPath:[DatabaseFactory databasePathForSchemaVersion:currentSchemaVersion] toPath:[DatabaseFactory databasePathForSchemaVersion:targetSchemaVersion] error:nil];
    
    // CONFIGURE NEW REALM AND MIGRATE
    RLMRealmConfiguration *realmConfigTarget = [realmConfigLegacy copy];
    realmConfigTarget.path = [DatabaseFactory databasePathForSchemaVersion:targetSchemaVersion];
    realmConfigTarget.schemaVersion = targetSchemaVersion;
    realmConfigTarget.migrationBlock = migrationBlock;
    [RLMRealmConfiguration setDefaultConfiguration:realmConfigTarget];
    [RLMRealm migrateRealm:realmConfigTarget];
    [RLMRealm defaultRealm];
}

+ (NSInteger) databaseCurrentSchemaVersion { // CHECKS WHICH DB-FILES REALLY EXIST
    NSInteger currentVersion = kDB_SCHEMA_VERSION_UNDEFINED;
    for( NSInteger versionIndex = kDB_SCHEMA_VERSION; versionIndex >= 0; versionIndex-- ) {
        BOOL exists = [DatabaseFactory databaseExistsForSchemaVersion:versionIndex];
        NSLog( @"DB: CHECKING VERSION %i... %@", (int)versionIndex, exists ? @"OKAY" : @"MISSING" );
        if( exists && ( currentVersion < versionIndex ) ) {
            currentVersion = versionIndex;
        }
    }
    return currentVersion;
}

+ (BOOL) databaseNeedsToMigrate {
    // NSLog( @"DB: CURRENT SCHEMA VERSION %i", (int)[DatabaseFactory databaseCurrentSchemaVersion] );
    if( [DatabaseFactory databaseCurrentSchemaVersion] == kDB_SCHEMA_VERSION_UNDEFINED ) return NO;
    return( [DatabaseFactory databaseCurrentSchemaVersion] < kDB_SCHEMA_VERSION );
}

+ (NSException*) databaseSetup {
    NSLog( @"DB: DATABASE FACTORY IS HERE TO SERVE YOU." );
   // CHECK MIGRATIONS
    while( [DatabaseFactory databaseNeedsToMigrate] ) {
        if( [DatabaseFactory databaseCurrentSchemaVersion] == kDB_SCHEMA_VERSION_UNDEFINED ) { // NO PREVIOUS DB EXISTENT
            NSLog( @"DB: CREATING A DATABASE FOR SCHEMA VERSION %i ...", kDB_SCHEMA_VERSION );
            [DatabaseFactory databaseMigrateToSchemaVersion:kDB_SCHEMA_VERSION]; // START WITH LATEST SCHEMA
            NSLog(@"DB: CREATED SUCCESSFULLY.");
        }
        else { // PREVIOUS VERSIONS EXISTENT, LET THEM CONTINUE TO EXIST AS BACKUP & MIGRATE...
            [DatabaseFactory databaseMigrateToSchemaVersion:[DatabaseFactory databaseCurrentSchemaVersion]+1];
        }
    }
    
    // CONFIG
    RLMRealmConfiguration *databaseConfig = [[RLMRealmConfiguration alloc] init];
    
    // DB PATH
    databaseConfig.schemaVersion = kDB_SCHEMA_VERSION;
    databaseConfig.path = [DatabaseFactory databasePathForSchemaVersion:databaseConfig.schemaVersion];
    
    NSLog( @"DB: CURRENT SCHEMA VERSION %i, FILEPATH IS ...\n\n%@\n\n", (int)databaseConfig.schemaVersion, databaseConfig.path );
    
    // ENCRYPTION (OPTIONAL) WILL STORE KEY In USER DEFAULTS (WHICH IS NOT RECOMMENDED, STORE IT IN THE USERS KEYCHAIN OR SO...)
    if( kDB_SCHEMA_ENCRYPTED ) {
        NSData *keyData = [[NSUserDefaults standardUserDefaults] objectForKey:kDB_USERDEFAULTS_ENCRYPTION_KEY];
        if( !keyData || [keyData length] == 0 ) {
            uint8_t buffer[64];
            SecRandomCopyBytes(kSecRandomDefault, 64, buffer);
            keyData = [[NSData alloc] initWithBytes:buffer length:sizeof(buffer)];
            [[NSUserDefaults standardUserDefaults] setObject:keyData forKey:kDB_USERDEFAULTS_ENCRYPTION_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        @try {
            [databaseConfig setEncryptionKey:keyData];
        }
        @catch (NSException *exception) {
            return exception;
        }
    }
    
    // SET CONFIG
    NSLog(@"DB: CONFIGURING REALM...");
    [RLMRealmConfiguration setDefaultConfiguration:databaseConfig];
    // OPEN REALM
    NSLog(@"DB: OPENING REALM...");
    @try {
        [RLMRealm defaultRealm];
        NSLog(@"DB: ALL REALM OBJECTS...\n\n%@", [[DBCaptain allObjects] description]);
    }
    @catch (NSException *exception) {
        return exception;
    }
    return nil;
}

@end
