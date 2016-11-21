//
//  Vector3.m
//  EDTracker-Mac
//
//  Created by David Henderson on 24/03/2016.
//  Copyright © 2016 D Henderson. All rights reserved.
//

#import "Vector3.h"

@implementation Vector3 {
	float elements[3];
}
- (id)init
{
	self = [super init];
	if (self)
	{
		// superclass successfully initialized, further
		// initialization happens here ...
		elements[0] = 0.0;
		elements[1] = 0.0;
		elements[2] = 1.0;
	}
	return self;
}

-(void)setElementValue:(float)value n:(short)n {
	if( n < 1 || n > 3 )
		return;
	n--;
	elements[n] = value;
}

-(float)getElementN:(short)i {
	if( i < 1 || i > 3 )
		return -99.9;
	i--;
	return elements[i];
}

-(float)x {
	return elements[0];
}
-(float)y {
	return elements[1];
}
-(float)z {
	return elements[2];
}
-(float)getMag {
	return sqrt( elements[0]*elements[0] + elements[1]*elements[1] + elements[2]*elements[2] );
}


@end

