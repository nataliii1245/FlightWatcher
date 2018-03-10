//
//  MainView.m
//  FlightWatcher
//
//  Created by Natalia Volkova on 31.01.2018.
//  Copyright © 2018 Natalia Volkova. All rights reserved.
//

#import "MainView.h"
#import "UILabel+Style.h"
#import "UIButton+Style.h"
#import "UIView+GetController.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

@implementation MainView {
    
    UIButton *originButton;
    UIButton *destinationButton;
    UIButton *departureDateButton;
    UIButton *returnDateButton;
    UIButton *searchButton;
    
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.backgroundColor = UIColor.whiteColor;

    UIViewController *superViewController = [[self superview] getViewController];
    
    #pragma mark originButton
    originButton = [[UIButton alloc] initWithFrame:self.bounds title:NSLocalizedString(@"From", @"From")];
    [originButton addTarget:superViewController action:@selector(presentOriginSelectionView) forControlEvents:UIControlEventTouchUpInside];
    [originButton setEnabled:false];
    [self addSubview:originButton];

    #pragma mark destinationButton
    destinationButton = [[UIButton alloc] initWithFrame:self.bounds title:NSLocalizedString(@"To", @"To")];
    [destinationButton addTarget:superViewController action:@selector(presentDestinationSelectionView) forControlEvents:UIControlEventTouchUpInside];
    [destinationButton setEnabled:false];
    [self addSubview:destinationButton];

    #pragma mark departure_date
    departureDateButton = [[UIButton alloc] initWithFrame:self.bounds title:NSLocalizedString(@"Departure date", @"Departure date")];
    [departureDateButton addTarget:superViewController action:@selector(presentDepartureDateBox) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:departureDateButton];
    
    #pragma mark return_date
    returnDateButton = [[UIButton alloc] initWithFrame:self.bounds title:NSLocalizedString(@"Return date", @"Return date")];
    [returnDateButton addTarget:superViewController action:@selector(presentReturnDateBox) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:returnDateButton];
    
    #pragma mark searchButton
    searchButton = [[UIButton alloc] initWithFrame:self.bounds title:NSLocalizedString(@"Search", @"Search")];
    searchButton.alpha = 0.8;
    [searchButton addTarget:superViewController action:@selector(searchButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setEnabled:false];
    [self addSubview:searchButton];
    
    return self;
}

- (void)activateButtons {
    [originButton setEnabled:true];
    [destinationButton setEnabled:true];
    [searchButton setEnabled:true];
}

- (void)setPlaceButtonTitle:(NSString *)title forOriginButton:(BOOL)isOrigin {
    if (isOrigin) {
        [originButton setTitle:[[NSString alloc] initWithFormat:NSLocalizedString(@"From: %@", @"From: %@"), title] forState:UIControlStateNormal];
    } else {
        [destinationButton setTitle:[[NSString alloc] initWithFormat:NSLocalizedString(@"To: %@", @"To: %@"), title] forState:UIControlStateNormal];
    }
}

- (void)setDateButtonTitle:(NSString *)title forDepartureDateButton:(BOOL)isDeparture {
    if (isDeparture) {
        [departureDateButton setTitle:[[NSString alloc] initWithFormat:NSLocalizedString(@"Departure date: %@", @"Departure date: %@"), title] forState:UIControlStateNormal];
    } else {
        [returnDateButton setTitle:[[NSString alloc] initWithFormat:NSLocalizedString(@"Return date: %@", @"Return date: %@"), title] forState:UIControlStateNormal];
    }
}

- (void)layoutSubviews {
    CGFloat topInset = 24;
    CGFloat leftInset = 24;
    CGFloat rightInset = 24;
    CGFloat internalMarginSize = 24;
    CGFloat elementWidth = self.bounds.size.width - leftInset - rightInset;
    CGFloat buttonHeight = 54;

    CGRect originButtonFrame = CGRectMake(leftInset, topInset, elementWidth, buttonHeight);
    originButton.frame = originButtonFrame;

    CGRect destinationButtonFrame = CGRectMake(leftInset,
                                               CGRectGetMaxY(originButtonFrame) + internalMarginSize,
                                               elementWidth,
                                               buttonHeight);
    destinationButton.frame = destinationButtonFrame;

    CGRect departureDateButtonFrame = CGRectMake(leftInset,
                                                 CGRectGetMaxY(destinationButtonFrame) + internalMarginSize,
                                                 elementWidth,
                                                 buttonHeight);
    departureDateButton.frame = departureDateButtonFrame;
    
    CGRect returnDateButtonFrame = CGRectMake(leftInset,
                                              CGRectGetMaxY(departureDateButtonFrame) + internalMarginSize,
                                              elementWidth,
                                              buttonHeight);
    returnDateButton.frame = returnDateButtonFrame;
    
    CGRect searchButtonFrame = CGRectMake(leftInset + elementWidth / 6,
                                          CGRectGetMaxY(returnDateButtonFrame) + internalMarginSize * 1.5,
                                          elementWidth * 2 / 3,
                                          buttonHeight * 0.8);
    searchButton.frame = searchButtonFrame;
}


@end

#pragma clang diagnostic pop
