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
-(float)getElement0:(short)i {
	if( i < 0 || i > 8 )
		return -99.9;
	return elements[i];
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

-(void)preMult:(Matrix33*)pre {
	
	float r[9];
	float m[9];
	int i;
	
	for( i = 0 ; i < 9 ; i++ ) {
		r[i] = pre->elements[i];
		m[i] = elements[i];
	}
	
	elements[0] = r[0]*m[0] + r[1]*m[3] + r[2]*m[6];
	elements[1] = r[0]*m[1] + r[1]*m[4] + r[2]*m[7];
	elements[2] = r[0]*m[2] + r[1]*m[5] + r[2]*m[8];
	
	elements[3] = r[3]*m[0] + r[4]*m[3] + r[5]*m[6];
	elements[4] = r[3]*m[1] + r[4]*m[4] + r[5]*m[7];
	elements[5] = r[3]*m[2] + r[4]*m[5] + r[5]*m[8];
	
	elements[6] = r[6]*m[0] + r[7]*m[3] + r[8]*m[6];
	elements[7] = r[6]*m[1] + r[7]*m[4] + r[8]*m[7];
	elements[8] = r[6]*m[2] + r[7]*m[5] + r[8]*m[8];
	
}


-(void)matRotZ:(float)angle output:(Matrix33*)output {

	Matrix33 *matrot = [[Matrix33 alloc]init];
	
	matrot->elements[0] = cos(angle);
	matrot->elements[1] = sin(angle);
	matrot->elements[2] = 0.0;
	
	matrot->elements[3] = -sin(angle);
	matrot->elements[4] = cos(angle);
	matrot->elements[5] = 0.0;
	
	matrot->elements[6] = 0.0;
	matrot->elements[7] = 0.0;
	matrot->elements[8] = 1.0;
	
	[output copy:self];
	[output preMult:matrot];
	
}

-(void)copy:(Matrix33*)src {
	for(int i = 0 ; i < 9 ; i++ )
		elements[i] = src->elements[i];
}

@end

