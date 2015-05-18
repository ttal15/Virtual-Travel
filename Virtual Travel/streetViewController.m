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
    [_player setVolume:0.0f];
    
    /*  Kicking off playback takes over
     *  the software based remote control
     *  interface in the lock screen and
     *  in Control Center.
     */
    
    [_player play];
}
- (void)viewDidLoad {
    bdAngle = 3.0f;
    [super viewDidLoad];
    isMoving = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveTo) name:@"move" object:nil];
    // Do any additional setup after loading the view, typically from a nib.
    panoService = [[GMSPanoramaService alloc] init];
    panoView = [[GMSPanoramaView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] bounds].size.width/2, 320.0f)];
    panoView.delegate =self;
    [self.view addSubview:panoView];
    rightPanoView = [[GMSPanoramaView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2, 0.0f, [[UIScreen mainScreen] bounds].size.width/2, 320.0f)];
    [self.view addSubview:rightPanoView];
//startCoord = CLLocationCoordinate2DMake(43.7696488,11.2553579);
    [panoView moveNearCoordinate:startCoord];
    [panoView setStreetNamesHidden:YES];
    [rightPanoView moveNearCoordinate:startCoord];
    [rightPanoView setStreetNamesHidden:YES];

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
   self.navigationController.navigationBarHidden = YES;
//    if(autoTravel){
//        [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(moveAutomatically) userInfo:nil repeats:YES];
  //  }
    markerArray = [[NSMutableArray alloc] init];
    
    GMSPanoramaLayer *layer = [GMSPanoramaLayer layer];
    layer.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    layer.contents = (id) [UIImage imageNamed:@"]

}
-(void) moveAutomatically
{
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:panoView.panorama.coordinate.latitude longitude:panoView.panorama.coordinate.longitude];
    CLLocation *destLocation = [[CLLocation alloc] initWithLatitude:[path coordinateAtIndex:0].latitude longitude:[path coordinateAtIndex:0].longitude];
    int index = 0;
    float dist = [currentLocation distanceFromLocation:destLocation];
    for(int i=1;i<[path count];i++){
        destLocation = [[CLLocation alloc] initWithLatitude:[path coordinateAtIndex:i].latitude longitude:[path coordinateAtIndex:i].longitude];
        if(dist > [currentLocation distanceFromLocation:destLocation]){
            index = i;
            dist = [currentLocation distanceFromLocation:destLocation];
        }
    }
    if(index == [path count]-1) return;
    NSArray *links = panoView.panorama.links;
    float currHeading = [self getHeadingForDirectionFromCoordinate:panoView.panorama.coordinate toCoordinate:[path coordinateAtIndex:index+1]];
    selectedPanorama = [links objectAtIndex:0];
    double heading = fabs(currHeading - selectedPanorama.heading);
    for(int i=1;i<[links count];i++){
        double tempHeading = fabs(currHeading - [(GMSPanoramaLink *)[links objectAtIndex:i] heading]);
        if(heading > tempHeading){
            heading = tempHeading;
            selectedPanorama = [links objectAtIndex:i];
        }
    }
    
    isMoving = YES;
    [panoView animateToCamera:[GMSPanoramaCamera cameraWithOrientation:panoView.camera.orientation zoom:3.0f] animationDuration:0.5f];
    [rightPanoView animateToCamera:[GMSPanoramaCamera cameraWithOrientation:rightPanoView.camera.orientation zoom:3.0f] animationDuration:0.5f];
    [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(moveToPanoramaID) userInfo:self repeats:NO];
}
- (float) getHeadingForDirectionFromCoordinate:(CLLocationCoordinate2D)fromLoc toCoordinate:(CLLocationCoordinate2D)toLoc
{
    float fLat = fromLoc.latitude;
    float fLng = fromLoc.longitude;
    float tLat = toLoc.latitude;
    float tLng = toLoc.longitude;
    
    return atan2(sin(fLng-tLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(fLng-tLng));
}

-(void) setStartCoord:(CLLocationCoordinate2D)coord
{
    startCoord = coord;
}
-(void) setPath:(GMSPath *)p
{
    path = p;
}
-(void) checkMove
{
    if(isChecking) return;
    isChecking = YES;
    
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
    [rightPanoView animateToCamera:[GMSPanoramaCamera cameraWithOrientation:rightPanoView.camera.orientation zoom:3.0f] animationDuration:0.5f];
    [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(moveToPanoramaID) userInfo:self repeats:NO];
    
    
}
-(void) moveToPanoramaID
{
    isMoving = NO;
    [panoView moveToPanoramaID:selectedPanorama.panoramaID];
    [rightPanoView moveToPanoramaID:selectedPanorama.panoramaID];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    if(isMoving) return;
    // Use the true heading if it is valid.
    CLLocationDirection  theHeading = ((newHeading.trueHeading > 0) ?
                                       newHeading.trueHeading : newHeading.magneticHeading);
    [panoView setCamera:[GMSPanoramaCamera cameraWithHeading:theHeading pitch:panoView.camera.orientation.pitch zoom:1.0f]];
    [rightPanoView setCamera:[GMSPanoramaCamera cameraWithHeading:theHeading+bdAngle pitch:panoView.camera.orientation.pitch zoom:1.0f]];
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
    [rightPanoView setCamera:[GMSPanoramaCamera cameraWithHeading:currentHeading+bdAngle pitch:(roll-80.0f) zoom:1.0f]];
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
                [self.navigationController setNavigationBarHidden:NO];
                [self.navigationController popToRootViewControllerAnimated:NO];
                break;
                
            default:
                break;
        }
    }
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}
-(void)panoramaView:(GMSPanoramaView *)view didMoveToPanorama:(GMSPanorama *)panorama{
    for(GMSMarker *m in markerArray){
        m.panoramaView = nil;
    }
    [markerArray removeAllObjects];
    GMSMarker *mark = [GMSMarker markerWithPosition:panorama.coordinate];
    mark.icon = [UIImage imageNamed:@"exit.png"];
    mark.panoramaView = panoView;
    GMSMarker *mark2 = [GMSMarker markerWithPosition:panorama.coordinate];
    mark2.icon = [UIImage imageNamed:@"exit.png"];
    mark2.panoramaView = rightPanoView;
    [markerArray addObject:mark];
    [markerArray addObject:mark2];
    for(GMSPanoramaLink *link in panorama.links){
        [panoService requestPanoramaWithID:link.panoramaID callback:^(GMSPanorama *panorama, NSError *error) {
            GMSMarker* marker = [GMSMarker markerWithPosition:panorama.coordinate];
            marker.icon = [UIImage imageNamed:@"123.png"];
            [marker setOpacity:0.5f];
            marker.panoramaView = panoView;
            [markerArray addObject:marker];
            GMSMarker* marker2 = [GMSMarker markerWithPosition:panorama.coordinate];
            marker2.icon = [UIImage imageNamed:@"123.png"];
            [marker2 setOpacity:0.5f];
            marker2.panoramaView = rightPanoView;
            [markerArray addObject:marker2];
        }];
    }
    
}

@end
