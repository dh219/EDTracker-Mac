//
//  QLineStore.m
//  EDTracker-Mac
//
//  Created by David Henderson on 29/03/2016.
//  Copyright © 2016 D Henderson. All rights reserved.
//

#import "QLineStore.h"
#import "Vector3.h"
#import "Matrix33.h"

#define MAXTHETA 100
#define MAXPSI 50

@implementation QLineStore {
	NSMutableArray *store;
	bool angledb[MAXTHETA][MAXPSI];
}

- (id)init
{
	self = [super init];
	if( self ) {
		store = [[NSMutableArray alloc]init];
		_min = [[Vector3 alloc]init];
		_max = [[Vector3 alloc]init];
		[self clearList];
	}
	return self;
}

-(void)clearList{
	[store removeAllObjects];
	_count = 0;
	for( int t = 0 ; t < MAXTHETA ; t++ )
		for( int p = 0 ; p < MAXPSI ; p++ )
			angledb[t][p] = false;
	[_min clear999];
	[_max clearn999];
}

-(Vector3*)getVector3:(int)i {
	if( i < 0 || i > [store count] ) {
		return nil;
	}
	return store[i];
}

-(void)addVector3:(Vector3*)vec {
	int theta;
	int psi;
	
	if( _ispaused )
		return;
	
	float x, y, z;
	x = [vec x];
	y = [vec y];
	z = [vec z];
	
	theta = (int) (0.5 + ( 180.0/pi ) * atan2( y, x ) );
	psi = (int) ( 0.5 + ( 180.0/pi ) * atan2( sqrt( x*x + y*y ), z ) );

	if( theta < 0 )
		theta += 360;
	if( psi < 0 )
		psi += 180;
	
	// theta and psi in degrees -- scale depending on MAXTHETA and MAXPSI
	
	theta = (int) ( (float) theta * (float)MAXTHETA / 360.0 );
	psi = (int) ( (float) psi * (float)MAXPSI / 180.0 );
	
	
//	NSLog(@"vec3: %.1f %.1f %.1f -- theta=%i psi=%i", x, y, z, theta, psi );
	if( !angledb[theta][psi] ) {
		angledb[theta][psi] = true;
		_count++;
		if( x > [_max x] )
			[_max setElementValue:x n:1];
		if( y > [_max y] )
			[_max setElementValue:y n:2];
		if( z > [_max z] )
			[_max setElementValue:z n:3];
		if( x < [_min x] )
			[_min setElementValue:x n:1];
		if( y < [_min y] )
			[_min setElementValue:y n:2];
		if( z < [_min z] )
			[_min setElementValue:z n:3];
		
		[store addObject:vec];
	}
}

-(float)getScaleFactor {
	float mag;
	float maxmag = 0.0;
	for( int i = 0 ; i < [store count] ; i++ ) {
		mag = [store[i] getMag];
		if( mag > maxmag )
			maxmag = mag;
	}
	return maxmag;
}

-(float)getScaleFactorOffset:(Vector3*)offset{
	float mag;
	float maxmag = 0.0;
	Vector3 *v = [[Vector3 alloc]init];
	for( int i = 0 ; i < [store count] ; i++ ) {
		[v setElementValue:[store[i] x]-[offset x] n:1];
		[v setElementValue:[store[i] y]-[offset y] n:2];
		[v setElementValue:[store[i] z]-[offset z] n:3];
		
		mag = [v getMag];
		if( mag > maxmag )
			maxmag = mag;
	}
	return maxmag;
}


-(void)dumpStore {
	FILE *fp = fopen("/tmp/store.txt", "w" );
	Vector3* v;
	for( int i = 0 ; i < [store count] ; i++ ) {
		v = store[i];
		fprintf( fp, "%.2f\t%.2f\t%.2f\n", [v x], [v y], [v z] );
	}
	fclose( fp );
}

-(void)loadStore {
	FILE *fp = fopen("/tmp/store.txt", "r" );
	Vector3* v;
	float x, y, z;
	
	[self clearList];
	
	int rc;
	while( ( rc = fscanf(fp, "%f %f %f", &x, &y, &z ) ) != EOF && rc == 3 ) {
		v = [[Vector3 alloc]init];
		[v setElementValue:x n:1];
		[v setElementValue:y n:2];
		[v setElementValue:z n:3];
		[self addVector3:v];
	}
	fclose( fp );
}

-(void)autoFitOffset:(Vector3*)offset magMat:(Matrix33*)magcalmat {

	/* offset */
	float x, y, z;
	x = ( [_max x] + [_min x] ) / 2.0;
	y = ( [_max y] + [_min y] ) / 2.0;
	z = ( [_max z] + [_min z] ) / 2.0;
	
	[offset setElementValue:x n:1];
	[offset setElementValue:y n:2];
	[offset setElementValue:z n:3];
	/**/
	
	/* scaling */
	float biggest = -999;
	x = [_max x] - [_min x];
	if( x > biggest )
		biggest = x;
	y = [_max y] - [_min y];
	if( y > biggest )
		biggest = y;
	z = [_max z] - [_min z];
	if( z > biggest )
		biggest = z;
	
	x = biggest/x;
	y = biggest/y;
	z = biggest/z;
	
	for( int j = 0 ; j < 3 ; j++ )
		for( int i = 0 ; i < 3 ; i++ )
			[magcalmat setElementValue:0.0 i:i j:j];
	
	[magcalmat setElementValue:x i:1 j:1];
	[magcalmat setElementValue:y i:2 j:2];
	[magcalmat setElementValue:z i:3 j:3];
	
}

@end
