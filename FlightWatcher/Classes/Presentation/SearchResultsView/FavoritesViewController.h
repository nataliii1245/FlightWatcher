//
// Created by Natalia Volkova on 21.02.2018.
// Copyright (c) 2018 Natalia Volkova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritesViewController : UICollectionViewController

- (instancetype)initWithFavoriteTickets;

@property(nonatomic, strong) UIDatePicker *datePicker;
@property(nonatomic, strong) UITextField *dateTextField;

@end
