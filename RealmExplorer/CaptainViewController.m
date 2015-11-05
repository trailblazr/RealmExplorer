//
//  CaptainViewController.m
//  RealmExplorer
//
//  Created by Lincoln Six Echo on 02.11.15.
//  Copyright © 2015 appdoctors UG. All rights reserved.
//

#import "CaptainViewController.h"
#import "DatabaseModel.h"
#import "YachtFormViewController.h"

@interface CaptainViewController ()

@property (nonatomic, strong) RLMResults *array;
@property (nonatomic, strong) RLMNotificationToken *notification;
@property (nonatomic, strong) DBCaptain *currentUser;
@property (nonatomic, assign) NSUInteger currentUserIndex;
@property (nonatomic, strong) UIBarButtonItem *deleteItem;
@property (nonatomic, strong) UIBarButtonItem *addYachtItem;
@property (nonatomic, strong) UIBarButtonItem *nextItem;
@property (nonatomic, strong) UIBarButtonItem *prevItem;

@end

@implementation CaptainViewController

@synthesize avatarButton;

#pragma mark - convenience

- (void) initUI {    
    // NAVBAR
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"+5 Users" style:UIBarButtonItemStyleDone target:self action:@selector(actionAddItemsInBackground:)];;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:0.0 green:0.6 blue:0.0 alpha:1.0];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStyleDone target:self action:@selector(actionRefresh:)];

    // TOOLBAR
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"+1 User" style:UIBarButtonItemStyleDone target:self action:@selector(actionAddItem:)];
    addItem.tintColor = [UIColor colorWithRed:0.0 green:0.6 blue:0.0 alpha:1.0];
    self.deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(actionDeleteItem:)];
    self.deleteItem.tintColor = [UIColor redColor];
    self.nextItem = [[UIBarButtonItem alloc] initWithTitle:@"Next ⟩" style:UIBarButtonItemStylePlain target:self action:@selector(actionNextItem:)];
    self.prevItem = [[UIBarButtonItem alloc] initWithTitle:@"⟨ Prev" style:UIBarButtonItemStylePlain target:self action:@selector(actionPrevItem:)];
    
#if kDB_IS_MIN_SCHEMA_3
    self.addYachtItem = [[UIBarButtonItem alloc] initWithTitle:@"+Yacht" style:UIBarButtonItemStylePlain target:self action:@selector(actionAddYacht:)];
    self.addYachtItem.tintColor = [UIColor colorWithRed:0.0 green:0.6 blue:0.0 alpha:1.0];
#endif
    
    UIBarButtonItem *flexiItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    UIBarButtonItem *flexiItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    UIBarButtonItem *flexiItem3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    
#if kDB_IS_MIN_SCHEMA_3
    self.toolbarItems = @[addItem,self.addYachtItem,flexiItem1,self.prevItem,flexiItem3,self.nextItem,flexiItem2,self.deleteItem];
#else
    self.toolbarItems = @[addItem,flexiItem1,self.prevItem,flexiItem3,self.nextItem,flexiItem2,self.deleteItem];
#endif
    self.navigationController.toolbarHidden = NO;
    
    // AVATAR BUTTON
    avatarButton.hidden = YES;
#if kDB_IS_MIN_SCHEMA_4
    avatarButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    avatarButton.hidden = NO;
#endif
    
    // SEARCHBAR
    querySearchBar.placeholder = @"userid";
    querySearchBar.showsCancelButton = YES;
    labelSearchResults.text = @"Enter text in searchbar.";
    
    // CRYPTO INDICATOR
    encryptedIndicatorImageView.image = [UIImage imageNamed:kDB_SCHEMA_ENCRYPTED ? @"encrypted" : @"unencrypted"];
    
}

#pragma mark - view handling

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initUI];
    [self actionRefresh:nil];
    
    // REGISTER FOR REALM NOTIFICATIONS (GETS CALLED IF REALM HAS CHANGES)
    __weak typeof(self) weakSelf = self;
    self.notification = [RLMRealm.defaultRealm addNotificationBlock:^(NSString *note, RLMRealm *realm) {
        [weakSelf actionRefresh:nil];
    }];
}

