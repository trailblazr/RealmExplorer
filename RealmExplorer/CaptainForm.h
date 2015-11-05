//
//  CaptainForm.h
//  RealmExplorer
//
//  Created by Lincoln Six Echo on 04.11.15.
//  Copyright © 2015 appdoctors UG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"
#import "CaptainFormPartBasics.h"
#import "CaptainFormPartsRealm.h"

@interface CaptainForm : NSObject<FXForm>

@property (nonatomic, strong) CaptainFormPartBasics *basics;
@property (nonatomic, strong) CaptainFormPartsRealm *realm;

@end
