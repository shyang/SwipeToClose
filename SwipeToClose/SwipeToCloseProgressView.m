//
//  ProgressView.m
//  SwipeToClose
//
//  Created by shaohua yang on 2/26/21.
//

#import "SwipeToCloseProgressView.h"

static const CGFloat D = 44; // diameter

@interface SwipeToCloseProgressView ()

@property (nonatomic) UIImageView *iconView;
@end

@implementation SwipeToCloseProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, D, D)]) {
        _iconView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"close"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        _iconView.center = CGPointMake(D / 2, D / 2);
        [self addSubview:_iconView];

        CAShapeLayer *layer = (CAShapeLayer *)self.layer;
        layer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(D / 2, D / 2) radius:D / 2 startAngle:-M_PI_2 * 3 endAngle:M_PI_2 clockwise:YES].CGPath;
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.strokeColor = [UIColor whiteColor].CGColor;
        layer.lineWidth = 4;
        layer.strokeStart = 0.5;
        layer.strokeEnd = 0.5;
        layer.cornerRadius = D / 2;
        layer.masksToBounds = YES;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    progress = MAX(0, MIN(1, progress));
    // 0 => 0.5-0.5
    // 1 => 0-1
    CAShapeLayer *layer = (CAShapeLayer *)self.layer;
    if (progress < 1) {
        layer.strokeStart = (1 - progress) / 2;
        layer.strokeEnd = (1 + progress) / 2;
        self.backgroundColor = [UIColor clearColor];
        self.iconView.tintColor = [UIColor whiteColor];
    } else {
        layer.strokeEnd = 0;
        self.backgroundColor = [UIColor whiteColor];
        self.iconView.tintColor = [UIColor blackColor];
    }
}

+ (Class)layerClass {
    return [CAShapeLayer class];
}

@end
