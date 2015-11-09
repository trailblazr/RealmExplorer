//
//  YachtFormViewController.m
//  RealmExplorer
//
//  Created by Lincoln Six Echo on 04.11.15.
//  Copyright © 2015 appdoctors UG. All rights reserved.
//

#import "YachtFormViewController.h"
#import "YachtForm.h"
#import "YachtFormPartBasics.h"
#import "YachtFormPartFeatures.h"
#import "DatabaseModel.h"

@interface YachtFormViewController ()

@property (nonatomic, assign) BOOL hasPendingChanges;


@end

@implementation YachtFormViewController

@synthesize yachtToEdit;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        //set up form
        self.formController.form = [[YachtForm alloc] init];
    }
    return self;
}

- (YachtForm*)defaultForm {
    return ((YachtForm*)self.formController.form);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Yacht";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:NO];
    // INIT WITH EXISTING VALUES
#if kDB_IS_MIN_SCHEMA_3
    if( self.yachtToEdit ) {
        [self defaultForm].basics.yacht = self.yachtToEdit.name;
        [self defaultForm].basics.callsign = self.yachtToEdit.callsign;
        [self defaultForm].basics.mmsi = self.yachtToEdit.mmsi;
        [self defaultForm].basics.active = self.yachtToEdit.isActive;
    }
#endif
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationUserEnteredText:) name:FXFormNotificationFieldChanged object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self submitYachtFormPartBasics];
    [self.navigationController setToolbarHidden:NO animated:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)notificationUserEnteredText:(NSNotification*)notification {
    FXFormField *field = (FXFormField*)notification.object;
    NSLog( @"FORM: TEXT CHANGED... %@: %@", field.key, field.value );
}

- (void)markSaveButtonAsNeedsSave:(BOOL)needsSave {
    UIButton *saveButton = [self defaultForm].basics.saveButton;
    saveButton.backgroundColor = needsSave ? [UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0] : [UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0]; // 0x64C864;
}

- (void)validateAndSave:(id)sender {
    self.hasPendingChanges = YES;
    [self markSaveButtonAsNeedsSave:YES];
}

- (void)submitYachtFormPartBasics {
#if kDB_IS_MIN_SCHEMA_3
    if( self.yachtToEdit ) {
        NSLog( @"FORM: SAVING DATA..." );
        NSLog( @"FORM: yachtname = %@", [self defaultForm].basics.yacht );
        // NSLog( @"FORM: callsign = %@", [self defaultForm].basics.callsign );
        [[RLMRealm defaultRealm] beginWriteTransaction];
        self.yachtToEdit.name = [self defaultForm].basics.yacht;
        self.yachtToEdit.callsign = [self defaultForm].basics.callsign;
        self.yachtToEdit.mmsi = [self defaultForm].basics.mmsi;
        self.yachtToEdit.isActive = [self defaultForm].basics.active;
        [self.yachtToEdit entityPrepareForSave];
        [[RLMRealm defaultRealm] commitWriteTransaction];
        self.hasPendingChanges = NO;
        [self markSaveButtonAsNeedsSave:NO];
    }
#endif
}

@end
