//
//  streetViewController.h
//  VitualTravel
//
//  Created by Steve-Mac on 2014. 11. 26..
//  Copyright (c) 2014년 InciteStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreMotion/CoreMotion.h>
#import <Parse/Parse.h>
#import <DaumSpeech/DaumSpeechRecognizer.h>
#import <DaumSpeech/DaumTextToSpeech.h>
#import <AVFoundation/AVFoundation.h>

@interface streetViewController : UIViewController<CLLocationManagerDelegate,MTSpeechRecognizerDelegate, MTSpeechRecognizerViewDelegate>
{
    GMSPanoramaView *panoView;
    GMSPanoramaService *panoService;
    
    CLLocationManager *locationManager;
    CMMotionManager *motionManager;
    CMDeviceMotion *motion;
    CMAttitude *attitude;
    CLLocationDirection currentHeading;
    NSTimer *timer;
    
    
    CLLocationCoordinate2D coor;
    GMSPanoramaLink *selectedPanorama;
    
    short roll;
    short pitch;
    short yaw;
    BOOL isMoving;
    BOOL isChecking;
    
    MTSpeechRecognizerClient *speechRecognizer;
}
@property (nonatomic, retain) CMDeviceMotion *motion;
@property (nonatomic, retain) CMAttitude *attitude;
@property short roll;
@property short pitch;
@property short yaw;

-(void) updateGyro;
-(void) moveTo;
-(void) moveToPanoramaID;
-(void) checkMove;
@end
