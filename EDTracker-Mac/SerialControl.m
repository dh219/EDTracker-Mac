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
	return self;
}

-(void)CloseSerial {
	if( _port ) {
		[_port sendData:[NSData dataWithBytes:"S" length:1]];
		[NSThread sleepForTimeInterval:0.5f];
		[_port close];
	}
}

-(void)OpenSerial {

	if( _port ) {
		[self CloseSerial];
		[NSThread sleepForTimeInterval:0.5f];
	}
	
	NSLog( @"Opening port '%@'", _port.path );
	_port.baudRate = @115200;
	_port.delegate = self;
	_port.DTR = true;
	[_port open];
	[_viewcontrol activateButtons:true];

}

-(void)serialPortWasOpened:(ORSSerialPort *)serialPort {
	NSLog(@"Opened");

	ORSSerialPacketDescriptor *descriptor = [[ORSSerialPacketDescriptor alloc] initWithPrefixString:@"\n"
																					   suffixString:@"\r"
																				maximumPacketLength:512
																						   userInfo:nil];
	[serialPort startListeningForPacketsMatchingDescriptor:descriptor];

	[NSThread sleepForTimeInterval:0.5f];
	NSString *s = @"HIV";
	[_port sendData:[s dataUsingEncoding:NSUTF8StringEncoding]]; // someData is an NSData object
	NSLog(@"Sent '%@'", s);
}

-(void)serialPortWasRemovedFromSystem:(ORSSerialPort *)serialPort {
	NSLog(@"Removed");
	self.port = nil;
	[_viewcontrol activateButtons:false];
}

-(void)serialPortWasClosed:(ORSSerialPort *)serialPort {
	NSLog(@"Closed");
	[_viewcontrol activateButtons:false];
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
/*	char t =[valueString characterAtIndex:0];
	if( t >= 64 && t != 'Q' && t != 'T' )
		NSLog( @"Packet: %@", valueString );
*/
	[self handlePacket:valueString];
	
}
/*
- (void)serialPort:(ORSSerialPort *)serialPort didReceiveData:(NSData *)data
{
	NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"Data: %@", string );
}
*/

-(void)SendCString:(const char*)string{
	NSString *s = [NSString stringWithUTF8String:string];
	NSData *d = [s dataUsingEncoding:NSUTF8StringEncoding];
	[_port sendData:d];
	NSLog(@"Sent: '%@'", s );
}

