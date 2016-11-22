//
//  AppDelegate.h
//  EDTracker-Mac
//
//  Created by David Henderson on 20/01/2016.
//  Copyright © 2016 D Henderson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "mainviewcontroller.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong) IBOutlet NSWindow *window;
@property (nonatomic,strong) IBOutlet MainViewController *mainviewcontroller;

@end

