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
    self.progressView.center = CGPointMake(containerView.bounds.size.width / 2, 60);
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
    CGFloat progress = translation.y / gestureRecognizer.view.superview.frame.size.height;
    progress = MIN(1, MAX(progress, 0));
    if (!self.interactionInProgress) {
        if (progress < 0.05 || fabs(translation.x) > translation.y) {
            return;
        }
        self.interactionInProgress = YES;
        [self.viewController dismissViewControllerAnimated:YES completion:nil];
        self.feedbackGenerator = [[UIImpactFeedbackGenerator alloc] init];
    }
    // 位移: [0.05, 1] 映射到 [0, 0.5]
    progress = (progress - 0.05) / 0.95 * 0.5;

    // 进度: [0.18 0.28] 映射到 [0, 1]
    CGFloat hint = (progress - 0.18) / 0.10;
    [self.progressView setProgress:hint];
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
