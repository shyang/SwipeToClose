//
//  ViewController.h
//  SwipeToClose
//
//  Created by shaohua yang on 2/19/21.
//

#import <UIKit/UIKit.h>

@interface SwipeInteractionController : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL interactionInProgress;
@property (nonatomic, assign) BOOL shouldCompleteTransition;
@property (nonatomic, weak) UIViewController *viewController;

- (void)wireToViewController:(UIViewController *)viewController;

@end