- (void) viewWillDisappear:(BOOL)animated {
    // UNREGISTER FOR REALM NOTIFICATIONS (OTHERWISE WARNINGS COME UP)
    [RLMRealm.defaultRealm removeNotification:self.notification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController * _Nonnull)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> * _Nonnull)info {
    UIImage *imageToSave = [info objectForKey:UIImagePickerControllerEditedImage];
    [avatarButton setImage:imageToSave forState:UIControlStateNormal];
#if kDB_IS_MIN_SCHEMA_4
    [[RLMRealm defaultRealm] beginWriteTransaction];
        if( self.currentUser ) {
            NSData *imageData = UIImagePNGRepresentation(imageToSave);
            self.currentUser.avatarImageData = imageData;
        }
    [[RLMRealm defaultRealm] commitWriteTransaction];
#endif
    [self dismissViewControllerAnimated:YES completion:^{
        // [self actionRefresh:nil]; // just to be sure
    }];
}

#pragma mark - user actions

- (IBAction)actionUploadAvatarImage:(id)sender {
#if kDB_IS_MIN_SCHEMA_4
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    // __weak typeof(self) weakSelf = self;
    controller.delegate = self;
    if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] ) {
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] ) {
        controller.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    controller.allowsEditing = YES;
    controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:controller.sourceType];
    [self presentViewController:controller animated:YES completion:^{
       //
    }];
#endif
}

- (IBAction)actionAddYacht:(id)sender {
#if kDB_IS_MIN_SCHEMA_3
    DBYacht *yachtCreated = nil;
    [[RLMRealm defaultRealm] beginWriteTransaction];
        yachtCreated = [DBYacht createInDefaultRealmWithValue:@[@"Nautilus", @"DK1337" ]];
        if( self.currentUser ) {
            [self.currentUser.yachts addObject:yachtCreated];
        }
    [[RLMRealm defaultRealm] commitWriteTransaction];
    if( yachtCreated ) {
        YachtFormViewController *yachtController = [[YachtFormViewController alloc] init];
        yachtController.yachtToEdit = yachtCreated;
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:NULL];
        [self.navigationController pushViewController:yachtController animated:YES];
    }

#endif
}


- (IBAction)actionAddItem:(id)sender {
    BOOL useTransactionBlock = YES;
    if( useTransactionBlock ) {
        [[RLMRealm defaultRealm] transactionWithBlock:^{
    #if kDB_IS_SCHEMA_0
            [DBCaptain createInDefaultRealmWithValue:@[@"Antonius", @"secret0", [NSDate date] ]];
    #endif
    #if kDB_IS_SCHEMA_1
            [DBCaptain createInDefaultRealmWithValue:@[@"Bernie", @"secret1", [NSDate date], [NSNumber numberWithInt:25]]];
    #endif
#if kDB_IS_SCHEMA_2
            [DBCaptain createInDefaultRealmWithValue:@[@"Charlie", @"secret2", [NSDate date], [NSNumber numberWithInt:25], @"male"]];
#endif
#if kDB_IS_MIN_SCHEMA_3
            [DBCaptain createInDefaultRealmWithValue:@[@"Donald", @"secret3", [NSDate date], [NSNumber numberWithInt:17], @"male"]];
#endif
            self.currentUser = nil; // important, refresh will be trigered by notification
        }];
    }
    else {
        [[RLMRealm defaultRealm] beginWriteTransaction];
        
            DBCaptain *addedUser = [[DBCaptain alloc] init];
            addedUser.userid = @"Frank";
            addedUser.password = @"s3cr34";
            addedUser.date = [NSDate date];
#if kDB_IS_MIN_SCHEMA_1
            addedUser.age = 45;
#endif
#if kDB_IS_MIN_SCHEMA_2
            addedUser.gender = @"female";
#endif
            [[RLMRealm defaultRealm] addObject:addedUser];
            self.currentUser = nil; // important, refresh will be trigered by notification
        
        [[RLMRealm defaultRealm] commitWriteTransaction];
    }
}

