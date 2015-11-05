//
//  CaptainFormPartBasics.h
//  RealmExplorer
//
//  Created by Lincoln Six Echo on 04.11.15.
//  Copyright © 2015 appdoctors UG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"
#import "DatabaseModel.h"
#import "CustomButtonCell.h"
#import "YachtForm.h"

@interface CaptainFormPartBasics : NSObject<FXForm>

@property UIButton* saveButton;

#if kDB_IS_MIN_SCHEMA_0
@property NSInteger index;
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
@property YachtForm  *yachtNames;
#endif

#if kDB_IS_MIN_SCHEMA_4
@property UIImage    *avatarImage;
#endif

@end
