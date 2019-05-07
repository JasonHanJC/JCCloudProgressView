//
//  WaveLayer.h
//  WaveAnimation
//
//  Modified by Juncheng on 2019/5/2
//
//  Created by Luka on 2017/8/23.
//  Copyright © 2017年 Luka. All rights reserved.
//  Original file link: https://github.com/lukapool/LKAWaveCircleProgressBar
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface WaveLayer : CALayer

/**
 * The wave layer using sine formular
 * y = Asin(ωx+u)+c
 * A -> Amplitude
 * ω -> Angular velocity
 * u -> Horizontal offset
 * c -> Vertical offset
 */
@property (nonatomic, assign) CGFloat U;
@property (nonatomic, assign) CGFloat C;
@property (nonatomic, assign) CGFloat A;
@property (nonatomic, assign) CGFloat W;

/**
 * Set an additional horizontal offset.
 */
@property (nonatomic, assign) CGFloat offsetU;

/**
 * Setting color for the wave layer. Provide one or two colors.
 * Examples:
 * [ColorA], Fill the wave layer with colorA.
 * [ColorA, ColorB], Set a gradient color using ColorA at [0,0] and ColorB at [1,1].
 */
@property (nonatomic, strong) NSArray<UIColor *> *colors;

@end

NS_ASSUME_NONNULL_END
