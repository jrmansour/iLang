//
//  iLangNavigationController.m
//  finalproject
//
//  Created by Jahan on 20/01/14.
//  Copyright (c) 2014 Jahangir Rostamzad. All rights reserved.
//

#import "iLangNavigationController.h"
#import "MainViewController.h"

@interface iLangNavigationController ()

@end

@implementation iLangNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (NSUInteger)supportedInterfaceOrientations{
    id currentViewController = self.topViewController;
    if ([currentViewController isKindOfClass:[MainViewController class]])
        return UIInterfaceOrientationMaskPortrait;
    else
        return UIInterfaceOrientationMaskAll;
}
 */

-(BOOL)shouldAutorotate
{
    return [[self.viewControllers lastObject] shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

@end
