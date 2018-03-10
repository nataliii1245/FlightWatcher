//
// Created by Natalia Volkova on 16.02.2018.
// Copyright (c) 2018 Natalia Volkova. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "DataManager.h"
#import "FavoriteTicket+CoreDataClass.h"
#import "Ticket.h"
#import "TicketSortOrder.h"


@interface CoreDataHelper : NSObject

+ (instancetype)sharedInstance;

- (BOOL)isFavorite:(Ticket *)ticket;

- (NSArray *)favorites;

- (NSArray *)favoritesSortedBy:(TicketSortOrder)order ascending:(BOOL)ascending fiteredBy:(TicketFilter)filter;

- (void)addToFavorites:(Ticket *)ticket fromMap:(BOOL)fromMap;

- (void)removeFromFavorites:(Ticket *)ticket;

@end
