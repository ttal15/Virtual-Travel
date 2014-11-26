//

//  settingViewController.m

//  VitualTravel

//

//  Created by Steve-Mac on 2014. 11. 26..

//  Copyright (c) 2014년 InciteStudio. All rights reserved.

//



#import "settingViewController.h"



@interface settingViewController ()



@end



@implementation settingViewController



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:48.8578781 longitude:2.2952149 zoom:20];
    
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    mapView.mapType = kGMSTypeNormal;
    
    [[UIScreen mainScreen] bounds];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] bounds].size.width, 30.0f)];
    
//    [toolbar setBackgroundColor:[UIColor blackColor]];
    self.view = mapView;
    NSLog(@"%lf  %lf",self.view.frame.size.width,self.view.frame.size.height);
    [self.view addSubview:toolbar];
    
    
    
}

-(BOOL) shouldAutorotate{
    
    return YES;
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
}

/*
 
 #pragma mark - Navigation
 
 
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
 // Get the new view controller using [segue destinationViewController].
 
 // Pass the selected object to the new view controller.
 
 }
 
 */



@end

