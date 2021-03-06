//
//  SerialControl.h
//  EDTracker-Mac
//
//  Created by David Henderson on 22/03/2016.
//  Copyright © 2016 D Henderson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

@import ORSSerial;

@class MainViewController;
@class Vector3;
@class Matrix33;

@interface SerialControl : NSObject <ORSSerialPortDelegate> //, NSUserNotificationCenterDelegate>

@property ORSSerialPort *port;
@property MainViewController *viewcontrol;

-(void) handlePacket:(NSString *)packet;
-(void)OpenSerial;
-(void)CloseSerial;
-(void)SendCString:(const char*)string;
- (void) writeScaleYaw:(float)yaw Pitch:(float)pitch Smoothing:(float)smoothing;
- (void) write$Data:(Vector3*)offset unrotmatrix:(Matrix33*)matrix;

@end
