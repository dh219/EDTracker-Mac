//
//  TopDown.m
//  EDTracker-Mac
//
//  Created by David Henderson on 20/11/2016.
//  Copyright © 2016 D Henderson. All rights reserved.
//

#import "TopDown.h"
#import <OpenGL/gl.h>
#import <OpenGL/glu.h>
#import "MainViewController.h"
#import "Matrix33.h"

@implementation TopDown

- (void)drawRect:(NSRect)dirtyRect {
	
	super.flush = false; // we'll do the flushing
	[super drawRect:dirtyRect];

	glBegin(GL_POINTS);
//		glVertex2f(-0.8f,0.8f);

	Vector3* v;
	Vector3* w;
	w = [[Vector3 alloc]init];
	
	float maxmag = [self.viewcontrol.qpoints getScaleFactor];
	float maxmagoff = [self.viewcontrol.qpoints getScaleFactorOffset:self.viewcontrol.magoffset];
		
	for( int i = 0 ; i < [self.viewcontrol.qpoints count] ; i++ ) {
		v = [self.viewcontrol.qpoints getVector3:i];
		[self.viewcontrol.magcalmat vecMult:v output:w offset:self.viewcontrol.magoffset];
		glColor3f(1.0f, 0.0f, 0.0f);
		glVertex2f( [v y]/maxmag, [v z]/maxmag );
		glColor3f(1.0f, 1.0f, 0.0f);
		glVertex2f( [w y]/maxmagoff, [w z]/maxmagoff );
		
	}
	glEnd();
	
	glFlush();

}
@end
