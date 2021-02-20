//
//  ViewController.h
//  SwipeToClose
//
//  Created by shaohua yang on 2/19/21.
//

#import "SwipeInteractionController.h"

@implementation SwipeInteractionController

- (void)wireToViewController:(UIViewController *)viewController {
    self.viewController = viewController;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [viewController.view addGestureRecognizer:pan];
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    CGFloat progress = translation.y / gestureRecognizer.view.superview.frame.size.height;
    if (!self.interactionInProgress) {
        if (translation.y < 60 || fabs(translation.x) > translation.y) {
            return;
        }
        self.interactionInProgress = YES;
        [self.viewController dismissViewControllerAnimated:YES completion:nil];
    }
    CGFloat v = [gestureRecognizer velocityInView:gestureRecognizer.view].y;
    NSLog(@"%.2f %.0f %.0f", progress, v, translation.y);
    self.completionSpeed = 1;
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            self.shouldCompleteTransition = progress > 0.5;
            [self updateInteractiveTransition:progress];
            break;
        case UIGestureRecognizerStateCancelled:
            self.interactionInProgress = NO;
            [self cancelInteractiveTransition];
            break;
        case UIGestureRecognizerStateEnded:
            self.interactionInProgress = NO;
            if (self.shouldCompleteTransition || (progress > 0.15 && [gestureRecognizer velocityInView:gestureRecognizer.view].y > 500)) {
                self.completionSpeed = sqrt(progress);
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
