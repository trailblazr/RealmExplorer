//
//  CaptainFormViewController.m
//  RealmExplorer
//
//  Created by Lincoln Six Echo on 04.11.15.
//  Copyright © 2015 appdoctors UG. All rights reserved.
//

#import "FXForms.h"
#import "CaptainFormViewController.h"
#import "CaptainForm.h"
#import "CaptainFormPartBasics.h"
#import "YachtFormViewController.h"
#import "CustomButtonCell.h"

@interface CaptainFormViewController ()

@property (nonatomic, strong) RLMResults *array;
@property (nonatomic, strong) RLMNotificationToken *notification;
@property (nonatomic, assign) NSUInteger currentUserIndex;
@property (nonatomic, strong) UIBarButtonItem *deleteItem;
@property (nonatomic, strong) UIBarButtonItem *addYachtItem;
@property (nonatomic, strong) UIBarButtonItem *nextItem;
@property (nonatomic, strong) UIBarButtonItem *prevItem;
@property (nonatomic, assign) BOOL hasPendingChanges;

@end

@implementation CaptainFormViewController

@synthesize captainToEdit;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        //set up form
        self.formController.form = [[CaptainForm alloc] init];
    }
    return self;
}

#pragma mark - convenience

- (CaptainForm*)defaultForm {
    return ((CaptainForm*)self.formController.form);
}

- (void) initUI {
    // NAVBAR
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAddItem:)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:0.0 green:0.6 blue:0.0 alpha:1.0];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(actionSearch:)];
    
    // TOOLBAR
    self.deleteItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(actionDeleteItem:)];
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
    self.toolbarItems = @[self.addYachtItem,flexiItem1,self.prevItem,flexiItem3,self.nextItem,flexiItem2,self.deleteItem];
#else
    self.toolbarItems = @[flexiItem1,self.prevItem,flexiItem2,self.nextItem,flexiItem3,self.deleteItem];
#endif
    self.navigationController.toolbarHidden = NO;    
}


#pragma mark - view handling

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Captain";
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:NO];
    // REGISTER FOR REALM NOTIFICATIONS (GETS CALLED IF REALM HAS CHANGES)
    __weak typeof(self) weakSelf = self;
    self.notification = [RLMRealm.defaultRealm addNotificationBlock:^(NSString *note, RLMRealm *realm) {
        [weakSelf actionRefresh:nil];
    }];
    if( self.hasPendingChanges ) {
        [self submitCaptainFormPartBasics];
    }
    else {
        [self actionRefresh:nil];
    }
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationUserEnteredText:) name:FXFormNotificationFieldChanged object:nil];
}

- (void) viewWillDisappear:(BOOL)animated {
    // UNREGISTER FOR REALM NOTIFICATIONS (OTHERWISE WARNINGS COME UP)
    [RLMRealm.defaultRealm removeNotification:self.notification];
    if( self.hasPendingChanges ) {
        [self submitCaptainFormPartBasics];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:NO];
    if( !self.captainToEdit ) {
        self.navigationController.view.alpha = 0.0;
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"New Captain created"
                                                                       message:@"There was an empty database, so we created a first entity for DBCaptain."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [UIView animateWithDuration:0.7 animations:^{
                                                                      self.navigationController.view.alpha = 1.0;
                                                                  }];
                                                              }];
        
        [alert addAction:defaultAction];
        // ADD USER
        [[RLMRealm defaultRealm] beginWriteTransaction];
        
        DBCaptain *addedUser = [[DBCaptain alloc] init];
        addedUser.userid = @"George";
        addedUser.password = @"secretkey";
        addedUser.date = [NSDate date];
        [addedUser entityPrepareForSave];
#if kDB_IS_MIN_SCHEMA_1
        addedUser.age = 35;
#endif
#if kDB_IS_MIN_SCHEMA_2
        addedUser.gender = @"male";
#endif
        [[RLMRealm defaultRealm] addObject:addedUser];
        
        [[RLMRealm defaultRealm] commitWriteTransaction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}


#pragma mark - user actions

