//
//  MainView.h
//  FlightWatcher
//
//  Created by Natalia Volkova on 31.01.2018.
//  Copyright © 2018 Natalia Volkova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainView : UIView

- (id)initWithFrame:(CGRect)frame;
- (void)activateButtons;
- (void)setPlaceButtonTitle:(NSString *)title forOriginButton:(BOOL)isOrigin;
- (void)setDateButtonTitle:(NSString *)title forDepartureDateButton:(BOOL)isDeparture;

@end
