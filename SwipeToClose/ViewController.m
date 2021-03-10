//
//  ViewController.m
//  SwipeToClose
//
//  Created by shaohua yang on 2/19/21.
//

#import "ViewController.h"
#import "NewViewController.h"
#import "SwipeToCloseTransition.h"

@interface ViewController ()

@property (nonatomic) SwipeToCloseTransition *transition;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blueColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"定制版" style:UIBarButtonItemStylePlain target:self action:@selector(onRight)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"系统内置" style:UIBarButtonItemStylePlain target:self action:@selector(onLeft)];
}

- (void)onRight {
    UIViewController *next = [[UINavigationController alloc] initWithRootViewController:[NewViewController new]];
    next.modalPresentationStyle = UIModalPresentationCustom;
    self.transition = [SwipeToCloseTransition new];
    next.transitioningDelegate = self.transition;
    [self.transition.swipeInteractionController wireToViewController:next];
    [self presentViewController:next animated:YES completion:nil];
}

- (void)onLeft {
    UIViewController *next = [[UINavigationController alloc] initWithRootViewController:[NewViewController new]];
    [self presentViewController:next animated:YES completion:nil];
}

@end
