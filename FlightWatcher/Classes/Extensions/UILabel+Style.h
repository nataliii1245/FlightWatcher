//
// Created by Natalia Volkova on 01.02.2018.
// Copyright (c) 2018 Natalia Volkova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Style)

+ (instancetype _Nonnull)newWithFrame:(CGRect)frame usingTitle:(NSString *__nullable)title alignment:(NSTextAlignment)alignment;

+ (instancetype _Nonnull)newWithFrame:(CGRect)frame usingTitle:(NSString *__nullable)title;

@end
