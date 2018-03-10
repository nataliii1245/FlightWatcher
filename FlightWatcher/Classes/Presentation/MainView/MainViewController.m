//
//  MainViewController.m
//  FlightWatcher
//
//  Created by Natalia Volkova on 30.01.2018.
//  Copyright © 2018 Natalia Volkova. All rights reserved.
//

#import "MainViewController.h"
#import "DataSourceTypeEnum.h"
#import "TicketsViewController.h"
#import "MainView.h"
#import "DataManager.h"
#import "PlacesTableViewController.h"
#import "SearchRequest.h"
#import "APIManager.h"
#import "Airport.h"


@interface MainViewController () <PlaceViewControllerDelegate>

@property (nonatomic) SearchRequest searchRequest;
@property (strong) TicketsViewController *searchResultsCollectionViewController;

@end


@implementation MainViewController {
    
    UIToolbar *keyboardToolbar;
    BOOL selectingDepartureDate;
    NSDateFormatter *dateFormatter;
    
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [DataManager.sharedInstance loadData];
    [self performViewInitialization];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataLoadingCompletion)
                                                 name:kDataManagerLoadDataDidComplete
                                               object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(handleLocalNotification)
                                               name:@"DidReceiveNotificationResponse"
                                             object:nil];
    
    selectingDepartureDate = true;
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.minimumDate = [NSDate date];
    _dateTextField = [[UITextField alloc] initWithFrame:self.view.bounds];
    _dateTextField.hidden = YES;
    _dateTextField.inputView = _datePicker;
    keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *resetBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Remove", @"Remove") style:UIBarButtonItemStyleDone target:self action:@selector(resetButtonDidTap)];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self
                                      action:@selector(doneButtonDidTap:)];
    keyboardToolbar.items = @[resetBarButton, flexBarButton, doneBarButton];
    _dateTextField.inputAccessoryView = keyboardToolbar;
    [self.view addSubview:_dateTextField];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = NO;

    self.navigationController.navigationBar.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    self.navigationController.navigationBar.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kDataManagerLoadDataDidComplete
                                                  object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self
                                                  name:@"DidReceiveNotificationResponse"
                                                object:nil];
}


#pragma mark - View Initialization

- (void)performViewInitialization {
    self.view = [[MainView alloc] initWithFrame:self.view.frame];
    self.navigationItem.title = NSLocalizedString(@"Ticket search", @"Ticket search");
}


#pragma mark - Loading data

- (void)dataLoadingCompletion {
    [self.view performSelector:@selector(activateButtons)];
    [APIManager.sharedInstance cityForCurrentIP:^(City *city) {
        [self setPlace:city ofType:DataSourceTypeCity isOrigin:YES];
    }];
}


#pragma mark - Navigation

- (void)searchButtonPressed {
    [APIManager.sharedInstance ticketsWithRequest:_searchRequest withCompletion:^(NSArray *tickets) {
        if (tickets.count > 0) {
            _searchResultsCollectionViewController = [[TicketsViewController alloc] initWithTickets:tickets];
            [self.navigationController pushViewController:_searchResultsCollectionViewController animated:YES];
        } else {
            UIAlertController *alertController =
                    [UIAlertController alertControllerWithTitle:@""
                                                        message:NSLocalizedString(@"No tickets found with current settings", @"No tickets found with current settings")
                                                 preferredStyle:UIAlertControllerStyleAlert];
            alertController.view.tintColor = [UIColor blackColor];

            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Close", @"Close")
                                                                style:(UIAlertActionStyleDefault) handler:nil]];

            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

- (void)presentOriginSelectionView {
    PlacesTableViewController *controller = [[PlacesTableViewController alloc]
            initWithStyle:UITableViewStylePlain
           toReturnOrigin:true];
    controller.delegate = self;
    
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)presentDestinationSelectionView {
    PlacesTableViewController *controller = [[PlacesTableViewController alloc]
            initWithStyle:UITableViewStylePlain
           toReturnOrigin:false];
    controller.delegate = self;
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Buttons' actions

-(void)presentDepartureDateBox {
    selectingDepartureDate = true;
    _datePicker.minimumDate = [NSDate date];
    _datePicker.date = (_searchRequest.departDate) ?: [NSDate date];
    [_dateTextField becomeFirstResponder];
}

-(void)presentReturnDateBox {
    selectingDepartureDate = false;
    _datePicker.minimumDate = (_searchRequest.departDate) ?: [NSDate date];
    _datePicker.date = (_searchRequest.returnDate) ?: [NSDate date];
    [_dateTextField becomeFirstResponder];
}

- (void)doneButtonDidTap:(UIBarButtonItem *)sender {
    if (selectingDepartureDate) {
        _searchRequest.departDate = _datePicker.date;
        [(MainView *) self.view setDateButtonTitle:[dateFormatter stringFromDate:_datePicker.date] forDepartureDateButton:YES];
    } else {
        _searchRequest.returnDate = _datePicker.date;
        [(MainView *) self.view setDateButtonTitle:[dateFormatter stringFromDate:_datePicker.date] forDepartureDateButton:NO];
    }
    
    [self.view endEditing:YES];
}


- (void)resetButtonDidTap {
    if (selectingDepartureDate) {
        _searchRequest.departDate = nil;
        [(MainView *) self.view setDateButtonTitle:NSLocalizedString(@"not specified", @"not specified") forDepartureDateButton:YES];
    } else {
        _searchRequest.returnDate = nil;
        [(MainView *) self.view setDateButtonTitle:NSLocalizedString(@"not specified", @"not specified") forDepartureDateButton:NO];
    }
    
    [self.view endEditing:YES];
}


#pragma mark - PlaceViewControllerDelegate

- (void)selectPlace:(id)place withType:(BOOL)isOrigin andDataType:(DataSourceType)dataType {
    [self setPlace:place ofType:dataType isOrigin:isOrigin];
}

- (void)setPlace:(id)place ofType:(DataSourceType)dataType isOrigin:(BOOL)isOrigin {
    NSString *title;
    NSString *data;
    
    if (dataType == DataSourceTypeCity) {
        City *city = (City *) place;
        title = city.name;
        data = city.code;
    } else if (dataType == DataSourceTypeAirport) {
        Airport *airport = (Airport *) place;
        title = airport.name;
        data = airport.cityCode;
    }
    
    if (isOrigin) {
        _searchRequest.origin = data;
    } else {
        _searchRequest.destination = data;
    }

    [(MainView *) self.view setPlaceButtonTitle:title forOriginButton:isOrigin];
}

#pragma mark - Local notification handling

- (void)handleLocalNotification {
    [self.tabBarController setSelectedIndex:(NSUInteger) 2];
}

@end
