//
//  MainViewController.m
//  EDTracker-Mac
//
//  Created by David on 30/01/2016.
//  Copyright (c) 2016 D Henderson. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
@import ORSSerial;

@interface MainViewController ()

@end

@implementation MainViewController

- (ORSSerialPortManager *)serialPortManager {
	return [ORSSerialPortManager sharedSerialPortManager];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.

	_hasverbose = false;
	_hasinfo = false;
	
	_xval = 0;
	_temp = 0.0;
	
	_magoffset = [[Vector3 alloc]init];
	_magcalmat = [[Matrix33 alloc]init];
	
	_qpoints = [[QLineStore alloc]init];

	NSLog( @"MainViewController: Initialising SerialController." );
	_serialController = [[SerialControl alloc] init];
	_serialController.viewcontrol = self;
	NSLog( @"MainViewController: SerialController initialisation routines called." );
	
	_gltopdown.viewcontrol = self;
	_glfronton.viewcontrol = self;
	
	[self activateButtons:false];
}

- (void)update {

	// state vars
	
	[_xlevel setIntValue:_xval];
	[_ylevel setIntValue:_yval];
	[_zlevel setIntValue:_zval];

	[_axlevel setIntValue:_accx];
	[_aylevel setIntValue:_accy];
	[_azlevel setIntValue:_accz];

	[_gxlevel setIntValue:_gyrox];
	[_gylevel setIntValue:_gyroy];
	[_gzlevel setIntValue:_gyroz];
	
	[_tfield setStringValue:[NSString stringWithFormat:@"%.1f", _temp]];
	switch(_orient) {
		case(0):
			[_orientfield setStringValue:@"Top/USB Right"];
			break;
		case(1):
			[_orientfield setStringValue:@"Top/USB Front"];
			break;
		case(3):
			[_orientfield setStringValue:@"Top/USB Rear"];
			break;
		case(4):
			[_orientfield setStringValue:@"Left/USB Down"];
			break;
		case(5):
			[_orientfield setStringValue:@"Right/USB Down"];
			break;
		default:
			[_orientfield setStringValue:@"Top/USB Left"];
			break;
	}

	if(_response == 1)
		[_respfield setStringValue:@"Exponential"];
	else
		[_respfield setStringValue:@"Linear"];

	[_yscalefield setStringValue:[NSString stringWithFormat:@"%.2f", _yscale]];
	[_pscalefield setStringValue:[NSString stringWithFormat:@"%.2f", _pscale]];
	[_smoothfield setStringValue:[NSString stringWithFormat:@"%.1f", _smoothing*100.0]];
//	[_smoothslider setFloatValue:_smoothing*100.0];
	
	[_magoffx setIntValue:(int)[_magoffset getElementN:1]];
	[_magoffy setIntValue:(int)[_magoffset getElementN:2]];
	[_magoffz setIntValue:(int)[_magoffset getElementN:3]];
	
	[_magcal11 setFloatValue:[[self magcalmat] getElementi:1 j:1]];
	[_magcal12 setFloatValue:[[self magcalmat] getElementi:1 j:2]];
	[_magcal13 setFloatValue:[[self magcalmat] getElementi:1 j:3]];
	[_magcal21 setFloatValue:[[self magcalmat] getElementi:2 j:1]];
	[_magcal22 setFloatValue:[[self magcalmat] getElementi:2 j:2]];
	[_magcal23 setFloatValue:[[self magcalmat] getElementi:2 j:3]];
	[_magcal31 setFloatValue:[[self magcalmat] getElementi:3 j:1]];
	[_magcal32 setFloatValue:[[self magcalmat] getElementi:3 j:2]];
	[_magcal33 setFloatValue:[[self magcalmat] getElementi:3 j:3]];
	
	[_magpoints setIntegerValue:[_qpoints count]];

}

-(IBAction)DTR:(id)sender {
	bool dtr = _serialController.port.DTR;
	dtr = !dtr;
	_serialController.port.DTR = dtr;
	if( dtr )
		[sender setTitle:@"DTR Off"];
	else
		[sender setTitle:@"DTR On"];
}

-(IBAction)OpenSerial:(id)sender {
	_hasverbose = false;
	_hasinfo = false;
	NSLog( @"MainViewController: OpenSerial()" );
	[_serialController OpenSerial];
}

-(IBAction)CloseSerial:(id)sender {
	[_serialController CloseSerial];
	_hasverbose = false;
	_hasinfo = false;
}

-(IBAction)MountOrientation:(id)sender {
	[_serialController SendCString:"P"];
}

- (IBAction)ResponseMode:(id)sender {
	[_serialController SendCString:"t"];
}

- (IBAction)Recentre:(id)sender {
	[_serialController SendCString:"R"];
}

- (IBAction)GyroBias:(id)sender {
	[_serialController SendCString:"r"];
	// pop up progress pane
	
	if( !_pleasewaitsheet )
		[NSBundle loadNibNamed:@"PleaseWait" owner:self];
	[NSApp beginSheet:self.pleasewaitsheet
	   modalForWindow:self.appdelegate.window
		modalDelegate:self
	   didEndSelector:NULL
		  contextInfo:NULL];

	[[self pinwheel] setHidden:NO];
	[[self pinwheel] setIndeterminate:YES];
	[[self pinwheel] setUsesThreadedAnimation:YES];
	[[self pinwheel] startAnimation:nil];

}

