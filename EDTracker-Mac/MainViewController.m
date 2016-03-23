//
//  MainViewController.m
//  EDTracker-Mac
//
//  Created by David on 30/01/2016.
//  Copyright (c) 2016 D Henderson. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.

	_xval = 0;
	
	_serialController = [[SerialControl alloc] init];
	_serialController.viewcontrol = self;

}

- (void)		redraw {
	[_xlevel setIntValue:_xval];
}

@end
