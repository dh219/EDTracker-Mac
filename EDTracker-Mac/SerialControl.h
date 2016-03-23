//
//  SerialControl.h
//  EDTracker-Mac
//
//  Created by David Henderson on 22/03/2016.
//  Copyright © 2016 D Henderson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "ORSSerialPort.h"

@class MainViewController;

@interface SerialControl : NSObject <ORSSerialPortDelegate> //, NSUserNotificationCenterDelegate>

@property ORSSerialPort *port;
@property MainViewController *viewcontrol;

//- (void)serialPort:(ORSSerialPort *)serialPort didReceiveData:(NSData *)data;

@end
