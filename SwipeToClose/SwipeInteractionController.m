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

    progress = MIN(1.0, (MAX(0.0, progress)));
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.interactionInProgress = YES;
            [self.viewController dismissViewControllerAnimated:YES completion:nil];
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
            if ([gestureRecognizer velocityInView:gestureRecognizer.view].y > 500) {
                [self finishInteractiveTransition];
            } else {
                if (!self.shouldCompleteTransition) {
                    [self cancelInteractiveTransition];
                } else {
                    [self finishInteractiveTransition];
                }
            }
            break;
        default:
            break;
    }
}

@end
