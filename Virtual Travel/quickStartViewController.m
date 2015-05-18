//
//  quickStartViewController.m
//  Virtual Travel
//
//  Created by Steve-Mac on 2014. 11. 28..
//  Copyright (c) 2014년 InciteStudio. All rights reserved.
//

#import "quickStartViewController.h"

@interface quickStartViewController ()

@end

@implementation quickStartViewController



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    SWRevealViewController *revealController = self.revealViewController;
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    [self.navigationItem setTitle:@"Quick Start"];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"] style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)]];
    searchListView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 180.0f, 290.0f)];
    searchListView.delegate = self;
    searchListView.dataSource = self;
    [self.view addSubview:searchListView];
    placeSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 32.0f, 180.0f, 30.0f)];
    placeSearchBar.delegate = self;
    [self.view addSubview:placeSearchBar];
    resultArray = [[NSMutableArray alloc] init];
    

    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:0.0f longitude:0.0f zoom:1];
    
    mapView = [GMSMapView mapWithFrame:CGRectMake(180.0f, 30.0f, 388.0f, 290.0f) camera:camera];
    [mapView setIndoorEnabled:NO];
    mapView.mapType = kGMSTypeNormal;
    
    [self.view addSubview:mapView];
    
    UIBarButtonItem *startBtn = [[UIBarButtonItem alloc] initWithTitle:@"START" style:UIBarButtonItemStyleBordered target:self action:@selector(startBtnClicked:)];
    self.navigationItem.rightBarButtonItem = startBtn;
    
}
-(void) hideKeyboard
{
    [placeSearchBar resignFirstResponder];
}
-(void) startBtnClicked:(id)sender
{
    streetViewController *street = [[streetViewController alloc] init];
    [street setStartCoord:marker.position];
    
    [self.navigationController pushViewController:street animated:YES];
}
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [resultArray removeAllObjects];
    CLGeocoder *myGeocoder = [[CLGeocoder alloc]init];
    [myGeocoder geocodeAddressString:searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        for(CLPlacemark *mark in placemarks){
            [resultArray addObject:mark];
        }
        [searchListView reloadData];
    }];
    [searchBar resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [resultArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    CLPlacemark *mark = [resultArray objectAtIndex:indexPath.row];
    cell.textLabel.text = mark.name;
    return cell;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CLPlacemark *mark = [resultArray objectAtIndex:indexPath.row];
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(mark.location.coordinate.latitude, mark.location.coordinate.longitude);
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:mark.location.coordinate.latitude longitude:mark.location.coordinate.longitude zoom:15];
    [mapView setCamera:camera];
    [mapView clear];
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(loc.latitude, loc.longitude);
    if(marker != nil){
        marker.map = nil;
        marker = nil;
    }
    marker= [GMSMarker markerWithPosition:position];
    marker.title = @"START";
    marker.map = mapView;
    [marker setDraggable:YES];
    
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [placeSearchBar resignFirstResponder];
    
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

