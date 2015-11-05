//
//  YachtForm.h
//  RealmExplorer
//
//  Created by Lincoln Six Echo on 04.11.15.
//  Copyright © 2015 appdoctors UG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"
#import "YachtFormPartBasics.h"
#import "YachtFormPartFeatures.h"

@interface YachtForm : NSObject<FXForm>

@property (nonatomic, strong) YachtFormPartBasics *basics;
//@property (nonatomic, strong) YachtFormPartFeatures *features;

@end
