//
//  ViewController.m
//  CAGraderLayer
//
//  Created by chenfenglong on 2017/5/5.
//  Copyright © 2017年 chenfenglong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<CAAnimationDelegate>

@property (nonatomic,weak) CAGradientLayer *gradientLayer;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,weak) CAShapeLayer *maskLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (self.gradientLayer) {
        if (!self.timer) {
            [self performAnimation];
            [self addMaskLayer];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeMaskLayerW) userInfo:nil repeats:YES];
        }
    }
    else
    {
        [self addGraderLayer];
    }
}

#pragma mark -- 通过遮盖图层的宽度，来显示渐变颜色
- (void)changeMaskLayerW
{
    CGFloat graditentLayerH = self.gradientLayer.bounds.size.height;
    static CGFloat maskLayerW = 0.0;
    maskLayerW += 3;
    if (maskLayerW >= self.view.frame.size.width) {
        maskLayerW = self.view.frame.size.width;
        [self.timer invalidate];
        self.timer = nil;
    }
    self.maskLayer.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, maskLayerW, graditentLayerH)].CGPath;
}

#pragma mark -- 添加一个遮盖的图层
- (void)addMaskLayer
{
    CGFloat graditentLayerH = self.gradientLayer.bounds.size.height;
    CGFloat viewW = self.view.frame.size.width;
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, viewW / 2, graditentLayerH)].CGPath;
    self.gradientLayer.mask = maskLayer;
    self.maskLayer = maskLayer;
}

#pragma mark -- 添加一个渐变颜色的图层
- (void)addGraderLayer
{
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.frame = CGRectMake(0, 50, self.view.frame.size.width, 5);
    
    // Create colors using hues in +5 increments
    NSMutableArray *colors = [NSMutableArray array];
    for (NSInteger hue = 0; hue <= 360; hue += 5) {
        UIColor *color;
        color = [UIColor colorWithHue:1.0 * hue / 360.0
                           saturation:1.0
                           brightness:1.0
                                alpha:1.0];
        [colors addObject:(id)[color CGColor]];
    }
    [gradientLayer setColors:[NSArray arrayWithArray:colors]];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    [self.view.layer addSublayer:gradientLayer];
    self.gradientLayer = gradientLayer;
}

#pragma mark -- 改变GradientLayer的颜色（每回从把最后一个的颜色放到第一个）
- (void)performAnimation
{
    NSMutableArray *mutableColor = [self.gradientLayer.colors mutableCopy];
    UIColor *lastColor = [mutableColor lastObject];
    [mutableColor removeLastObject];
    [mutableColor insertObject:lastColor atIndex:0];
    [self.gradientLayer setColors:mutableColor];
    
    CABasicAnimation *animation;
    animation = [CABasicAnimation animationWithKeyPath:@"colors"];
    [animation setToValue:mutableColor];
    [animation setDuration:0.08];
    [animation setRemovedOnCompletion:YES];
    [animation setFillMode:kCAFillModeForwards];
    [animation setDelegate:self];
    [self.gradientLayer addAnimation:animation forKey:@"animationGradient"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self performAnimation];
}

@end
