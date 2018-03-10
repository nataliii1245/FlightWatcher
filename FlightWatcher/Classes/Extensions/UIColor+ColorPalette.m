//
// Created by Natalia Volkova on 30.01.2018.
// Copyright (c) 2018 Natalia Volkova. All rights reserved.
//

#import "UIColor+ColorPalette.h"

@implementation UIColor (ColorPalette)

+ (UIColor *)navigationBarFW {
    return [UIColor colorWithRed:0.77 green:0.91 blue:0.98 alpha:1.0];
}

+ (UIColor *)buttonBackgorundFW {
    return [UIColor blackColor];//[UIColor colorWithRed:0.0 green:122.0 / 255.0 blue:1.0 alpha:0.55];
}

+ (UIColor *)buttonTintFW {
    return [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
}

+ (UIColor *)cellShadowColorFW {
    return [UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:1.0 alpha:0.55];
}


@end
