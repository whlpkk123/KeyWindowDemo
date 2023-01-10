//
//  YZKWindow.m
//  UIDemo
//
//  Created by YZK on 2023/1/4.
//

#import "YZKWindow.h"

@implementation YZKWindow

- (void)motionBegan:(UIEventSubtype)motion withEvent:(nullable UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake)
    {
        NSLog(@"摇一摇");
    }
}


@end
