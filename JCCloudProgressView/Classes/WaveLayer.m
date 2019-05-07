//
//  WaveLayer.m
//  WaveAnimation
//
//  Modified by Juncheng on 2019/5/2
//
//  Created by Luka on 2017/8/23.
//  Copyright © 2017年 Luka. All rights reserved.
//  Original file link: https://github.com/lukapool/LKAWaveCircleProgressBar
//

#import "WaveLayer.h"


@interface WaveLayer ()
@end

@implementation WaveLayer
// 可以进行 Core Animation 的属性需要 dynamic，UIKit 自动生成 access method
@dynamic U;
@dynamic C;

// 用来生成 presentation layer
- (instancetype)initWithLayer:(id)layer {
    self = [super initWithLayer:layer];
    if (self) {
        if ([layer isKindOfClass:[WaveLayer class]]) {
            WaveLayer *waveLayer = (WaveLayer *)layer;
            self.A = waveLayer.A;
            self.W = waveLayer.W;
            self.C = waveLayer.C;
            self.U = waveLayer.U;
            self.offsetU = waveLayer.offsetU;
            self.colors = waveLayer.colors;
        }
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentsScale = [UIScreen mainScreen].scale;
        _A = 0.5;
        _W = 2 * M_PI / 320 * 0.8;
        self.C = 0;
        self.U = 0;
        _offsetU = 0;
        _colors = [NSArray arrayWithObjects:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.5], [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5], nil];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsDisplay];
}


// 定义哪个属性为可动画
+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"U"] || [key isEqualToString:@"C"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

// 绘图
- (void)drawInContext:(CGContextRef)ctx {
    
    CGMutablePathRef sinPath = CGPathCreateMutable();
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    CGFloat offsetY = (1 - (self.C + 0.1)) * height;
    CGPathMoveToPoint(sinPath, NULL, 0.0f, height);
    CGPathAddLineToPoint(sinPath, NULL, 0.0f, offsetY);
    
    
    for (int x = 0; x <= width; x++) {
        CGFloat y = _A * sinf( _W * x + self.U + _offsetU) + offsetY;
        CGPathAddLineToPoint(sinPath, NULL, x, y);
    }
    
    CGPathAddLineToPoint(sinPath, NULL, width, height);
    CGPathCloseSubpath(sinPath);
    CGContextAddPath(ctx, sinPath);
    
    CGPathRelease(sinPath);
    
    NSAssert((self.colors.count < 3 && self.colors.count > 0), @"Wave layer colors count must be smaller that 3 and greater that 0");
    
    if (self.colors.count == 1) {
        CGContextSetFillColorWithColor(ctx, _colors[0].CGColor);
        CGContextFillPath(ctx);
    }
    if (self.colors.count == 2) {
        CGContextClip(ctx);
        // fill with gradient colors
        NSMutableArray *cgRefColors = [NSMutableArray arrayWithCapacity:2];
        for(NSInteger i = 0; i < 2; i++) {
            [cgRefColors addObject:(__bridge id)self.colors[i].CGColor];
        }
        
        CGFloat locations [] = {
            0.0, 1.0
        };
        
        CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColors(baseSpace, (__bridge CFArrayRef)cgRefColors, locations);
        CGColorSpaceRelease(baseSpace);
        baseSpace = NULL;
        
        CGPoint startPoint = CGPointZero;
        CGPoint endPoint = CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds));
        
        CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
        CGGradientRelease(gradient);
        gradient = NULL;
    }
}

@end