- (IBAction)actionAddItemsInBackground:(id)sender {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // Import many items in a background thread
    dispatch_async(queue, ^{
        // Get new realm and table since we are in a new thread
        RLMRealm *realmOnBackgroundThread = [RLMRealm defaultRealm];
        [realmOnBackgroundThread beginWriteTransaction];
        for (NSInteger index = 0; index < 5; index++) {
            // Add new DB object row via dictionary. Order is ignored.
            NSString *userid = [NSString stringWithFormat:@"Ernie #%i", (int)index+1];
#if kDB_IS_SCHEMA_0
            [DBCaptain createInRealm:realmOnBackgroundThread withValue:@{@"userid":userid, @"password":@"secret0", @"date":[NSDate date]}];
#endif
#if kDB_IS_SCHEMA_1
             [DBCaptain createInRealm:realmOnBackgroundThread withValue:@{@"userid":userid, @"password":@"secret1", @"date":[NSDate date], @"age":[NSNumber numberWithInt:25] }];
#endif
#if kDB_IS_MIN_SCHEMA_2
              [DBCaptain createInRealm:realmOnBackgroundThread withValue:@{@"userid":userid, @"password":@"secret2", @"date":[NSDate date], @"age":[NSNumber numberWithInt:25],@"gender":@"female"} ];
#endif
        }
        [realmOnBackgroundThread commitWriteTransaction];
    });
}

  - (IBAction)actionPrevItem:(id)sender {
      if( self.currentUserIndex == 0 ) {
          self.currentUserIndex = [self.array count]-1;
      }
      else {
          self.currentUserIndex--;
      }
      [self actionRefresh:nil];
  }

  - (IBAction)actionNextItem:(id)sender {
      self.currentUserIndex++;
      if( self.currentUserIndex > [self.array count]-1 ) {
          self.currentUserIndex = 0;
      }
      [self actionRefresh:nil];
  }

- (IBAction)actionDeleteItem:(id)sender {
    RLMRealm *realm = RLMRealm.defaultRealm;
    [realm beginWriteTransaction];
#if kDB_IS_MIN_SCHEMA_3
    [realm deleteObjects:self.currentUser.yachts]; // remove also yachts, if there are any
#endif
    [realm deleteObject:self.currentUser];
    self.currentUser = nil; // important, refresh will be triggered by notification
    [realm commitWriteTransaction];
}

- (IBAction)actionSearchForUserWithId:(NSString*)userId {
    // Query
    NSString *whereString = [NSString stringWithFormat:@"userid contains '%@'", userId];
    RLMResults *resultsName = [DBCaptain objectsWhere:whereString];
    NSLog( @"USERS FOUND: %li", (unsigned long)resultsName.count );

    labelSearchResults.text = resultsName.count ? [NSString stringWithFormat:@"Found %i entries.", (int)resultsName.count ] : @"No entries found!";
#if kDB_IS_MIN_SCHEMA_1
    // Queries are chainable!
    RLMResults *resultsAge = [resultsName objectsWhere:@"age > 25"];
    NSLog( @"USERS OLDER 25: %li", (unsigned long)resultsAge.count );
#endif
    
}
              
