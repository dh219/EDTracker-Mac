//
//  AppDelegate.m
//  EDTracker-Mac
//
//  Created by David Henderson on 20/01/2016.
//  Copyright © 2016 D Henderson. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()


@end

@implementation AppDelegate

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
	return YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
    
    // create master view controller
    self.mainviewcontroller = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    
    // add the view controller to the window's content view
    [self.window.contentView addSubview:self.mainviewcontroller.view];
	self.mainviewcontroller.view.frame = ((NSView*)self.window.contentView).bounds;
	self.mainviewcontroller.appdelegate = self;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}

@end
