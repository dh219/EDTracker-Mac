//
//  Matrix33.m
//  EDTracker-Mac
//
//  Created by David Henderson on 24/03/2016.
//  Copyright © 2016 D Henderson. All rights reserved.
//

#import "Matrix33.h"
#import "Vector3.h"

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

-(void)vecMult:(Vector3*)input output:(Vector3*)output {
	
	float x, y, z;
	
	x = elements[0] * [input x] + elements[1] * [input y] + elements[2] * [input z];
	y = elements[3] * [input x] + elements[4] * [input y] + elements[5] * [input z];
	z = elements[6] * [input x] + elements[7] * [input y] + elements[8] * [input z];
	
	[output setElementValue:x n:1];
	[output setElementValue:y n:2];
	[output setElementValue:z n:3];
	
}

-(void)vecMult:(Vector3*)input output:(Vector3*)output offset:(Vector3*)offset {
	
	float x, y, z;
	
	Vector3 *tmp;
	tmp = [[Vector3 alloc]init];
	[tmp setElementValue:[input x]-[offset x] n:1];
	[tmp setElementValue:[input y]-[offset y] n:2];
	[tmp setElementValue:[input z]-[offset z] n:3];
	
	
	x = elements[0] * [tmp x] + elements[1] * [tmp y] + elements[2] * [tmp z];
	y = elements[3] * [tmp x] + elements[4] * [tmp y] + elements[5] * [tmp z];
	z = elements[6] * [tmp x] + elements[7] * [tmp y] + elements[8] * [tmp z];
	
	[output setElementValue:x n:1];
	[output setElementValue:y n:2];
	[output setElementValue:z n:3];
	
}

@end

