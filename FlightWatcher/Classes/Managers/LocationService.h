//
// Created by Natalia Volkova on 09.02.2018.
// Copyright (c) 2018 Natalia Volkova. All rights reserved.
//


#import <CoreLocation/CoreLocation.h>
#define kLocationServiceDidUpdateCurrentLocation @"LocationServiceDidUpdateCurrentLocation"

@interface LocationService : NSObject

- (void)cityNameForLocation:(CLLocation *)location completeWithName:(void (^)(NSString *))completion;

@end
