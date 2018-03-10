//
//  CollectionViewController.h
//  FlightWatcher
//
//  Created by Natalia Volkova on 13.02.2018.
//  Copyright © 2018 Natalia Volkova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketsViewController : UICollectionViewController

- (instancetype)initWithTickets:(NSArray *)tickets;

@property(nonatomic, strong) UIDatePicker *datePicker;
@property(nonatomic, strong) UITextField *dateTextField;

@end
