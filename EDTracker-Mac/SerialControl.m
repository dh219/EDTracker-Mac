//
//  SerialControl.m
//  EDTracker-Mac
//
//  Created by David Henderson on 22/03/2016.
//  Copyright © 2016 D Henderson. All rights reserved.
//

#import "SerialControl.h"
#import "MainViewController.h"
@import ORSSerial;

@implementation SerialControl

- (id) init {
	
	NSLog(@"Init serialcontrol");
	_port = [ORSSerialPort serialPortWithPath:@"/dev/cu.usbmodem14521"];
	_port.baudRate = @115200;
	_port.delegate = self;
	_port.DTR = true;
	[_port open];
	
	return self;
}

-(void)serialPortWasOpened:(ORSSerialPort *)serialPort {
	NSLog(@"Opened");

	ORSSerialPacketDescriptor *descriptor = [[ORSSerialPacketDescriptor alloc] initWithPrefixString:@"\n"
																					   suffixString:@"\r"
																				maximumPacketLength:128
																						   userInfo:nil];
	[serialPort startListeningForPacketsMatchingDescriptor:descriptor];
	
	NSData *someData = [@"V" dataUsingEncoding:NSUTF8StringEncoding];
	sleep(1);
	[_port sendData:someData]; // someData is an NSData object
	NSLog(@"Sent Hello");
}

-(void)serialPortWasRemovedFromSystem:(ORSSerialPort *)serialPort {
	NSLog(@"Removed");
	self.port = nil;
}

-(void)serialPortWasClosed:(ORSSerialPort *)serialPort {
	NSLog(@"Closed");
}

-(void)serialPort:(ORSSerialPort *)serialPort requestDidTimeout:(ORSSerialRequest *)request {
	NSLog(@"Timeout");
}

-(void)serialPort:(ORSSerialPort *)serialPort didEncounterError:(NSError *)error {
	NSLog(@"Serial port %@ encountered an error: %@", self.port, error);
}

-(void)serialPort:(ORSSerialPort *)serialPort didReceiveResponse:(NSData *)responseData toRequest:(ORSSerialRequest *)request {
	NSLog(@"Response");
}

- (void)serialPort:(ORSSerialPort *)serialPort didReceivePacket:(NSData *)packetData matchingDescriptor:(ORSSerialPacketDescriptor *)descriptor
{
	NSString *dataAsString = [[NSString alloc] initWithData:packetData encoding:NSASCIIStringEncoding];
	NSString *valueString = [dataAsString substringWithRange:NSMakeRange(1, [dataAsString length]-2)];
	NSLog( @"Packet: %@", valueString );

	NSArray *chunks = [valueString componentsSeparatedByString: @"\t"];
	if( [chunks count] > 9 ) {
		int n = [chunks[0] intValue];
	
		[_viewcontrol setXval:n];
		[_viewcontrol redraw];
	}
}
/*
- (void)serialPort:(ORSSerialPort *)serialPort didReceiveData:(NSData *)data
{
	NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"Data: %@", string );
}
*/

@end
