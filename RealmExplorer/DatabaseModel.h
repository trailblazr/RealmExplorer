//
//  DatabaseModel.h
//  RealmExplorer
//
//  Created by Lincoln Six Echo on 02.11.15.
//  Copyright © 2015 appdoctors UG. All rights reserved.
//

@class DBCaptain;
@class DBYacht;
@class DBAutoGeneric;

RLM_ARRAY_TYPE(DBCaptain)
RLM_ARRAY_TYPE(DBYacht)

#pragma mark - ENTITY: DBGeneric (PROPERTIES ALL ENTITIES SHOULD HAVE VIA INHERITANCE)

// THIS WILL CREATE AN EMPTY TABLE IN THE DB, BUT IT IS & SHOULD NEVER BE USED
@interface DBAutoGeneric : RLMObject

// PRIMARY KEY ALL ENTITIES SHOULD IMPLEMENT (EVERY ENTITY NEEDS TO IMPLEMENT ITS OWN)
@property (nonatomic, retain ) NSString             *PKID;

// PROPERTIES ALL ENTITIES SHOULD HAVE
@property (nonatomic, retain ) NSDate               *dateCreated;
@property (nonatomic, retain ) NSDate               *dateChanged;

// METHODS ALL ENTITIES SHOULD SUPPORT
- (void) entityPrepareForSave;

@end

// YACHT ENTITY (INTRODUCED IN SCHEMA VERSION 3)
#if kDB_IS_MIN_SCHEMA_3
@interface DBYacht : DBAutoGeneric
@property NSString              *name;
@property NSString              *callsign;
@property NSString              *mmsi;
@property BOOL                  isActive;
@property (readonly) NSArray    *owners; // Realm doesn't persist this property because it is readonly
@end
#endif

// CAPTAIN ENTITY (SCHEMA VERSIONS 0 to 4)
@interface DBCaptain : DBAutoGeneric
#if kDB_IS_MIN_SCHEMA_0
@property NSString *userid;
@property NSString *password;
@property NSDate   *date;
#endif

#if kDB_IS_MIN_SCHEMA_1
@property int       age;
#endif

#if kDB_IS_MIN_SCHEMA_2
@property NSString  *gender;
#endif

#if kDB_IS_MIN_SCHEMA_3
@property RLMArray<DBYacht> *yachts;
#endif

#if kDB_IS_MIN_SCHEMA_4
@property NSData    *avatarImageData;
#endif
@end

