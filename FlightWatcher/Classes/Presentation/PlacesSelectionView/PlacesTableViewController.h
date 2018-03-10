//
//  PlacesTableViewController.h
//  FlightWatcher
//
//  Created by Natalia Volkova on 02.02.2018.
//  Copyright © 2018 Natalia Volkova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSourceTypeEnum.h"


@protocol PlaceViewControllerDelegate <NSObject>

- (void)selectPlace:(id)place withType:(bool)isOrigin andDataType:(DataSourceType)dataType;

@end

@interface PlacesTableViewController : UITableViewController

@property(nonatomic, strong) id <PlaceViewControllerDelegate> delegate;

- (instancetype)initWithStyle:(UITableViewStyle)style toReturnOrigin:(bool)isOrigin;

@end