-(void)requestInfo {
	NSString *s = @"I";
	[_port sendData:[s dataUsingEncoding:NSUTF8StringEncoding]];
}
-(void)requestVerbose {
	NSString *s = @"V";
	[_port sendData:[s dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void) writeScaleYaw:(float)yaw Pitch:(float)pitch Smoothing:(float)smoothing {
	Byte s[8];
	int16_t i;
	
	s[0] = 'C';
	i = (int16_t)(yaw * 256.0);
	memcpy( s+1, &i, 2 );
	i = (int16_t)(pitch * 256.0);
	memcpy( s+3, &i, 2 );
	i = (int16_t)(smoothing * 32767);
	memcpy( s+5, &i, 2 );
	s[7] = '\n';
	
	NSData *d = [NSData dataWithBytes:s length:8];
	[_port sendData:d];
}


- (void) write$Data:(Vector3*)offset unrotmatrix:(Matrix33*)matrix {
	//- (void) write$Data {
	Byte s[44];
	int16_t val;
	int i;
	
	// rotate a copy of the matrix here
	float t;
	switch( [_viewcontrol orient] ) {
		case(1): // top-back -- rotate 270 around Z
			t = -pi/2.0;
			break;
		case(0): // top-right -- rotate 180 around Z
			t = pi;
			break;
		case(3): // top-front -- rotate 90 around Z
			t = pi/2.0;
			break;
		default:
		case(2): // top-left -- no change
			t = 0.0;
			break;
	}
	Matrix33 *rmatrix = [[Matrix33 alloc]init];
	[matrix matRotZ:t output:rmatrix];
	
	s[0] = '$';
	
	val = (int16_t)( [offset x] * 64.0 );
	memcpy( s+1, &val, 2 );
	val = (int16_t)( [offset y] * 64.0 );
	memcpy( s+3, &val, 2 );
	val = (int16_t)( [offset z] * 64.0 );
	memcpy( s+5, &val, 2 );
	
	for( i = 0 ; i < 9 ; i++ ) {
		val = (int16_t)( [rmatrix getElement0:i] * 8192.0 );
		memcpy( s+7+(2*i), &val, 2 );
	}

	for( i = 0 ; i < 9 ; i++ ) {
		val = (int16_t)( [matrix getElement0:i] * 8192.0 );
		memcpy( s+25+(2*i), &val, 2 );
	}
	
	s[43] = '\n';
	
	NSData *d = [NSData dataWithBytes:s length:44];
	[_port sendData:d];
}



-(void) handlePacket:(NSString *)packet {

//	NSLog(@"%@",packet);
	
	NSArray *chunks = [packet componentsSeparatedByString: @"\t"];

	if( [chunks count] == 0 )
		return;
	
	char type = [chunks[0] characterAtIndex:0];
	Vector3 *vec;
	
	switch( type ) {
		case('S'):
		case('h'):
		case('a'):
		case('x'):
		case('y'):
		case('z'):
		case('M'):
		case('p'):
		case('#'):
		case('D'):
		case('R'):
		case('B'):
			NSLog(@"R: %c", type );
			break;
		case('V'):
			[_viewcontrol setHasverbose:true];
			break;
		case('I'):
			[_viewcontrol setHasinfo:true];
			break;
		case('Q'):
			if( [chunks count] != 5 )
				return;
			vec = [[Vector3 alloc]init];
			[vec setElementValue:[chunks[1] floatValue] n:1];
			[vec setElementValue:[chunks[2] floatValue] n:2];
			[vec setElementValue:[chunks[3] floatValue] n:3];
			[[_viewcontrol qpoints] addVector3:vec];
			[self.viewcontrol.gltopdown setNeedsDisplay:YES];
			[self.viewcontrol.glfronton setNeedsDisplay:YES];
//			NSLog(@"qlist size: %li", [[_viewcontrol qpoints]count] );
			break;
		case('q'):
			[_viewcontrol setHasinfo:true];
			if( [chunks count] != 14 )
				return;
			for( int j = 0 ; j < 3 ; j++ ) {
				for( int i = 0 ; i < 3 ; i++ ) {
					int offset = 4+i+(3*j);
					[[_viewcontrol magcalmat] setElementValue:[chunks[offset] floatValue] i:i+1 j:j+1];
				}
				[[_viewcontrol xmatstepper] setFloatValue:[chunks[4] floatValue]];
				[[_viewcontrol ymatstepper] setFloatValue:[chunks[8] floatValue]];
				[[_viewcontrol zmatstepper] setFloatValue:[chunks[12] floatValue]];
			}
			[[_viewcontrol magoffset] setElementValue:[chunks[1] floatValue] n:1];
			[[_viewcontrol magoffset] setElementValue:[chunks[2] floatValue] n:2];
			[[_viewcontrol magoffset] setElementValue:[chunks[3] floatValue] n:3];
			[[_viewcontrol xoffstepper] setFloatValue:[chunks[1] floatValue]];
			[[_viewcontrol yoffstepper] setFloatValue:[chunks[2] floatValue]];
			[[_viewcontrol zoffstepper] setFloatValue:[chunks[3] floatValue]];
			
			break;
		case('H'):
			[_port sendData:[NSData dataWithBytes:"VI" length:2]];
			NSLog(@"Sent VI");
			[_viewcontrol closePleaseWaitSheet:self];
			[_viewcontrol activateButtons:true];
			break;
		case('s'):
			if( [chunks count] != 5 )
				return;
			[_viewcontrol setResponse:(short)[chunks[1] integerValue]];
			[_viewcontrol setYscale:[chunks[2] floatValue]];
			[_viewcontrol setPscale:[chunks[3] floatValue]];
			[_viewcontrol setSmoothing:[chunks[4] floatValue]];
			[[_viewcontrol smoothslider] setFloatValue:[chunks[4] floatValue]*100.0];
			break;
		case('O'):
			if( [chunks count] != 2 )
				return;
			[_viewcontrol setOrient:(short)[chunks[1] integerValue]];
/*			if( newpos != [self mountpos] ) {
				[self setMountpos:newpos];
				[[[self parent] serial] write$Data:_magoffset unrotmatrix:_magmat]; // only call when changed -- send the read data back, not user data
			}
 */
			break;
		case('T'):
			if( [chunks count] != 2 )
				return;
			[_viewcontrol setTemp:[chunks[1] doubleValue]/65535.0];
			break;
		default: // regular positional output
			if( [chunks count] != 10 )
				return;
			
			[_viewcontrol setHasverbose:true];
			
			[_viewcontrol setXval:[chunks[0] intValue]];
			[_viewcontrol setYval:[chunks[1] intValue]];
			[_viewcontrol setZval:[chunks[2] intValue]];
			[_viewcontrol setAccx:[chunks[3] intValue]];
			[_viewcontrol setAccy:[chunks[4] intValue]];
			[_viewcontrol setAccz:[chunks[5] intValue]];
			[_viewcontrol setGyrox:[chunks[6] intValue]];
			[_viewcontrol setGyroy:[chunks[7] intValue]];
			[_viewcontrol setGyroz:[chunks[8] intValue]];
			
//			NSLog( @"%@ %@ %@", chunks[0], chunks[1], chunks[2] );
			break;
	}
	
	[_viewcontrol update];

	if( ![_viewcontrol hasverbose] ) {
		[self requestVerbose];
	}
	if( ![_viewcontrol hasinfo] ) {
		[self requestInfo];
	}

}

@end
