//
// Created by Natalia Volkova on 18.02.2018.
// Copyright (c) 2018 Natalia Volkova. All rights reserved.
//

#import "UIAlertAction+FavoriteTicketsSortingFabric.h"
#import "TicketSortOrder.h"

@implementation UIAlertAction (FavoriteTicketsSortingFabric)

+ (instancetype)actionToSortTicektBy:(TicketSortOrder)order ascending:(BOOL)ascending {

    NSString *sortTitle;
    switch (order) {
        case (TicketSortOrderCreated):
            sortTitle = @"По дате добавления";
            break;
        case (TicketSortOrderAirline):
            sortTitle = @"По названию компании";
            break;
        case (TicketSortOrderDeparture):
            sortTitle = @"По дате вылета";
            break;
        case (TicketSortOrderExpires):
            sortTitle = @"По сроку годности";
            break;
        case (TicketSortOrderFlightNumber):
            sortTitle = @"По номеру рейса";
            break;
        case (TicketSortOrderFrom):
            sortTitle = @"По пункту вылета";
            break;
        case (TicketSortOrderPrice):
            sortTitle = @"По цене";
            break;
        case (TicketSortOrderTo):
            sortTitle = @"По пункту назначения";
            break;
        case (TicketSortOrderReturnDate):
            sortTitle = @"По дате обратного рейса";
            break;
    }

    NSString *ascendingTitle = ascending ? @"(возр.)" : @"(убыв.)";
    NSString *combinedTitle = [sortTitle stringByAppendingString:ascendingTitle];

    UIAlertAction* action =
            [UIAlertAction actionWithTitle:combinedTitle
                                     style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *_Nonnull action) {
            }];

    return action;
}

@end