- (IBAction)actionRefresh:(id)sender {
    labelSchemaVersion.text = [NSString stringWithFormat:@"%i", (int)kDB_SCHEMA_VERSION];

    self.array = [[DBCaptain allObjects] sortedResultsUsingProperty:@"date" ascending:YES];
    self.navigationItem.title = [NSString stringWithFormat:@"%i %@", (int)[self.array count], ([self.array count] == 1) ? @"Captain" : @"Captains"];
    if( self.array && [self.array count] > 0 ) {
        self.deleteItem.enabled = YES;
        if( !self.currentUser ) {
            self.currentUser = [self.array lastObject];
            self.currentUserIndex = [self.array count]-1;
        }
        else {
            if( self.currentUserIndex > [self.array count]-1 ) {
                self.currentUserIndex = 0;
            }
            self.currentUser = [self.array objectAtIndex:self.currentUserIndex];
        }
        labelUserIndex.text = [NSString stringWithFormat:@"#%i", (int)self.currentUserIndex];
        labelUserid.text = self.currentUser.userid;
        labelPassword.text = self.currentUser.password;
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.timeStyle = NSDateFormatterMediumStyle;
        df.dateStyle = NSDateFormatterMediumStyle;
        NSString *dateFormatted = [df stringFromDate:self.currentUser.date];
        df = nil;
        labelDate.text = dateFormatted;
#if kDB_IS_MIN_SCHEMA_1
        labelAge.text = [NSString stringWithFormat:@"%i", (int)self.currentUser.age]; // v1
#endif
#if kDB_IS_MIN_SCHEMA_2
        labelGender.text = self.currentUser.gender; // v2
#endif
#if kDB_IS_MIN_SCHEMA_3
        self.addYachtItem.enabled = ( self.currentUser != nil );
        NSUInteger numOfYachts = [self.currentUser.yachts count];
        labelYachts.text = [NSString stringWithFormat:@"%@", (numOfYachts == 0) ? @"None" : [NSString stringWithFormat:@"%i", (int)numOfYachts]];
#endif
#if kDB_IS_MIN_SCHEMA_4
        if( !self.currentUser.avatarImageData || [self.currentUser.avatarImageData length] == 0 ) {
            [avatarButton setImage:nil forState:UIControlStateNormal];
            [avatarButton setBackgroundImage:[UIImage imageNamed:@"avatar_edit"] forState:UIControlStateNormal];
        }
        else {
            UIImage *avatarimage = [UIImage imageWithData:self.currentUser.avatarImageData];
            [avatarButton setImage:avatarimage forState:UIControlStateNormal];
            [avatarButton setBackgroundImage:nil forState:UIControlStateNormal];
        }
#endif
    }
    else {
        self.deleteItem.enabled = NO;
        labelUserIndex.text = @"-";
        labelUserid.text = @"-";
        labelPassword.text = @"-";
        labelDate.text = @"-";
        labelAge.text = @"-";
        labelGender.text = @"-";
        labelYachts.text = @"-";
    }
    
    // CHECK UI ELEMENTS WHICh NEED A USER TO WORK & MAKE SENSE
#if kDB_IS_MIN_SCHEMA_0
    self.nextItem.enabled = ( self.currentUser != nil );
    self.prevItem.enabled = ( self.currentUser != nil );
#endif

#if kDB_IS_MIN_SCHEMA_3
    self.addYachtItem.enabled = ( self.currentUser != nil );
#endif
    
#if kDB_IS_MIN_SCHEMA_4
    if( !self.currentUser ) {
        avatarButton.enabled = NO;
        [avatarButton setImage:nil forState:UIControlStateNormal];
        [avatarButton setBackgroundImage:[UIImage imageNamed:@"avatar_edit"] forState:UIControlStateNormal];
    }
    else {
        avatarButton.enabled = YES;
    }
#endif
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar * _Nonnull)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar * _Nonnull)searchBar {
    [searchBar resignFirstResponder];
    [self actionSearchForUserWithId:searchBar.text];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar * _Nonnull)searchBar {
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar * _Nonnull)searchBar {
    return YES;
}

- (void)searchBar:(UISearchBar * _Nonnull)searchBar textDidChange:(NSString * _Nonnull)searchText {
    NSLog( @"%s", __PRETTY_FUNCTION__ );
}

- (void)searchBarTextDidBeginEditing:(UISearchBar * _Nonnull)searchBar {
    NSLog( @"%s", __PRETTY_FUNCTION__ );
}

- (void)searchBarTextDidEndEditing:(UISearchBar * _Nonnull)searchBar {
    NSLog( @"%s", __PRETTY_FUNCTION__ );
}

@end
