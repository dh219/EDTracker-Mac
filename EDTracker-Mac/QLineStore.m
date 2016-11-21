//
//  QLineStore.m
//  EDTracker-Mac
//
//  Created by David Henderson on 29/03/2016.
//  Copyright © 2016 D Henderson. All rights reserved.
//

#import "QLineStore.h"
#import "Vector3.h"

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
		[self clearList];
	}
	return self;
}

-(void)clearList{
	[store removeAllObjects];
	_count = 0;
	_maxmag = 1.0;
	for( int t = 0 ; t < MAXTHETA ; t++ )
		for( int p = 0 ; p < MAXPSI ; p++ )
			angledb[t][p] = false;
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
		float mag = [vec getMag];
		if( mag > _maxmag )
			_maxmag = mag;
		[store addObject:vec];
	}
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

@end