-(IBAction)closePleaseWaitSheet:(id)sender {
	if( self.pleasewaitsheet ) {
		[NSApp endSheet:self.pleasewaitsheet];
		[self.pleasewaitsheet close];
		self.pleasewaitsheet = nil;
	}
}

-(IBAction)SavePoints:(id)sender {
	//	[[_serialController port]sendData:[NSData dataWithBytes:"I" length:1]];
	//	NSLog(@"Sent I");
	[_qpoints dumpStore];
}
-(IBAction)LoadPoints:(id)sender {
	//	[[_serialController port]sendData:[NSData dataWithBytes:"I" length:1]];
	//	NSLog(@"Sent I");
	[_qpoints loadStore];
}

- (IBAction)PauseQ:(id)sender {
	[_qpoints setIspaused:![_qpoints ispaused]];
}

- (IBAction)ClearQList:(id)sender {
	[_qpoints clearList];
}

- (IBAction)ChangeYawScale:(id)sender {
	if( [sender integerValue] < 0 ) {
		NSLog(@"Yaw Minus");
		_yscale -= 0.25;
	}
	else {
		NSLog(@"Yaw Plus");
		_yscale += 0.25;
	}
	if( _yscale < 0.25 )
		_yscale = 0.25;
	[sender setIntValue:0];
	[_serialController writeScaleYaw:_yscale Pitch:_pscale Smoothing:_smoothing];
}

- (IBAction)ChangePitchScale:(id)sender {
	if( [sender integerValue] < 0 ) {
		NSLog(@"Pitch Minus");
		_pscale -= 0.25;
	}
	else {
		NSLog(@"Pitch Plus");
		_pscale += 0.25;
	}
	if( _pscale < 0.25 )
		_pscale = 0.25;
	[sender setIntValue:0];
	[_serialController writeScaleYaw:_yscale Pitch:_pscale Smoothing:_smoothing];
}

- (IBAction)ChangeSmoothing:(id)sender {
	_smoothing = [sender floatValue]/100.0;
	NSLog(@"Smooth: %.1f", _smoothing);
	[_serialController writeScaleYaw:_yscale Pitch:_pscale Smoothing:_smoothing];
}


-(void)activateButtons:(BOOL)set {
	[self.openbutton setEnabled:!set];
	[self.closebutton setEnabled:set];
	[self.orientbutton setEnabled:set];
	[self.responsebutton setEnabled:set];
	[self.yawstepper setEnabled:set];
	[self.pitchstepper setEnabled:set];
	[self.smoothslider setEnabled:set];
	[self.recentrebutton setEnabled:set];
	[self.biasbutton setEnabled:set];
	[self.xoffstepper setEnabled:set];
	[self.yoffstepper setEnabled:set];
	[self.zoffstepper setEnabled:set];
	[self.xmatstepper setEnabled:set];
	[self.ymatstepper setEnabled:set];
	[self.zmatstepper setEnabled:set];
}

- (IBAction)xoffchange:(id)sender {
	[_magoffset setElementValue:[_xoffstepper floatValue] n:1];
}
- (IBAction)yoffchange:(id)sender {
	[_magoffset setElementValue:[_yoffstepper floatValue] n:2];
}
- (IBAction)zoffchange:(id)sender {
	[_magoffset setElementValue:[_zoffstepper floatValue] n:3];
}

- (IBAction)xmagchange:(id)sender {
	[_magcalmat setElementValue:[_xmatstepper floatValue] i:1 j:1];
}
- (IBAction)ymagchange:(id)sender {
	[_magcalmat setElementValue:[_ymatstepper floatValue] i:2 j:2];
}
- (IBAction)zmagchange:(id)sender {
	[_magcalmat setElementValue:[_zmatstepper floatValue] i:3 j:3];
}

- (IBAction)uploadCalData:(id)sender {
//	write$Data:(Vector3*)offset unrotmatrix:(Matrix33*)matrix {
	[_serialController write$Data:_magoffset unrotmatrix:_magcalmat];
}

- (IBAction)resetCalibration:(id)sender {
	[_magoffset setElementValue:0.0 n:1];
	[_magoffset setElementValue:0.0 n:2];
	[_magoffset setElementValue:0.0 n:3];
	
	[_magcalmat setElementValue:1.0 i:1 j:1];
	[_magcalmat setElementValue:0.0 i:2 j:1];
	[_magcalmat setElementValue:0.0 i:3 j:1];
	[_magcalmat setElementValue:0.0 i:1 j:2];
	[_magcalmat setElementValue:1.0 i:2 j:2];
	[_magcalmat setElementValue:0.0 i:3 j:2];
	[_magcalmat setElementValue:0.0 i:1 j:3];
	[_magcalmat setElementValue:0.0 i:2 j:3];
	[_magcalmat setElementValue:1.0 i:3 j:3];
}

- (IBAction)autoFit:(id)sender {
	[_qpoints autoFitOffset:_magoffset magMat:_magcalmat];

	[_xoffstepper setFloatValue:[_magoffset x]];
	[_yoffstepper setFloatValue:[_magoffset y]];
	[_zoffstepper setFloatValue:[_magoffset z]];

	[_xmatstepper setFloatValue:[_magcalmat getElementi:1 j:1]];
	[_ymatstepper setFloatValue:[_magcalmat getElementi:2 j:2]];
	[_zmatstepper setFloatValue:[_magcalmat getElementi:3 j:3]];
}

@end
