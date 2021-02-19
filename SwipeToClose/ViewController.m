//
//  ViewController.m
//  SwipeToClose
//
//  Created by shaohua yang on 2/19/21.
//

#import "ViewController.h"
#import "NewViewController.h"
#import "SimpleSwipeTransition.h"

@interface ViewController ()

@property (nonatomic) SimpleSwipeTransition *transition;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blueColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Present" style:UIBarButtonItemStylePlain target:self action:@selector(onRight)];
}

- (void)onRight {
    UIViewController *next = [[UINavigationController alloc] initWithRootViewController:[NewViewController new]];
    next.modalPresentationStyle = UIModalPresentationCustom;
    self.transition = [SimpleSwipeTransition new];
    next.transitioningDelegate = self.transition;
    [self.transition.swipeInteractionController wireToViewController:next];
    [self presentViewController:next animated:YES completion:nil];
}

@end
