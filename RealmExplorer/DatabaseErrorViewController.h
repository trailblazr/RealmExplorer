//
//  DatabaseErrorViewController.h
//  RealmExplorer
//
//  Created by Lincoln Six Echo on 04.11.15.
//  Copyright © 2015 appdoctors UG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatabaseErrorViewController : UIViewController {

    NSException *dbException;
    IBOutlet UILabel *exceptionLabel;
}

@property( nonatomic, strong ) NSException *dbException;
@property( nonatomic, strong ) UILabel *exceptionLabel;

@end
