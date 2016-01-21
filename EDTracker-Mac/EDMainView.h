//
//  EDMainView.h
//  EDTracker-Mac
//
//  Created by David Henderson on 21/01/2016.
//  Copyright © 2016 D Henderson. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface EDMainView : NSView {
	
}

@property (weak) IBOutlet NSLevelIndicator *xlevel;
@property (weak) IBOutlet NSLevelIndicator *ylevel;
@property (weak) IBOutlet NSLevelIndicator *zlevel;

@property (weak) IBOutlet NSTextField *xval;
@property (weak) IBOutlet NSTextField *yval;
@property (weak) IBOutlet NSTextField *zval;

- (IBAction)       slideraction:(id) sender;


@end
