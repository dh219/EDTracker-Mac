//
//  Matrix33.h
//  EDTracker-Mac
//
//  Created by David Henderson on 24/03/2016.
//  Copyright © 2016 D Henderson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Matrix33 : NSObject

- (id)init;
-(void)setElementValue:(float)value i:(short)i j:(short)j;
-(float)getElementi:(short)i j:(short)j;

@end
