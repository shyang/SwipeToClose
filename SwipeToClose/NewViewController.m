//
//  NewViewController.m
//  SwipeToClose
//
//  Created by shaohua yang on 2/19/21.
//

#import "NewViewController.h"

@interface NewViewController ()

@end

@implementation NewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.redColor;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(onRight)];
}

- (void)onRight {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
