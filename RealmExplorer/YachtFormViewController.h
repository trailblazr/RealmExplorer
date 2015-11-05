//
//  YachtFormViewController.h
//  RealmExplorer
//
//  Created by Lincoln Six Echo on 04.11.15.
//  Copyright © 2015 appdoctors UG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXForms.h"
#import "DatabaseModel.h"

@interface YachtFormViewController : FXFormViewController {

    DBYacht *yachtToEdit;
    
}

@property (nonatomic, strong) DBYacht *yachtToEdit;

@end
