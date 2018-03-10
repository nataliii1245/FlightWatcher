//
//  PlaceTableViewCell.m
//  FlightWatcher
//
//  Created by Natalia Volkova on 05.02.2018.
//  Copyright © 2018 Natalia Volkova. All rights reserved.
//

#import "PlaceTableViewCell.h"

@implementation PlaceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        self.textLabel.layer.backgroundColor = [UIColor.whiteColor CGColor];
        self.detailTextLabel.layer.backgroundColor = [UIColor.whiteColor CGColor];
    }

    return self;
}

@end
