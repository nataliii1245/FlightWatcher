//
// Created by Natalia Volkova on 02.02.2018.
// Copyright (c) 2018 Natalia Volkova. All rights reserved.
//

#import "UIView+GetController.h"

@implementation UIView (GetController)

- (UIViewController *)getViewController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isMemberOfClass:[UIViewController class]]) {
            return (UIViewController *) nextResponder;
        }
    }
    
    return nil;
}

@end
