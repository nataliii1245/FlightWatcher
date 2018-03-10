//
//  TicketCollectionViewCell.h
//  FlightWatcher
//
//  Created by Natalia Volkova on 14.02.2018.
//  Copyright © 2018 Natalia Volkova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoriteTicket+CoreDataClass.h"

@interface TicketCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong) UILabel *priceLabel;
@property(nonatomic, strong) UILabel *placesLabel;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) UIImageView *airlineLogoView;
@property(nonatomic, strong) FavoriteTicket *favoriteTicket;

@end
