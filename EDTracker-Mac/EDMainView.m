//
//  EDMainView.m
//  EDTracker-Mac
//
//  Created by David Henderson on 21/01/2016.
//  Copyright © 2016 D Henderson. All rights reserved.
//

#import "EDMainView.h"

@implementation EDMainView

- (void)drawRect:(NSRect)dirtyRect {
	[super drawRect:dirtyRect];
	
    // Drawing code here.
	
	int r = rand() % 65535 - 32768;
	
	self.xval.stringValue = @"Test";
	self.yval.stringValue = @"TestY";
	self.zval.stringValue = @"TestZ";
	
	self.xlevel.integerValue = -7000;
	self.ylevel.integerValue = 15000;
	self.zlevel.integerValue = 32000;


}

- (IBAction)       slideraction:(id) sender {
	self.zval.integerValue = [sender integerValue];
}


@end
