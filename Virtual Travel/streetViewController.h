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
#import <AVFoundation/AVFoundation.h>

@interface streetViewController : UIViewController<CLLocationManagerDelegate,GMSPanoramaViewDelegate>
{
    GMSPanoramaView *panoView;
    GMSPanoramaView *rightPanoView;
    GMSPanoramaService *panoService;
    
    CLLocationManager *locationManager;
    CMMotionManager *motionManager;
    CMDeviceMotion *motion;
    CMAttitude *attitude;
    CLLocationDirection currentHeading;
    NSTimer *timer;
    
    
    GMSPanoramaLink *selectedPanorama;
    
    short roll;
    short pitch;
    short yaw;
    BOOL isMoving;
    BOOL isChecking;
    
    CLLocationCoordinate2D startCoord;
    float bdAngle;
    BOOL autoTravel;
    GMSPath *path;
    NSMutableArray *markerArray;
    
}
@property (nonatomic, retain) CMDeviceMotion *motion;
@property (nonatomic, retain) CMAttitude *attitude;
@property short roll;
@property short pitch;
@property short yaw;
-(void) moveAutomatically;
-(void) setPath:(GMSPath *) p;
-(void) setStartCoord:(CLLocationCoordinate2D) coord;
-(void) updateGyro;
-(void) moveTo;
-(void) moveToPanoramaID;
-(void) checkMove;
@end
