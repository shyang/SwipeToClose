//
//  ViewController.h
//  SwipeToClose
//
//  Created by shaohua yang on 2/19/21.
//

#import "SwipeToCloseTransition.h"
#import "SwipeToCloseAnimator.h"

@implementation SwipeToCloseTransition

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {

    return [SwipeToCloseAnimator new];
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    
    return self.swipeInteractionController.interactionInProgress ? self.swipeInteractionController : nil;
}

- (SwipeToCloseController *)swipeInteractionController {
    
    if (!_swipeInteractionController) {
        _swipeInteractionController = [[SwipeToCloseController alloc] init];
    }
    return _swipeInteractionController;
}

@end
