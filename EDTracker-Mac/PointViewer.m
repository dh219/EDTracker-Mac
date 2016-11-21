//
//  PointViewer.m
//  EDTracker-Mac
//
//  Created by David Henderson on 20/11/2016.
//  Copyright © 2016 D Henderson. All rights reserved.
//

#import "PointViewer.h"
#import <OpenGL/gl.h>
#import <OpenGL/glu.h>
#import "MainViewController.h"

@implementation PointViewer

static const float radius = 0.8f;
static const float steps = (float)64;

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
	glClearColor(0.1, 0.1, 0.1, 0); // charcoal
	glClear(GL_COLOR_BUFFER_BIT);
	
	/*actual drawing primitives*/
	
	glBegin(GL_LINE_LOOP);
	glColor3f(0.7f, 0.7f, 0.7f); // light grey
	for (float f=0.0; f < steps; f++)
	{
		float rad = f*(2*PI/steps);
		glVertex2f(cos(rad)*radius,sin(rad)*radius);
	}
	glEnd();
	
	/*end draw*/
	if( _flush )
		glFlush();
}

- (void)prepareOpenGL
{
	// Synchronize buffer swaps with vertical refresh rate
	GLint swapInt = 1;
	[[self openGLContext] setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];

	_flush = true;
}

- (BOOL) acceptsFirstResponder
{
	return NO;
}



@end