- (IBAction)actionAddYacht:(id)sender {
#if kDB_IS_MIN_SCHEMA_3
    if( self.hasPendingChanges ) {
        [self submitCaptainFormPartBasics];
    }
    DBYacht *yachtCreated = nil;
    if( self.captainToEdit ) {
        [[RLMRealm defaultRealm] beginWriteTransaction];
        yachtCreated = [[DBYacht alloc] init];
        yachtCreated.name = @"Nautilus";
        yachtCreated.callsign = @"DK1337";
        /*
         // WE DO NOT USE THIS BECAUSE IT IS TOO INFLEXIBLE, AND STARTS COUNTING AT THE PRIMARY KEY
         // ALSO WE LIKE TO KICK IN THE DEFAULT VALUES FOR PROPERTIES...
        yachtCreated = [DBYacht createInDefaultRealmWithValue:@[@"valueForProperty1", @"valueForProperty2"]];
         */
        [yachtCreated entityPrepareForSave];
        
        [self.captainToEdit.yachts addObject:yachtCreated];
        [self.captainToEdit entityPrepareForSave];

        [[RLMRealm defaultRealm] commitWriteTransaction];
    }
    if( yachtCreated ) {
        YachtFormViewController *yachtController = [[YachtFormViewController alloc] init];
        yachtController.yachtToEdit = yachtCreated;
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:NULL];
        [self.navigationController pushViewController:yachtController animated:YES];
    }
    
#endif
}


- (IBAction)actionAddItem:(id)sender {
    BOOL useTransactionBlock = NO;
    if( useTransactionBlock ) {
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            self.captainToEdit = nil; // important, refresh will be trigered by notification
            self.currentUserIndex = [self.array count];
            // DO MANIPULATE THE ENTITY HERE
        }];
    }
    else {
        [[RLMRealm defaultRealm] beginWriteTransaction];
        
        DBCaptain *addedUser = [[DBCaptain alloc] init];
        NSArray *userIds = @[@"Antonius",@"Bernie",@"Charlie",@"Donald",@"Frank"];
        NSArray *userPasswords = @[@"secret0",@"secret1",@"secret2",@"secret3",@"secret4"];
        NSArray *userAges = @[@0, @25, @28, @17, @45];
        NSArray *userGenders = @[@"male", @"female", @"male", @"female", @"male"];
        addedUser.userid = [userIds objectAtIndex:kDB_SCHEMA_VERSION];
        addedUser.password = [userPasswords objectAtIndex:kDB_SCHEMA_VERSION];
        addedUser.date = [NSDate date];
        [addedUser entityPrepareForSave];
#if kDB_IS_MIN_SCHEMA_1
        addedUser.age = [[userAges objectAtIndex:kDB_SCHEMA_VERSION] intValue];
#endif
#if kDB_IS_MIN_SCHEMA_2
        addedUser.gender = [userGenders objectAtIndex:kDB_SCHEMA_VERSION];
#endif
        [[RLMRealm defaultRealm] addObject:addedUser];
        self.captainToEdit = nil; // important, refresh will be trigered by notification
        self.currentUserIndex = [self.array count];
        
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
    if( self.hasPendingChanges ) {
        [self submitCaptainFormPartBasics];
    }
    else {
        [self actionRefresh:nil];
    }
}

- (IBAction)actionNextItem:(id)sender {
    self.currentUserIndex++;
    if( self.currentUserIndex > [self.array count]-1 ) {
        self.currentUserIndex = 0;
    }
    if( self.hasPendingChanges ) {
        [self submitCaptainFormPartBasics];
    }
    else {
        [self actionRefresh:nil];
    }
}

- (IBAction)actionDeleteItem:(id)sender {
    RLMRealm *realm = RLMRealm.defaultRealm;
    [realm beginWriteTransaction];
#if kDB_IS_MIN_SCHEMA_3
    [realm deleteObjects:self.captainToEdit.yachts]; // remove also yachts, if there are any
#endif
    [realm deleteObject:self.captainToEdit];
    self.captainToEdit = nil; // important, refresh will be triggered by notification
    [realm commitWriteTransaction];
}

- (IBAction)actionSearchForUserWithId:(NSString*)userId {
    /*
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
    */
}

- (IBAction)actionSearch:(id)sender {
    
}

