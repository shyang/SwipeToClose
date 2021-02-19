//
//  ViewController.h
//  SwipeToClose
//
//  Created by shaohua yang on 2/19/21.
//

#import "SimpleSwipeTransition.h"
#import "SimpleDismissAnimator.h"

@implementation SimpleSwipeTransition

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {

    return [SimpleDismissAnimator new];
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    
    return self.swipeInteractionController.interactionInProgress ? self.swipeInteractionController : nil;
}

- (SwipeInteractionController *)swipeInteractionController {
    
    if (!_swipeInteractionController) {
        _swipeInteractionController = [[SwipeInteractionController alloc] init];
    }
    return _swipeInteractionController;
}

@end
