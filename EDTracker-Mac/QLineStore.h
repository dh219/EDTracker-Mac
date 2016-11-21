//
//  QLineStore.h
//  EDTracker-Mac
//
//  Created by David Henderson on 29/03/2016.
//  Copyright © 2016 D Henderson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vector3.h"

@interface QLineStore : NSObject

@property(readonly) NSUInteger count;
@property(readonly) float maxmag;
@property(assign) bool ispaused;

-(Vector3*)getVector3:(int)i;
-(void)addVector3:(Vector3*)vec;
-(void)clearList;
-(void)dumpStore;
-(void)loadStore;


@end
