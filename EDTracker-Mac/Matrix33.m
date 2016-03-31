//
//  Matrix33.m
//  EDTracker-Mac
//
//  Created by David Henderson on 24/03/2016.
//  Copyright © 2016 D Henderson. All rights reserved.
//

#import "Matrix33.h"

@implementation Matrix33 {
	float elements[9];
}
- (id)init
{
	self = [super init];
	if (self)
	{
		// superclass successfully initialized, further
		// initialization happens here ...
		int i;
		for( i = 0 ; i < 9 ; i++ )
			elements[i] = 0.0;
		elements[0] = 1.0;
		elements[4] = 1.0;
		elements[8] = 1.0;
	}
	return self;
}

-(void)setElementValue:(float)value i:(short)i j:(short)j {
	if( i < 1 || j < 1 || i > 3 || j > 3 )
		return;
	i--;
	j--;
	elements[i+3*j] = value;
}

-(float)getElementi:(short)i j:(short)j {
	if( i < 1 || j < 1 || i > 3 || j > 3 )
		return -99.9;
	i--;
	j--;
	return elements[i+3*j];
}


@end

