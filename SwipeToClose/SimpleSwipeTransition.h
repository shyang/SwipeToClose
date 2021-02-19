//
//  ViewController.h
//  SwipeToClose
//
//  Created by shaohua yang on 2/19/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SwipeInteractionController.h"

@interface SimpleSwipeTransition : NSObject <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) SwipeInteractionController *swipeInteractionController;

@end
