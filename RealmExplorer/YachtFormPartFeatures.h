//
//  YachtFormPartFeatures.h
//  RealmExplorer
//
//  Created by Lincoln Six Echo on 04.11.15.
//  Copyright © 2015 appdoctors UG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"

@interface YachtFormPartFeatures : NSObject <FXForm>

@property (nonatomic, copy) NSString *yearBuild;
@property (nonatomic, copy) NSString *yearBought;
@property (nonatomic, copy) NSString *manufacturer;
@property (nonatomic, copy) NSNumber *lengthInMeters;
@property (nonatomic, copy) NSNumber *depthInMeters;
@property (nonatomic, copy) NSNumber *widthInMeters;
@property (nonatomic, copy) NSString *comment;

@end
