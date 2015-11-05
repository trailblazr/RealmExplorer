//
//  CaptainViewController.h
//  RealmExplorer
//
//  Created by Lincoln Six Echo on 02.11.15.
//  Copyright © 2015 appdoctors UG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaptainViewController : UIViewController<UISearchBarDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {

    IBOutlet UILabel *labelUserIndex;
    IBOutlet UILabel *labelUserid;
    IBOutlet UILabel *labelPassword;
    IBOutlet UILabel *labelDate;
    IBOutlet UILabel *labelAge;
    IBOutlet UILabel *labelGender;
    IBOutlet UILabel *labelYachts;
    IBOutlet UILabel *labelSchemaVersion;
    IBOutlet UILabel *labelSearchResults;
    IBOutlet UIScrollView *contentScrollView;
    IBOutlet UISearchBar *querySearchBar;
    IBOutlet UIImageView *encryptedIndicatorImageView;
    IBOutlet UIButton *avatarButton;
}

@property( nonatomic, strong ) UIButton *avatarButton;

@end

