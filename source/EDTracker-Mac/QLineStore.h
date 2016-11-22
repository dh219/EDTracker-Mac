//
//  QLineStore.h
//  EDTracker-Mac
//
//  Created by David Henderson on 29/03/2016.
//  Copyright © 2016 D Henderson. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Vector3;
@class Matrix33;

@interface QLineStore : NSObject

@property(readonly) NSUInteger count;
@property(assign) bool ispaused;
@property(strong) Vector3 *min;
@property(strong) Vector3 *max;

-(Vector3*)getVector3:(int)i;
-(void)addVector3:(Vector3*)vec;
-(void)clearList;
-(void)dumpStore;
-(void)loadStore;

-(void)autoFitOffset:(Vector3*)offset magMat:(Matrix33*)magcalmat;

-(float)getScaleFactor;
-(float)getScaleFactorOffset:(Vector3*)offset;

@end
