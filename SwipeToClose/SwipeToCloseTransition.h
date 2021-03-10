//
//  ViewController.h
//  SwipeToClose
//
//  Created by shaohua yang on 2/19/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SwipeToCloseController.h"

@interface SwipeToCloseTransition : NSObject <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) SwipeToCloseController *swipeInteractionController;

@end
