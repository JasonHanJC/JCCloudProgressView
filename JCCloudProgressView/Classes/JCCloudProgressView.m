//
//  JCCloudProgressView.m
//  Pods
//
//  Created by Juncheng Han on 5/7/19.
//

#import "JCCloudProgressView.h"
#import "WaveLayer.h"

#define DEFAULT_CLOUNDUPLOADVIEW_HEIGHT 100.0f
#define DEFAULT_CLOUNDUPLOADVIEW_WIDTH 100.0f

@interface JCCloudProgressView ()

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) CAShapeLayer *cloud;
@property (strong, nonatomic) CAShapeLayer *cloudShape;

@property (strong, nonatomic) CALayer *wavesContainer;
@property (strong, nonatomic) NSMutableArray *waves;

@end

@implementation JCCloudProgressView

- (void)dealloc {
    [self removeWaveRollingAnimation];
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeDefaults];
        [self setupViewsAndLayers];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeDefaults];
        [self setupViewsAndLayers];
    }
    return self;
}

- (void)initializeDefaults {
    _cloudColor = [UIColor colorWithRed:0.9 green: 0.9 blue:0.9 alpha:1];
    _colorA = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
    _colorB = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5];
    _progress = 0.0;
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(startWaveRollingAnimation) name:UIApplicationDidBecomeActiveNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(stopWaveRollingAnimation) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)setupViewsAndLayers {
    // setup container view for cloud and wave layers
    _contentView = [[UIView alloc] init];
    [self addSubview:_contentView];
    
    // setup the cloud layer
    _cloud = [CAShapeLayer layer];
    _cloudShape = [CAShapeLayer layer];
    _cloud.mask = _cloudShape;
    _wavesContainer = [CAShapeLayer layer];
    
    [_cloud addSublayer:_wavesContainer];
    [_contentView.layer addSublayer:_cloud];
    
    // setup the wave layer
    for (NSUInteger i = 0; i < 2; i++) {
        WaveLayer *waveLayer = [WaveLayer layer];
        [_wavesContainer addSublayer:waveLayer];
        [self.waves addObject:waveLayer];
    }
    
    [self setupLayerProperties];
    [self setupLayerFrames];
}

- (void)setupLayerProperties {
    self.backgroundColor = [UIColor clearColor];
    _contentView.backgroundColor = [UIColor clearColor];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    _cloud.fillColor = _cloudColor.CGColor;
    _cloud.strokeColor = nil;
    _cloud.lineWidth   = 0;
    
    _cloudShape.fillColor = [UIColor whiteColor].CGColor;
    _cloudShape.strokeColor = nil;
    _cloudShape.lineWidth = 0;
    
    for (NSUInteger i = 0; i < self.waves.count; i++) {
        WaveLayer *waveLayer = self.waves[i];
        waveLayer.colors = @[_colorA, _colorB];
        waveLayer.offsetU = i * M_PI * 0.8;
    }
    
    [CATransaction commit];
}

- (void)setupLayerFrames {
    CGFloat width = MIN(self.bounds.size.width, self.bounds.size.height);
    CGFloat height = width;
    
    _contentView.bounds = CGRectMake(0, 0, width, height);
    _contentView.center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    _cloud.frame = CGRectMake(0, 0, CGRectGetWidth(_cloud.superlayer.bounds), 0.6 * CGRectGetHeight(_cloud.superlayer.bounds));
    _cloud.position = CGPointMake(CGRectGetWidth(_cloud.superlayer.bounds) / 2.f, CGRectGetHeight(_cloud.superlayer.bounds) / 2.f);
    _cloud.path = [self cloudPathWithBounds:[_cloud bounds]].CGPath;
    
    _cloudShape.frame = CGRectMake(0.01 * CGRectGetWidth(_cloudShape.superlayer.bounds), 0.01667 * CGRectGetHeight(_cloudShape.superlayer.bounds), 0.98 * CGRectGetWidth(_cloudShape.superlayer.bounds), 0.96667 * CGRectGetHeight(_cloudShape.superlayer.bounds));
    _cloudShape.path = [self cloudShapePathWithBounds:[_cloudShape bounds]].CGPath;
    
    _wavesContainer.frame = _wavesContainer.superlayer.bounds;
    
    CGRect waveFrame = CGRectInset(_wavesContainer.bounds, 0, 0);
    for (int i = 0; i < self.waves.count; i++) {
        WaveLayer *waveLayer = self.waves[i];
        waveLayer.frame = waveFrame;
        waveLayer.A = waveFrame.size.width * ( -0.05 - 0.03 * i);
        waveLayer.W = 2 * M_PI / waveFrame.size.width * 0.8;
    }
    
    [CATransaction commit];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupLayerFrames];
}

