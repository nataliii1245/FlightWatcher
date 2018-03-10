//
// Created by Natalia Volkova on 06.02.2018.
// Copyright (c) 2018 Natalia Volkova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (FromISOString)

- (instancetype)initWithISOString:(NSString *)dateString;

@end
