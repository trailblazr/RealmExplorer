//
//  YachtFormPartBasics.h
//  RealmExplorer
//
//  Created by Lincoln Six Echo on 04.11.15.
//  Copyright © 2015 appdoctors UG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"

@interface YachtFormPartBasics : NSObject <FXForm>

@property UIButton* saveButton;

@property (nonatomic, copy) NSString *yacht;
@property (nonatomic, copy) NSString *callsign;
@property (nonatomic, copy) NSString *mmsi;
@property (nonatomic, assign) BOOL active;

@end
