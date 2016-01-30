//
//  MainViewController.h
//  EDTracker-Mac
//
//  Created by David on 30/01/2016.
//  Copyright (c) 2016 D Henderson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MainViewController : NSViewController


@property (weak) IBOutlet NSLevelIndicator *xlevel;
@property (weak) IBOutlet NSLevelIndicator *ylevel;
@property (weak) IBOutlet NSLevelIndicator *zlevel;


@end
