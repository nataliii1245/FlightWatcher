//
// Created by Natalia Volkova on 09.02.2018.
// Copyright (c) 2018 Natalia Volkova. All rights reserved.
//

#import "LocationService.h"
#import <UIKit/UIKit.h>

@interface LocationService () <CLLocationManagerDelegate>

@property(nonatomic, strong) CLLocationManager *locationManager;
@property(strong, nonatomic) CLLocation *currentLocation;

@end

@implementation LocationService

- (instancetype)init {
    self = [super init];
    if (self) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        [_locationManager requestAlwaysAuthorization];
    }
    
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [_locationManager startUpdatingLocation];
    } else if (status != kCLAuthorizationStatusNotDetermined) {
        UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", @"Error")
                                            message:NSLocalizedString(@"Couldn't detect current locality", @"Couldn't detect current locality")
                                     preferredStyle:UIAlertControllerStyleAlert];
        alertController.view.tintColor = [UIColor blackColor];
        
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Close", @"Close")
                                                            style:(UIAlertActionStyleDefault)
                                                          handler:nil]];
        
        [UIApplication.sharedApplication.keyWindow.rootViewController
                presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray < CLLocation *> *)locations {
    if (!_currentLocation) {
        _currentLocation = [locations firstObject];
        [_locationManager stopUpdatingLocation];
        [[NSNotificationCenter defaultCenter]
                postNotificationName:kLocationServiceDidUpdateCurrentLocation object:_currentLocation];
    }
}

- (void)cityNameForLocation:(CLLocation *)location completeWithName:(void(^)(NSString * name))completion {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> *placemarks, NSError *error) {
        if (error) {
            NSLog(@"CLGeocoder error: %@", error);
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(placemarks.firstObject.locality);
        });
    }];
}

@end
