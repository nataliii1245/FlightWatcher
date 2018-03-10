//
// Created by Natalia Volkova on 10.02.2018.
// Copyright (c) 2018 Natalia Volkova. All rights reserved.
//

#import "MapPrice.h"
#import "DataManager.h"


@implementation MapPrice

- (instancetype)initWithDictionary:(NSDictionary *)dictionary withOrigin:(City *)origin {
    self = [super init];
    if (self) {
        NSString *destinationCode = dictionary[@"destination"];
        _destination = [DataManager.sharedInstance cityForCityCode:destinationCode];
        _origin = origin;
        _departure = [self dateFromString:dictionary[@"depart_date"]];
        _returnDate = [self dateFromString:dictionary[@"return_date"]];
        _numberOfChanges = [dictionary[@"number_of_changes"] integerValue];
        _value = [dictionary[@"value"] integerValue];
        _distance = [dictionary[@"distance"] integerValue];
        _actual = [dictionary[@"actual"] boolValue];
    }
    
    return self;
}

- (NSDate *_Nullable)dateFromString:(NSString *)dateString {
    if (!dateString) {return nil;}
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    return [dateFormatter dateFromString:dateString];
}

@end
