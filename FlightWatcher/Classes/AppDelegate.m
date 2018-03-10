//
//  AppDelegate.m
//  FlightWatcher
//
//  Created by Natalia Volkova on 30.01.2018.
//  Copyright © 2018 Natalia Volkova. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarController.h"
#import "NotificationCenter.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self performViewInitialization];

    [NotificationCenter.sharedInstance registerService];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"FlightWatcher"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    abort();
                }
            }];
        }
    }

    return _persistentContainer;
}


#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        abort();
    }
}


# pragma mark - View initialization sequence

- (void)performViewInitialization {
    TabBarController *firstController = [[TabBarController alloc] init];
    
    CGRect frame = [UIScreen mainScreen].bounds;
    self.window = [[UIWindow alloc] initWithFrame:frame];
    self.window.rootViewController = firstController;
    [self.window makeKeyAndVisible];
}

@end
