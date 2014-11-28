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
    
    
    
        UIBarButtonItem *startBtn = [[UIBarButtonItem alloc] initWithTitle:@"START" style:UIBarButtonItemStyleBordered target:self action:@selector(startBtnClicked:)];
    self.navigationItem.rightBarButtonItem = startBtn;
    self.view = mapView;
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(48.8578781, 2.2952149);
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.title = @"Hello World";
    marker.map = mapView;
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 30.0f)];
    [self.navigationItem setTitleView:searchBar];
    
    
}
-(void) startBtnClicked:(id)sender
{
    streetViewController *street = [[streetViewController alloc] init];
    [self.navigationController pushViewController:street animated:YES];
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

