//
//  JCCloudProgressView.h
//  Pods
//
//  Created by Juncheng Han on 5/7/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
IB_DESIGNABLE
@interface JCCloudProgressView : UIView

/**
 * Cloud layer fill color.
 * Default is [UIColor colorWithRed:0.9 green: 0.9 blue:0.9 alpha:1].
 */
@property (strong, nonatomic) IBInspectable UIColor *cloudColor;
/**
 * Gradient color A at location [0, 0]
 * Default is [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5].
 */
@property (strong, nonatomic) IBInspectable UIColor *colorA;
/**
 * Gradient color B at location [1, 1]
 * Default is [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5].
 */
@property (strong, nonatomic) IBInspectable UIColor *colorB;
/**
 * Progress level. From 0.0 to 1.0. Default is 0.0.
 */
@property (assign, nonatomic) IBInspectable double progress;


/**
 * Start the wave layers animation.
 *
 * @note This method adds CABasicAnimation to both wave layers.
 */
- (void)startWaveRollingAnimation;

/**
 * Start the wave layers animation.
 *
 * @note This method removes CABasicAnimation to both wave layers.
 */
- (void)stopWaveRollingAnimation;

/**
 * Update the progress without animation.
 *
 * @param progress From 0.0 to 1.0.
 */
- (void)updateProgress:(double)progress;
/**
 * Update the progress.
 *
 * @param progress From 0.0 to 1.0.
 * @param animated Animated the progress update. YES or NO.
 */
- (void)updateProgress:(double)progress animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END

