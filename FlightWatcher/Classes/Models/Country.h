//
// Created by Natalia Volkova on 02.02.2018.
// Copyright (c) 2018 Natalia Volkova. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Country : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *currency;
@property(nonatomic, strong) NSDictionary *translations;
@property(nonatomic, strong) NSString *countryCode;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
