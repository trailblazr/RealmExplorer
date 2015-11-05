//
//  DatabaseModel.h
//  RealmExplorer
//
//  Created by Lincoln Six Echo on 02.11.15.
//  Copyright © 2015 appdoctors UG. All rights reserved.
//

@class DBCaptain;
@class DBYacht;

RLM_ARRAY_TYPE(DBCaptain)
RLM_ARRAY_TYPE(DBYacht)

// YACHT ENTITY (INTRODUCED IN SCHEMA VERSION 3)
#if kDB_IS_MIN_SCHEMA_3
@interface DBYacht : RLMObject
@property NSString              *name;
@property NSString              *callsign;
@property NSString              *mmsi;
@property BOOL                  isActive;
@property (readonly) NSArray    *owners; // Realm doesn't persist this property because it is readonly
@end
#endif

// CAPTAIN ENTITY (SCHEMA VERSIONS 0 to 4)
@interface DBCaptain : RLMObject
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

