//
//  Vector3.h
//  EDTracker-Mac
//
//  Created by David Henderson on 24/03/2016.
//  Copyright © 2016 D Henderson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vector3 : NSObject

- (id)init;
-(void)setElementValue:(float)value n:(short)n;
-(void)clear0;
-(void)clearn999;
-(void)clear999;
-(void)clear1;
-(float)getElementN:(short)i;
-(float)x;
-(float)y;
-(float)z;
-(float)getMag;

@end
