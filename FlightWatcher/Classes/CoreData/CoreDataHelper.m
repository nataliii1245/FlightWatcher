//
// Created by Natalia Volkova on 16.02.2018.
// Copyright (c) 2018 Natalia Volkova. All rights reserved.
//

#import "CoreDataHelper.h"
#import "TicketSortOrder.h"

@interface CoreDataHelper ()

@property(nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, strong) NSManagedObjectModel *managedObjectModel;

@end

@implementation CoreDataHelper {

}

+ (instancetype)sharedInstance {
    static CoreDataHelper *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CoreDataHelper alloc] init];
        [instance setup];
    });
    
    return instance;
}

- (void)setup {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FlightWatcher"
                                              withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSURL *docsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                             inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [docsURL URLByAppendingPathComponent:@"base.sqlite"];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
            initWithManagedObjectModel:_managedObjectModel];
    NSPersistentStore *store = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                         configuration:nil
                                                                                   URL:storeURL
                                                                               options:nil
                                                                                 error:nil];
    if (!store) {
        abort();
    }
    _managedObjectContext = [[NSManagedObjectContext alloc]
            initWithConcurrencyType:NSMainQueueConcurrencyType];
    _managedObjectContext.persistentStoreCoordinator = _persistentStoreCoordinator;
}

- (void)save {
    NSError *error;
    [_managedObjectContext save:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

- (FavoriteTicket *)favoriteFromTicket:(Ticket *)ticket {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
    request.predicate = [NSPredicate predicateWithFormat:@"price == %@ AND airline == %@ AND from == %@ AND to == %@ AND departure == %@ AND expires == %@ AND flightNumber == %@", [ticket valueForKey:@"price"], ticket.airline, ticket.from, ticket.to, ticket.departure, ticket.expires, [ticket valueForKey:@"flightNumber"]];
    
    return [[_managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

- (BOOL)isFavorite:(Ticket *)ticket {
    return [self favoriteFromTicket:ticket] != nil;
}

- (void)addToFavorites:(Ticket *)ticket fromMap:(BOOL)fromMap {
    FavoriteTicket *favorite = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteTicket"
                                                             inManagedObjectContext:_managedObjectContext];
    favorite.price = ticket.price.intValue;
    favorite.airline = ticket.airline;
    favorite.departure = ticket.departure;
    favorite.expires = ticket.expires;
    favorite.flightNumber = (int16_t) ticket.flightNumber.intValue;
    favorite.returnDate = ticket.returnDate;
    favorite.from = ticket.from;
    favorite.to = ticket.to;
    favorite.created = [NSDate date];
    favorite.addedFromMap = fromMap;
    
    [self save];
}

- (void)removeFromFavorites:(Ticket *)ticket {
    FavoriteTicket *favorite = [self favoriteFromTicket:ticket];
    if (favorite) {
        [_managedObjectContext deleteObject:favorite];
        [self save];
    }
}

- (NSArray *)favorites {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]];
    return [_managedObjectContext executeFetchRequest:request error:nil];
}


- (NSArray *)favoritesSortedBy:(TicketSortOrder)order ascending:(BOOL)ascending fiteredBy:(TicketFilter)filter {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
    
    NSPredicate *predicate;
    switch (filter) {
        case TicketFilterAll:
            predicate = nil;
            break;
        case TicketFilterFromMap:
            predicate = [NSPredicate predicateWithFormat: @"addedFromMap == TRUE"];
            break;
        case TicketFilterManual:
            predicate = [NSPredicate predicateWithFormat: @"addedFromMap == FALSE"];
            break;
    }

    NSSortDescriptor* descriptor;
    switch (order) {
        case TicketSortOrderTo:
            descriptor = [NSSortDescriptor sortDescriptorWithKey:@"to" ascending:ascending];
            break;
        case TicketSortOrderFrom:
            descriptor = [NSSortDescriptor sortDescriptorWithKey:@"from" ascending:ascending];
            break;
        case TicketSortOrderPrice:
            descriptor = [NSSortDescriptor sortDescriptorWithKey:@"price" ascending:ascending];
            break;
        case TicketSortOrderAirline:
            descriptor = [NSSortDescriptor sortDescriptorWithKey:@"airline" ascending:ascending];
            break;
        case TicketSortOrderCreated:
            descriptor = [NSSortDescriptor sortDescriptorWithKey:@"created" ascending:ascending];
            break;
        case TicketSortOrderExpires:
            descriptor = [NSSortDescriptor sortDescriptorWithKey:@"expires" ascending:ascending];
            break;
        case TicketSortOrderDeparture:
            descriptor = [NSSortDescriptor sortDescriptorWithKey:@"departure" ascending:ascending];
            break;
        case TicketSortOrderReturnDate:
            descriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:ascending];
            break;
        case TicketSortOrderFlightNumber:
            descriptor = [NSSortDescriptor sortDescriptorWithKey:@"flightNumber" ascending:ascending];
    }

    request.sortDescriptors = @[descriptor];
    request.predicate = predicate;
    
    return [_managedObjectContext executeFetchRequest:request error:nil];
}

@end