#pragma mark - lazy loading property

- (NSMutableArray *)waves {
    if (!_waves) {
        _waves = [NSMutableArray arrayWithCapacity:2];
    }
    return _waves;
}

#pragma mark - Add Animation

- (void)addWaveRollingAnimation {
    CABasicAnimation *waveRollingAnim = [CABasicAnimation animationWithKeyPath:@"U"];
    waveRollingAnim.fromValue = @0;
    waveRollingAnim.toValue = @(M_PI * 2);
    waveRollingAnim.repeatCount = HUGE_VALF;
    waveRollingAnim.removedOnCompletion = NO;
    waveRollingAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    for (int i = 0; i < self.waves.count; i++) {
        waveRollingAnim.duration = 1.2 + (i * 0.3);
        [self.waves[i] addAnimation:waveRollingAnim forKey:@"WaveRollingAnimation"];
    }
}

- (void)removeWaveRollingAnimation {
    for (WaveLayer *layer in self.waves) {
        [layer removeAnimationForKey:@"WaveRollingAnimation"];
    }
}

- (void)stopWaveRollingAnimation {
    [self removeWaveRollingAnimation];
}

- (void)startWaveRollingAnimation {
    [self addWaveRollingAnimation];
}

- (void)updateProgress:(double)progress {
    [self updateProgress:progress animated:NO];
}

- (void)updateProgress:(double)progress animated:(BOOL)animated {
//    @synchronized (self)
//    {
        double lastProgress = _progress;
        _progress = MIN(1, MAX(0, progress));
        
        if (animated) {
            for (int i = 0; i < self.waves.count; i++) {
                WaveLayer *waveLayer = self.waves[i];
                waveLayer.C = self.progress;
            }
            [self addWaveProgressAnimationFromValue:lastProgress to:progress];
        } else {
            [CATransaction begin];
            [CATransaction setValue: (id) kCFBooleanTrue forKey: kCATransactionDisableActions];
            for (int i = 0; i < self.waves.count; i++) {
                WaveLayer *waveLayer = self.waves[i];
                waveLayer.C = self.progress;
            }
            [CATransaction commit];
        }
//    }
}


- (void)addWaveProgressAnimationFromValue:(NSTimeInterval)fromValue to: (NSTimeInterval)toValue {
    NSTimeInterval duration = fabs(toValue - fromValue) + 0.1;
    
    CABasicAnimation *progressAnimation = [CABasicAnimation animationWithKeyPath:@"C"];
    progressAnimation.fromValue = @(fromValue);
    progressAnimation.toValue = @(toValue);
    progressAnimation.duration = duration;
    progressAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [progressAnimation setValue:@"ProgressAnimation" forKey:@"Name"];
    for (int i = 0; i < self.waves.count; i++) {
        WaveLayer *layer = self.waves[i];
        [layer addAnimation:progressAnimation forKey:@"ProgressAnimation"];
    }
}

#pragma mark - Property Setter
- (void)setProgress:(double)progress {
    if (progress > 1.0 || progress < 0.0) {
        return;
    }
    if (_progress != progress) {
        _progress = progress;
        [self updateProgress:_progress];
    }
}

- (void)setCloudColor:(UIColor *)cloudColor {
    if (![_cloudColor isEqual:cloudColor]) {
        _cloudColor = cloudColor;
        _cloud.fillColor = _cloudColor.CGColor;
    }
}

- (void)setColorA:(UIColor *)colorA {
    if (![_colorA isEqual:colorA]) {
        _colorA = colorA;
        [self updateWaveLayersColors];
    }
}

- (void)setColorB:(UIColor *)colorB {
    if (![_colorB isEqual:colorB]) {
        _colorB = colorB;
        [self updateWaveLayersColors];
    }
}

- (void)updateWaveLayersColors {
    NSMutableArray *colors;
    if ([_colorB isEqual:_colorA]) {
        colors = [NSMutableArray arrayWithCapacity:1];
        [colors addObject:_colorB];
    } else {
        colors = [NSMutableArray arrayWithCapacity:2];
        [colors addObject:_colorA];
        [colors addObject:_colorB];
    }
    for (int i = 0; i < self.waves.count; i++) {
        WaveLayer *waveLayer = self.waves[i];
        waveLayer.colors = [colors copy];
    }
}

#pragma mark - Bezier Path
- (UIBezierPath*)cloudPathWithBounds:(CGRect)bounds{
    UIBezierPath * cloudPath = [UIBezierPath bezierPathWithRect:bounds];
    return cloudPath;
}

