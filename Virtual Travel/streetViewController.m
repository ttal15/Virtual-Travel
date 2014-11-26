//
//  streetViewController.m
//  VitualTravel
//
//  Created by Steve-Mac on 2014. 11. 26..
//  Copyright (c) 2014년 InciteStudio. All rights reserved.
//

#import "streetViewController.h"

@interface streetViewController ()
@property (strong, nonatomic) AVPlayer *player;
@end

@implementation streetViewController
@synthesize motion;
@synthesize attitude;
@synthesize roll;
@synthesize pitch;
@synthesize yaw;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    /*
     *  Without some sort of
     *  audio player, the remote
     *  remains unavailable to this
     *  app, and the previous app will
     *  maintain control over it.
     */
    
    _player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:@"http://stream.jewishmusicstream.com:8000"]];
    
    /*  Kicking off playback takes over
     *  the software based remote control
     *  interface in the lock screen and
     *  in Control Center.
     */
    
    [_player play];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isMoving = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveTo) name:@"move" object:nil];
    // Do any additional setup after loading the view, typically from a nib.
    panoService = [[GMSPanoramaService alloc] init];
    panoView = [[GMSPanoramaView alloc] initWithFrame:CGRectZero];
    self.view = panoView;
    
    coor = CLLocationCoordinate2DMake(48.8578781,2.2952149);
    [panoView moveNearCoordinate:coor];
    [panoView setStreetNamesHidden:YES];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    locationManager.distanceFilter = 1000;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    [locationManager startUpdatingLocation];
    
    // Start heading updates.
    if ([CLLocationManager headingAvailable]) {
        locationManager.headingFilter = 5;
        [locationManager startUpdatingHeading];
    }
    motionManager = [[CMMotionManager alloc] init];
    motionManager.deviceMotionUpdateInterval = 1.0f/20.0f;
    
    if(motionManager.gyroAvailable){
        [motionManager startDeviceMotionUpdates];
        timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self
                                               selector:@selector(updateGyro) userInfo:nil repeats:YES];
    }
    //    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(checkMove) userInfo:nil repeats:YES];
}
-(void) checkMove
{
    if(isChecking) return;
    isChecking = YES;
    if (speechRecognizer != nil) {
        speechRecognizer = nil;
    }
    
    NSMutableDictionary *config = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"2b268b18991386c80c9054ab1aee8ce709b3085c", SpeechRecognizerConfigKeyApiKey,
                                   SpeechRecognizerServiceTypeDictation, SpeechRecognizerConfigKeyServiceType, nil];
    speechRecognizer = [[MTSpeechRecognizerClient alloc] initWithConfig:config];
    [speechRecognizer setDelegate:self];
    
    [speechRecognizer startRecording];
    
}
- (void) moveTo{
    NSArray *links = panoView.panorama.links;
    selectedPanorama = [links objectAtIndex:0];
    double heading = fabs(currentHeading - selectedPanorama.heading);
    for(int i=1;i<[links count];i++){
        double tempHeading = fabs(currentHeading - [(GMSPanoramaLink *)[links objectAtIndex:i] heading]);
        if(heading > tempHeading){
            heading = tempHeading;
            selectedPanorama = [links objectAtIndex:i];
        }
    }
    isMoving = YES;
    [panoView animateToCamera:[GMSPanoramaCamera cameraWithOrientation:panoView.camera.orientation zoom:3.0f] animationDuration:0.5f];
    [NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(moveToPanoramaID) userInfo:self repeats:NO];
    
    
}
-(void) moveToPanoramaID
{
    isMoving = NO;
    [panoView moveToPanoramaID:selectedPanorama.panoramaID];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    if(isMoving) return;
    // Use the true heading if it is valid.
    CLLocationDirection  theHeading = ((newHeading.trueHeading > 0) ?
                                       newHeading.trueHeading : newHeading.magneticHeading);
    [panoView setCamera:[GMSPanoramaCamera cameraWithHeading:theHeading pitch:panoView.camera.orientation.pitch zoom:1.0f]];
    currentHeading = theHeading;
    
}
-(void) updateGyro{
    if(isMoving) return;
    short tempRoll;
    short tempPitch;
    motion = motionManager.deviceMotion;
    attitude = motion.attitude;
    
    tempRoll = (short) (attitude.roll*180 / M_PI);
    tempPitch = (short) (attitude.pitch*180 / M_PI);
    yaw = (short) (attitude.yaw*180 / M_PI);
    [panoView setCamera:[GMSPanoramaCamera cameraWithHeading:currentHeading pitch:(roll-80.0f) zoom:1.0f]];
    roll = tempRoll;
    pitch = tempPitch;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    
    NSLog(@"event");
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [self moveTo];
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                break;
                
            default:
                break;
        }
    }
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}
#pragma mark ---- MTSpeechRecognizerDelegate ----

- (void)onReady {
    
}

- (void)onBeginningOfSpeech {
    
}

- (void)onEndOfSpeech {
    
}

- (void)onError:(MTSpeechRecognizerError)errorCode message:(NSString *)message {
    if (speechRecognizer) {
        speechRecognizer = nil;
    }
    NSLog(@"%@",message);
}

- (void)onPartialResult:(NSString *)partialResult {
    NSString *result = partialResult;
    if (result.length > 0) {
    }
}

- (void)onResults:(NSArray *)results confidences:(NSArray *)confidences marked:(BOOL)marked {
    if (speechRecognizer) {
        speechRecognizer = nil;
    }
    isChecking = NO;
    NSMutableString *resultLabel = [[NSMutableString alloc] initWithString:@"result (confidence)\n"];
    
    for (int i = 0; i < [results count]; i++) {
        [resultLabel appendString:[NSString stringWithFormat:@"%@ (%d)\n", [results objectAtIndex:i], [[confidences objectAtIndex:i] intValue]]];
    }
    NSLog(@"%@",resultLabel);
}

- (void)onAudioLevel:(float)audioLevel {
    
}

- (void)onFinished {
    isChecking = NO;
    
}
@end
