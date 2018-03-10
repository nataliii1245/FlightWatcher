//
//  AppDelegate.h
//  FlightWatcher
//
//  Created by Natalia Volkova on 30.01.2018.
//  Copyright © 2018 Natalia Volkova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(strong, nonatomic) UIWindow *window;

@property(readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

@end
