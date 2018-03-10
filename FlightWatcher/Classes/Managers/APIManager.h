//
// Created by Natalia Volkova on 05.02.2018.
// Copyright (c) 2018 Natalia Volkova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"
#import "SearchRequest.h"

@class MapPrice;
@class Ticket;

@interface APIManager : NSObject

+ (instancetype)sharedInstance;

- (void)cityForCurrentIP:(void (^)(City *city))completion;
- (void)ticketsWithRequest:(SearchRequest)request withCompletion:(void (^)(NSArray *tickets))completion;
- (void)requestTicketWithMapPrice:(MapPrice *)mapPrice completion:(void (^)(Ticket *ticket))completion;
- (NSURL *)urlWithAirlineLogoForIATACode:(NSString *)code;
- (void)mapPricesFor:(City *)origin withCompletion:(void (^)(NSArray *prices))completion;

@end
