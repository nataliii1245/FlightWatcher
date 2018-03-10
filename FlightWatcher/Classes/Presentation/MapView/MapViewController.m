//
// Created by Natalia Volkova on 10.02.2018.
// Copyright (c) 2018 Natalia Volkova. All rights reserved.
//

#import "LocationService.h"
#import "APIManager.h"
#import "DataManager.h"
#import "MapViewController.h"
#import "MapPrice.h"
#import "CoreDataHelper.h"

@interface MapViewController () <MKMapViewDelegate>

@property(nonatomic, strong) MKMapView *mapView;
@property(nonatomic, strong) LocationService *locationService;
@property(nonatomic, strong) City *origin;
@property(nonatomic, strong) NSArray *prices;
@property(strong) UILabel *currentLocationLabel;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Prices map", @"Prices map");
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    _mapView.tintColor = [UIColor blackColor];
    
    [self.view addSubview:_mapView];
    
    [DataManager.sharedInstance loadData];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(dataLoadedSuccessfully)
                                               name:kDataManagerLoadDataDidComplete object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateCurrentLocation:)
                                               name:kLocationServiceDidUpdateCurrentLocation object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleLocalNotification)
                                               name:@"DidReceiveNotificationResponse" object:nil];

    CGRect currentLocationFrame = CGRectMake(0, 0, _mapView.bounds.size.width, 44.0);
    _currentLocationLabel = [[UILabel alloc] initWithFrame:currentLocationFrame];
    _currentLocationLabel.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.9];
    _currentLocationLabel.layer.cornerRadius = 10.0;
    _currentLocationLabel.textAlignment = NSTextAlignmentCenter;
    _currentLocationLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightSemibold];
    [self.view addSubview:_currentLocationLabel];
}

- (void)viewWillAppear:(BOOL)animated {
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _mapView.frame = self.view.bounds;
    _currentLocationLabel.frame = CGRectMake(0, 0, _mapView.bounds.size.width, 44.0);
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dataLoadedSuccessfully {
    _locationService = [[LocationService alloc] init];
}

- (void)updateCurrentLocation:(NSNotification *)notification {
    CLLocation *currentLocation = notification.object;

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate,
            1000000, 1000000);
    [_mapView setRegion:region animated:YES];
    if (currentLocation) {
        _origin = [DataManager.sharedInstance cityForLocation:currentLocation];
        if (_origin) {
            [APIManager.sharedInstance mapPricesFor:_origin withCompletion:^(NSArray *prices) {
                self.prices = prices;
            }];
        }
    }

    [_locationService cityNameForLocation:currentLocation completeWithName:^(NSString *name) {
        _currentLocationLabel.text = name;
    }];
}

- (void)setPrices:(NSArray *)prices {
    _prices = prices;
    [_mapView removeAnnotations:_mapView.annotations];
    
    for (MapPrice *price in prices) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.title = [NSString stringWithFormat:@"%@", price.destination.name];
            annotation.subtitle = [NSString stringWithFormat:@"%ld₽", price.value];
            annotation.coordinate = price.destination.coordinate;
            [_mapView addAnnotation:annotation];
        });
    }
}


#pragma mark - Map view delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if (annotation == mapView.userLocation) {
        return nil;
    }
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationReuseIdentifier"];

    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    for (MapPrice *price in _prices) {
        if (price.destination.name == view.annotation.title) {
            [APIManager.sharedInstance requestTicketWithMapPrice:price completion:^(Ticket *ticket) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Ticket to %@ for %@", @"Ticket to %@ for %@"), view.annotation.title, view.annotation.subtitle]
                                                                                         message:NSLocalizedString(@"What to do with the ticket?", @"What to do with the ticket?")
                                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
                alertController.view.tintColor = [UIColor blackColor];
                
                UIAlertAction *favoriteAction;
                if ([CoreDataHelper.sharedInstance isFavorite:ticket]) {
                    favoriteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Remove from favorites", @"Remove from favorites")
                                                              style:UIAlertActionStyleDestructive
                                                            handler:^(UIAlertAction *_Nonnull action) {
                                                                [CoreDataHelper.sharedInstance
                                                                        removeFromFavorites:ticket];
                                                            }];
                } else {
                    favoriteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Add to favorites", @"Add to favorites")
                                                              style:UIAlertActionStyleDefault
                                                            handler:
                                                                    ^(UIAlertAction *_Nonnull action) {
                                                                        [CoreDataHelper.sharedInstance
                                                                                addToFavorites:ticket fromMap:YES];
                                                                    }];
                }

                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Close", @"Close")
                                                                       style:UIAlertActionStyleCancel
                                                                     handler:nil];
                [alertController addAction:favoriteAction];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }];
        }
    }
}

#pragma mark - Local notification handling

- (void)handleLocalNotification {
    [self.tabBarController setSelectedIndex:(NSUInteger) 2];
}

@end
