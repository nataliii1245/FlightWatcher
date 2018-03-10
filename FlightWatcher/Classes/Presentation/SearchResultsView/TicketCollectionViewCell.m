//
//  TicketCollectionViewCell.m
//  FlightWatcher
//
//  Created by Natalia Volkova on 14.02.2018.
//  Copyright © 2018 Natalia Volkova. All rights reserved.
//

#import <YYWebImage/YYWebImage.h>
#import "TicketCollectionViewCell.h"
#import "UIColor+ColorPalette.h"
#import "FavoriteTicket+CoreDataClass.h"
#import "APIManager.h"


@implementation TicketCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.contentView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.contentView.layer.shadowOffset = CGSizeZero;
    self.contentView.layer.shadowRadius = 5.0;
    self.contentView.layer.shadowOpacity = 0.8;
    self.contentView.layer.cornerRadius = 10;
    self.contentView.backgroundColor = [UIColor whiteColor];

    _priceLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _priceLabel.font = [UIFont systemFontOfSize:24.0 weight:UIFontWeightBold];
    [self.contentView addSubview:_priceLabel];

    _airlineLogoView = [[UIImageView alloc] initWithFrame:self.bounds];
    _airlineLogoView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_airlineLogoView];

    _placesLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _placesLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightLight];
    _placesLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:_placesLabel];

    _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _dateLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular];
    [self.contentView addSubview:_dateLabel];

    return self;
}

- (void)setFavoriteTicket:(FavoriteTicket *)favoriteTicket {
    _favoriteTicket = favoriteTicket;
    _priceLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%lld RUB", @"%lld RUB"), favoriteTicket.price];
    _placesLabel.text = [NSString stringWithFormat:@"%@ - %@", favoriteTicket.from, favoriteTicket.to];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
    _dateLabel.text = [dateFormatter stringFromDate:favoriteTicket.departure];
    NSURL *urlLogo = [APIManager.sharedInstance urlWithAirlineLogoForIATACode:favoriteTicket.airline];
    [_airlineLogoView yy_setImageWithURL:urlLogo
                                 options:YYWebImageOptionSetImageWithFadeAnimation];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = CGRectMake(10.0, 10.0,
            self.frame.size.width - 20.0, self.frame.size.height - 20.0);

    _airlineLogoView.frame = CGRectMake(self.contentView.frame.size.width - 110, 10.0, 100.0, 100.0);
    _priceLabel.frame = CGRectMake(10.0, 10.0, self.contentView.frame.size.width - _airlineLogoView.frame.size.width - 20, 40.0);
    _placesLabel.frame = CGRectMake(10.0, CGRectGetMaxY(_priceLabel.frame) + 16.0, self.contentView.frame.size.width - _airlineLogoView.frame.size.width - 20, 20.0);
    _dateLabel.frame = CGRectMake(10.0, CGRectGetMaxY(_placesLabel.frame) + 8.0, self.contentView.frame.size.width - _airlineLogoView.frame.size.width - 20, 20.0);
}

@end