- (IBAction)actionRefresh:(id)sender {
    self.array = [[DBCaptain allObjects] sortedResultsUsingProperty:@"dateCreated" ascending:YES];
    self.navigationItem.title = [NSString stringWithFormat:@"%i %@", (int)[self.array count], ([self.array count] == 1) ? @"Captain" : @"Captains"];
    if( self.array && [self.array count] > 0 ) {
        if( self.currentUserIndex > [self.array count]-1 ) {
            self.currentUserIndex = 0;
        }
        self.captainToEdit = [self.array objectAtIndex:self.currentUserIndex];
    }
    // POPULATE FX FORMS...
    if( self.captainToEdit ) {
#if kDB_IS_MIN_SCHEMA_0
        [self defaultForm].basics.index = self.currentUserIndex;
        [self defaultForm].basics.userid = self.captainToEdit.userid;
        [self defaultForm].basics.password = self.captainToEdit.password;
        [self defaultForm].basics.date = self.captainToEdit.date;
#endif
#if kDB_IS_MIN_SCHEMA_1
        if( self.captainToEdit.age > 0 ) {
            [self defaultForm].basics.age = self.captainToEdit.age;
        }
#endif
#if kDB_IS_MIN_SCHEMA_2
        [self defaultForm].basics.gender = self.captainToEdit.gender;
#endif
#if kDB_IS_MIN_SCHEMA_3
        NSMutableString *yachtNames = [NSMutableString string];
        if( captainToEdit.yachts && [captainToEdit.yachts count] > 0 ) {
            NSUInteger numYachts = [captainToEdit.yachts count];
            NSUInteger indexYacht = 0;
            for( DBYacht *currentYacht in captainToEdit.yachts ) {
                indexYacht++;
                [yachtNames appendFormat:@"%@%@", currentYacht.name, (indexYacht == numYachts) ? @"" : @", "];
            }
        }
        [self defaultForm].basics.yachtNames = [NSString stringWithString:yachtNames];
#endif
#if kDB_IS_MIN_SCHEMA_4
        if( self.captainToEdit.avatarImageData && [self.captainToEdit.avatarImageData length] > 0 ) {
            [self defaultForm].basics.avatarImage = [UIImage imageWithData:self.captainToEdit.avatarImageData];
        }
        else {
            [self defaultForm].basics.avatarImage = [UIImage imageNamed:@"avatar_edit"];
        }
#endif
    }

    
    // CHECK UI ELEMENTS WHICh NEED A USER TO WORK & MAKE SENSE
#if kDB_IS_MIN_SCHEMA_0
    self.nextItem.enabled = ( self.captainToEdit != nil );
    self.prevItem.enabled = ( self.captainToEdit != nil );
    self.deleteItem.enabled = ( self.captainToEdit != nil );
#endif
    
#if kDB_IS_MIN_SCHEMA_3
    self.addYachtItem.enabled = ( self.captainToEdit != nil );
#endif
    if( YES ) {
        [self.tableView reloadData];
    }
}


#pragma mark - data handling

- (void)markSaveButtonAsNeedsSave:(BOOL)needsSave {
    UIButton *saveButton = [self defaultForm].basics.saveButton;
    saveButton.backgroundColor = needsSave ? [UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0] : [UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0]; // 0x64C864;
}

- (void) editYacht {
#if kDB_IS_MIN_SCHEMA_3
    if( self.captainToEdit && [self.captainToEdit.yachts count] > 0 ) {
        YachtFormViewController *yachtController = [[YachtFormViewController alloc] init];
        yachtController.yachtToEdit = [self.captainToEdit.yachts firstObject];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:NULL];
        [self.navigationController pushViewController:yachtController animated:YES];
    }
#endif
}


- (void)validateAndSave:(id)sender {
    self.hasPendingChanges = YES;
    [self markSaveButtonAsNeedsSave:YES];
}

- (void)submitCaptainFormPartBasics {
    if( self.captainToEdit ) {
        NSLog( @"FORM: SAVING DATA..." );
        NSLog( @"FORM: userid = %@", [self defaultForm].basics.userid );
        // NSLog( @"FORM: password = %@", [self defaultForm].basics.password );
        
        [[RLMRealm defaultRealm] beginWriteTransaction];
#if kDB_IS_MIN_SCHEMA_0
        self.captainToEdit.userid = [self defaultForm].basics.userid;
        self.captainToEdit.password = [self defaultForm].basics.password;
        self.captainToEdit.date = [self defaultForm].basics.date;
        [self.captainToEdit entityPrepareForSave];
#endif
#if kDB_IS_MIN_SCHEMA_1
        self.captainToEdit.age = [self defaultForm].basics.age;
#endif
#if kDB_IS_MIN_SCHEMA_2
        self.captainToEdit.gender = [self defaultForm].basics.gender;
#endif
#if kDB_IS_MIN_SCHEMA_4
        NSData *imageData = UIImagePNGRepresentation([self defaultForm].basics.avatarImage);
        self.captainToEdit.avatarImageData = imageData;
#endif
        [[RLMRealm defaultRealm] commitWriteTransaction];
        self.hasPendingChanges = NO;
        [self markSaveButtonAsNeedsSave:NO];
    }
}

@end
