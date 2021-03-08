//
//  ViewController.h
//  SwipeToClose
//
//  Created by shaohua yang on 2/19/21.
//

#import "SwipeInteractionController.h"
#import "ProgressView.h"

@interface SwipeInteractionController ()

@property (nonatomic) ProgressView *progressView;
@property (nonatomic) dispatch_block_t done;
@property (nonatomic) UIImpactFeedbackGenerator *feedbackGenerator;
@end

static const CGFloat threshold = 20;
static const CGFloat progressTop = 44;
static const CGFloat progressBottom = 120;

@implementation SwipeInteractionController

- (ProgressView *)progressView {
    if (!_progressView) {
        _progressView = [ProgressView new];
    }
    return _progressView;
}

- (void)wireToViewController:(UIViewController *)viewController {
    self.viewController = viewController;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [viewController.view addGestureRecognizer:pan];
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    [super startInteractiveTransition:transitionContext];

    UIView *containerView = transitionContext.containerView;
    containerView.backgroundColor = [UIColor blackColor];

    [containerView insertSubview:self.progressView atIndex:0];
    self.progressView.center = CGPointMake(containerView.bounds.size.width / 2, progressTop + 44 / 2);
    __weak typeof(self) weakSelf = self;
    self.done = ^{
        typeof(self) self = weakSelf;
        [self.progressView removeFromSuperview];
        [UIView animateWithDuration:0.2 animations:^{
            containerView.backgroundColor = [UIColor clearColor];
        }];
    };
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    CGFloat dy = translation.y;
    if (!self.interactionInProgress) {
        if (dy < threshold || fabs(translation.x) > dy) {
            return;
        }
        self.interactionInProgress = YES;
        [self.viewController dismissViewControllerAnimated:YES completion:nil];
        self.feedbackGenerator = [[UIImpactFeedbackGenerator alloc] init];
    }

    CGFloat actualY = gestureRecognizer.view.layer.presentationLayer.frame.origin.y;
    CGFloat hint = (actualY - progressTop - 4) / (progressBottom - progressTop);
    [self.progressView setProgress:hint];

    CGFloat progress = (dy - threshold) / gestureRecognizer.view.superview.frame.size.height;
    progress = sqrtf(MIN(1, MAX(progress, 0))) / 2;

    self.completionSpeed = 1;
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged: {
            BOOL newValue = hint >= 1;
            if (!self.shouldCompleteTransition && newValue) {
                [self.feedbackGenerator impactOccurred];
            }
            self.shouldCompleteTransition = newValue;
            [self updateInteractiveTransition:progress];
            break;
        }
        case UIGestureRecognizerStateCancelled:
            self.interactionInProgress = NO;
            [self cancelInteractiveTransition];
            break;
        case UIGestureRecognizerStateEnded:
            self.interactionInProgress = NO;
            if (self.shouldCompleteTransition) {
                self.completionSpeed = sqrt(progress);
                self.done();
                [self finishInteractiveTransition];
            } else {
                self.completionSpeed = progress; // 进度越小，速度越慢
                [self cancelInteractiveTransition];
            }
            break;
        default:
            break;
    }
}

@end
