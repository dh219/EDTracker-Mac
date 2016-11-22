//
//  PointViewer.h
//  EDTracker-Mac
//
//  Created by David Henderson on 20/11/2016.
//  Copyright © 2016 D Henderson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define PI 3.1415927

@class MainViewController;

@interface PointViewer : NSOpenGLView {
	
	CVDisplayLinkRef displayLink; //display link for managing rendering thread
	
}

@property (weak) MainViewController *viewcontrol;
@property bool flush;

@end
