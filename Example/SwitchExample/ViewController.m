//
//  ViewController.m
//  SwitchExample
//
//  Created by Pete Callaway on 24/06/2012.
//  Copyright (c) 2012 Dative Studios. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)changedSwitch:(id)sender {
    NSLog(@"%@", [sender isOn] ? @"ON" : @"OFF");
}

@end
