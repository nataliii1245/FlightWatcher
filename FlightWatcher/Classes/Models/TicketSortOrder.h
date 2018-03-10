//
// Created by Natalia Volkova on 04.02.2018.
// Copyright (c) 2018 Natalia Volkova. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum TicketSortOrder {
    TicketSortOrderAirline,
    TicketSortOrderCreated,
    TicketSortOrderDeparture,
    TicketSortOrderExpires,
    TicketSortOrderFlightNumber,
    TicketSortOrderFrom,
    TicketSortOrderPrice,
    TicketSortOrderReturnDate,
    TicketSortOrderTo
} TicketSortOrder;

typedef enum TicketFilter {
    TicketFilterAll,
    TicketFilterFromMap,
    TicketFilterManual
} TicketFilter;
