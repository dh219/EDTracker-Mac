//
//  MainViewController.h
//  EDTracker-Mac
//
//  Created by David on 30/01/2016.
//  Copyright (c) 2016 D Henderson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SerialControl.h"
#import "Matrix33.h"
#import "Vector3.h"
#import "QLineStore.h"
#import "PointViewer.h"

@class AppDelegate;
@class ORSSerialPortManager;

@interface MainViewController : NSViewController

@property (weak) AppDelegate* appdelegate;
@property SerialControl *serialController;
@property (nonatomic, readonly) ORSSerialPortManager *serialPortManager;

// outlets


@property (assign) IBOutlet NSWindow *pleasewaitsheet;

@property (weak) IBOutlet NSLevelIndicator *xlevel;
@property (weak) IBOutlet NSLevelIndicator *ylevel;
@property (weak) IBOutlet NSLevelIndicator *zlevel;

@property (weak) IBOutlet NSLevelIndicator *axlevel;
@property (weak) IBOutlet NSLevelIndicator *aylevel;
@property (weak) IBOutlet NSLevelIndicator *azlevel;

@property (weak) IBOutlet NSLevelIndicator *gxlevel;
@property (weak) IBOutlet NSLevelIndicator *gylevel;
@property (weak) IBOutlet NSLevelIndicator *gzlevel;

@property (weak) IBOutlet NSTextField *tfield;
@property (weak) IBOutlet NSTextField *orientfield;
@property (weak) IBOutlet NSTextField *respfield;

@property (weak) IBOutlet NSTextField *yscalefield;
@property (weak) IBOutlet NSTextField *pscalefield;
@property (weak) IBOutlet NSTextField *smoothfield;

@property (weak) IBOutlet NSTextField *magoffx;
@property (weak) IBOutlet NSTextField *magoffy;
@property (weak) IBOutlet NSTextField *magoffz;

@property (weak) IBOutlet NSTextField *magcal11;
@property (weak) IBOutlet NSTextField *magcal12;
@property (weak) IBOutlet NSTextField *magcal13;
@property (weak) IBOutlet NSTextField *magcal21;
@property (weak) IBOutlet NSTextField *magcal22;
@property (weak) IBOutlet NSTextField *magcal23;
@property (weak) IBOutlet NSTextField *magcal31;
@property (weak) IBOutlet NSTextField *magcal32;
@property (weak) IBOutlet NSTextField *magcal33;
@property (weak) IBOutlet NSTextField *magpoints;

@property (weak) IBOutlet NSProgressIndicator *pinwheel;

@property (weak) IBOutlet PointViewer *gltopdown;
@property (weak) IBOutlet PointViewer *glfronton;

// state variables

@property (assign) bool hasinfo;
@property (assign) bool hasverbose;

@property (assign) int xval;
@property (assign) int yval;
@property (assign) int zval;

@property (assign) int accx;
@property (assign) int accy;
@property (assign) int accz;

@property (assign) int gyrox;
@property (assign) int gyroy;
@property (assign) int gyroz;

@property (assign) float temp;
@property (assign) short orient;

@property (assign) short response;
@property (assign) float pscale;
@property (assign) float yscale;
@property (assign) float smoothing;

@property (strong) Vector3*	magoffset;
@property (strong) Matrix33* magcalmat;

@property (strong) QLineStore *qpoints;


-(void)update;
- (ORSSerialPortManager *)serialPortManager;
-(void)activateButtons:(BOOL)set;

// buttons
@property (weak) IBOutlet NSButton *openbutton;
@property (weak) IBOutlet NSButton *closebutton;
@property (weak) IBOutlet NSButton *orientbutton;
@property (weak) IBOutlet NSButton *responsebutton;
@property (weak) IBOutlet NSStepper *yawstepper;
@property (weak) IBOutlet NSStepper *pitchstepper;
@property (weak) IBOutlet NSSlider *smoothslider;
@property (weak) IBOutlet NSButton *recentrebutton;
@property (weak) IBOutlet NSButton *biasbutton;

@property (weak) IBOutlet NSStepper *xoffstepper;
@property (weak) IBOutlet NSStepper *yoffstepper;
@property (weak) IBOutlet NSStepper *zoffstepper;
@property (weak) IBOutlet NSStepper *xmatstepper;
@property (weak) IBOutlet NSStepper *ymatstepper;
@property (weak) IBOutlet NSStepper *zmatstepper;



// button functions et al
-(IBAction)DTR:(id)sender;
-(IBAction)OpenSerial:(id)sender;
-(IBAction)CloseSerial:(id)sender;
-(IBAction)MountOrientation:(id)sender;
- (IBAction)ResponseMode:(id)sender;
- (IBAction)Recentre:(id)sender;
- (IBAction)GyroBias:(id)sender;

- (IBAction)SavePoints:(id)sender;
- (IBAction)LoadPoints:(id)sender;
- (IBAction)PauseQ:(id)sender;
- (IBAction)ClearQList:(id)sender;

-(IBAction)closePleaseWaitSheet:(id)sender;

@end