- (UIBezierPath*)cloudShapePathWithBounds:(CGRect)bounds{
    UIBezierPath *cloudShapePath = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bounds), minY = CGRectGetMinY(bounds), w = CGRectGetWidth(bounds), h = CGRectGetHeight(bounds);
    
    [cloudShapePath moveToPoint:CGPointMake(minX + 0.17 * w, minY + 0.99995 * h)];
    [cloudShapePath addCurveToPoint:CGPointMake(minX + 0.16667 * w, minY + h) controlPoint1:CGPointMake(minX + 0.16889 * w, minY + 0.99998 * h) controlPoint2:CGPointMake(minX + 0.16778 * w, minY + h)];
    [cloudShapePath addCurveToPoint:CGPointMake(minX, minY + 0.72222 * h) controlPoint1:CGPointMake(minX + 0.07462 * w, minY + h) controlPoint2:CGPointMake(minX, minY + 0.87564 * h)];
    [cloudShapePath addCurveToPoint:CGPointMake(minX + 0.12592 * w, minY + 0.45281 * h) controlPoint1:CGPointMake(minX, minY + 0.59224 * h) controlPoint2:CGPointMake(minX + 0.05357 * w, minY + 0.48311 * h)];
    [cloudShapePath addCurveToPoint:CGPointMake(minX + 0.12499 * w, minY + 0.41667 * h) controlPoint1:CGPointMake(minX + 0.12531 * w, minY + 0.4409 * h) controlPoint2:CGPointMake(minX + 0.12499 * w, minY + 0.42884 * h)];
    [cloudShapePath addCurveToPoint:CGPointMake(minX + 0.375 * w, minY) controlPoint1:CGPointMake(minX + 0.12499 * w, minY + 0.18655 * h) controlPoint2:CGPointMake(minX + 0.23692 * w, minY)];
    [cloudShapePath addCurveToPoint:CGPointMake(minX + 0.58037 * w, minY + 0.17898 * h) controlPoint1:CGPointMake(minX + 0.46006 * w, minY) controlPoint2:CGPointMake(minX + 0.53521 * w, minY + 0.0708 * h)];
    [cloudShapePath addCurveToPoint:CGPointMake(minX + 0.66667 * w, minY + 0.13888 * h) controlPoint1:CGPointMake(minX + 0.60554 * w, minY + 0.15353 * h) controlPoint2:CGPointMake(minX + 0.63508 * w, minY + 0.13888 * h)];
    [cloudShapePath addCurveToPoint:CGPointMake(minX + 0.83334 * w, minY + 0.41666 * h) controlPoint1:CGPointMake(minX + 0.75872 * w, minY + 0.13888 * h) controlPoint2:CGPointMake(minX + 0.83334 * w, minY + 0.26325 * h)];
    [cloudShapePath addCurveToPoint:CGPointMake(minX + 0.83252 * w, minY + 0.44445 * h) controlPoint1:CGPointMake(minX + 0.83334 * w, minY + 0.42604 * h) controlPoint2:CGPointMake(minX + 0.83306 * w, minY + 0.43531 * h)];
    [cloudShapePath addLineToPoint:CGPointMake(minX + 0.83333 * w, minY + 0.44445 * h)];
    [cloudShapePath addCurveToPoint:CGPointMake(minX + w, minY + 0.72222 * h) controlPoint1:CGPointMake(minX + 0.92538 * w, minY + 0.44445 * h) controlPoint2:CGPointMake(minX + w, minY + 0.56881 * h)];
    [cloudShapePath addCurveToPoint:CGPointMake(minX + 0.83333 * w, minY + h) controlPoint1:CGPointMake(minX + w, minY + 0.87564 * h) controlPoint2:CGPointMake(minX + 0.92538 * w, minY + h)];
    [cloudShapePath addCurveToPoint:CGPointMake(minX + 0.83 * w, minY + 0.99995 * h) controlPoint1:CGPointMake(minX + 0.83222 * w, minY + h) controlPoint2:CGPointMake(minX + 0.83111 * w, minY + 0.99998 * h)];
    [cloudShapePath addLineToPoint:CGPointMake(minX + 0.83 * w, minY + 0.99997 * h)];
    [cloudShapePath addLineToPoint:CGPointMake(minX + 0.17 * w, minY + 0.99997 * h)];
    [cloudShapePath addLineToPoint:CGPointMake(minX + 0.17 * w, minY + 0.99995 * h)];
    [cloudShapePath closePath];
    [cloudShapePath moveToPoint:CGPointMake(minX + 0.17 * w, minY + 0.99995 * h)];
    
    return cloudShapePath;
}

@end
