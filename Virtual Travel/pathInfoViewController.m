//
//  pathInfoViewController.m
//  Virtual Travel
//
//  Created by Steve-Mac on 2014. 11. 30..
//  Copyright (c) 2014년 InciteStudio. All rights reserved.
//

#import "pathInfoViewController.h"
#import "MDDirectionService.h"
@interface pathInfoViewController ()

@end

@implementation pathInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SWRevealViewController *revealController = self.revealViewController;
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    [self.navigationItem setTitle:@"PathList"];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"] style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)]];
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveBtnClicked:)];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(CancelBtnClicked:)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:saveBtn,cancelBtn,nil]];
    titleField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 250.0f, 30.0f)];
    titleField.delegate = self;
    [titleField setTextAlignment:NSTextAlignmentCenter];
    [titleField setBackgroundColor:[UIColor whiteColor]];
    [titleField setPlaceholder:@"Enter the path title!"];
    [titleField setReturnKeyType:UIReturnKeyDone];
    [self.navigationItem setTitleView:titleField];
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:0.0f longitude:0.0f zoom:1];
    
    mapView = [GMSMapView mapWithFrame:CGRectMake(150.0f, 30.0f, 268.0f, 290.0f) camera:camera];
    [mapView setIndoorEnabled:NO];
    [mapView setDelegate:self];
    
    mapView.mapType = kGMSTypeNormal;
    [self.view addSubview:mapView];
    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_marker.png"]];
//    imageView.frame = CGRectMake(50.0f, 50.0f, 50.0f, 50.0f);
//    [mapView addSubview:imageView];
    if(saveObject == nil){
        saveObject = [PFObject objectWithClassName:@"PathList"];
    }
    
    searchArray = [[NSMutableArray alloc] init];
    pathArray = [[NSMutableArray alloc] init];
    


    
    pathTable = [[UITableView alloc] initWithFrame:CGRectMake(568.0f-150.0f, 30.0f, 150.0f, 290.0f) style:UITableViewStyleGrouped];
    pathTable.delegate = self;
    pathTable.dataSource = self;
    [self.view addSubview:pathTable];
    UIToolbar *pathToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(568.0f-150.0f, 30.0f, 150.0f, 30.0f)];
//    [pathToolBar setTintColor:[UIColor blueColor]];
    [self.view addSubview:pathToolBar];
    
    editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editPath:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [pathToolBar setItems:[NSArray arrayWithObjects:space,editButton, nil]];
    
    searchTable = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 150.0f, 290.0f) style:UITableViewStyleGrouped];
    searchTable.delegate = self;
    searchTable.dataSource = self;
    [self.view addSubview:searchTable];
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 150.0f, 30.0f)];
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    
    
    
    UIView *pickBackView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 60.0f)];
    [pickBackView setBackgroundColor:[UIColor whiteColor]];
    [mapView addSubview:pickBackView];
    UILabel *pickLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 20.0f)];
    [pickLabel setAdjustsFontSizeToFitWidth:YES];
    pickLabel.text = @"Drag & Drop";
    [pickBackView addSubview:pickLabel];
    pickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pickButton.frame = CGRectMake(20.0f, 20.0f, 22.0f, 39.0f);
    [pickButton setBackgroundImage:[UIImage imageNamed:@"default_marker.png"] forState:UIControlStateNormal];
    [pickButton addTarget:self action:@selector(pickButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [pickBackView addSubview:pickButton];
    
    titleField.text = saveObject[@"pathName"];
    NSMutableArray *pathArr = saveObject[@"pathArray"];
    for(int i=0;i<[pathArr count];i++){
        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([[[pathArr objectAtIndex:i] objectForKey:@"latitude"] floatValue], [[[pathArr objectAtIndex:i] objectForKey:@"longitude"] floatValue]);
        GMSMarker *marker = [GMSMarker markerWithPosition:loc];
        marker.title = [[pathArr objectAtIndex:i] objectForKey:@"markerName"];
        [pathArray addObject:marker];
        marker.map = mapView;
        [marker setDraggable:YES];
        [mapView setCamera:[GMSCameraPosition cameraWithLatitude:loc.latitude longitude:loc.longitude zoom:12.0f]];
    }
    polyline = [GMSPolyline polylineWithPath:[GMSPath pathFromEncodedPath:saveObject[@"GMSPath"]]];
    polyline.map = mapView;
    index = 0;
}
-(void) setSaveObject:(PFObject *) obj
{
    saveObject = obj;
}
-(void) editPath:(id)sender
{
    [pathTable setEditing:!pathTable.editing];
    if(pathTable.editing){
        [editButton setTitle:@"Done"];
    }else{
        [editButton setTitle:@"Edit"];
    }
}
-(void) pickButtonClicked:(id)sender
{
    [pickButton setHidden:YES];
    selectedPickImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_marker.png"]];
    selectedPickImage.frame = CGRectMake(20.0f, 20.0f, 22.0f, 39.0f);
   [mapView addSubview:selectedPickImage];
}
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(selectedPickImage == nil) return;
    UITouch *anyTouch = [touches anyObject];
    CGPoint touchLocation = [anyTouch locationInView:mapView];
    selectedPickImage.center = touchLocation;
}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(selectedPickImage == nil) return;
    [selectedPickImage removeFromSuperview];
    selectedPickImage = nil;
    [pickButton setHidden:NO];
    UITouch *anyTouch = [touches anyObject];
    CGPoint touchLocation = [anyTouch locationInView:mapView];
    touchLocation.y += 39.0f/2.0f;
    CLLocationCoordinate2D loc = [mapView.projection coordinateForPoint:touchLocation];
    GMSMarker *marker;
    if(marker != nil){
        marker.map = nil;
        marker = nil;
    }
    marker= [GMSMarker markerWithPosition:loc];
    marker.map = mapView;
    marker.title = [NSString stringWithFormat:@"%d",index];
    [marker setDraggable:YES];
    index++;
    
    [pathArray addObject:marker];
    [pathTable reloadData];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for(GMSMarker *m in pathArray){
    
        NSString *positionString = [NSString stringWithFormat:@"%f,%f", m.position.latitude,m.position.longitude];
        [arr addObject:positionString];
    }
    
    if (arr.count > 1) {
        NSDictionary *query = @{ @"sensor" : @"false",
                                 @"waypoints" : arr };
        MDDirectionService *mds = [[MDDirectionService alloc] init];
        SEL selector = @selector(addDirections:);
        [mds setDirectionsQuery:query
                   withSelector:selector
                   withDelegate:self];
    }
}

-(void)addDirections:(NSDictionary *)json
{
    [mapView clear];
    for(GMSMarker *m in pathArray){
        m.map = mapView;
    }
    if(polyline != nil){
        polyline.map = nil;
    }
    NSDictionary *routes = json[@"routes"][0];
    NSDictionary *route = routes[@"overview_polyline"];
    NSString *overview_route = route[@"points"];
    GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
    polyline = [GMSPolyline polylineWithPath:path];
    polyline.map = mapView;
}
-(void) mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    
}
-(void) mapView:(GMSMapView *)mapView didEndDraggingMarker:(GMSMarker *)marker
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for(GMSMarker *m in pathArray){
        
        NSString *positionString = [NSString stringWithFormat:@"%f,%f", m.position.latitude,m.position.longitude];
        [arr addObject:positionString];
    }
    
    if (arr.count > 1) {
        NSDictionary *query = @{ @"sensor" : @"false",
                                 @"waypoints" : arr };
        MDDirectionService *mds = [[MDDirectionService alloc] init];
        SEL selector = @selector(addDirections:);
        [mds setDirectionsQuery:query
                   withSelector:selector
                   withDelegate:self];
    }
}
#pragma mark - UITableView Delegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(tableView == pathTable) return @"Path List";
    else if(tableView == searchTable) return @"Search Results";
    return @"";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == pathTable) return [pathArray count];
    else if(tableView == searchTable)return [searchArray count];
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if(tableView == searchTable){
    
     CLPlacemark *mark = [searchArray objectAtIndex:indexPath.row];
     cell.textLabel.text = mark.name;
     
    }else{
        GMSMarker *marker = [pathArray objectAtIndex:indexPath.row];
        cell.textLabel.text = marker.title;
    }
    return cell;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == searchTable){
        CLPlacemark *mark = [searchArray objectAtIndex:indexPath.row];
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:mark.location.coordinate.latitude longitude:mark.location.coordinate.longitude zoom:15];
        [mapView setCamera:camera];
    }else{
        
        GMSMarker *marker = [pathArray objectAtIndex:indexPath.row];
        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(marker.position.latitude, marker.position.longitude);
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:loc.latitude longitude:loc.longitude zoom:15];
        [mapView setCamera:camera];
        [mapView setSelectedMarker:marker];
        
        
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [pathArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationBottom];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for(GMSMarker *m in pathArray){
            
            NSString *positionString = [NSString stringWithFormat:@"%f,%f", m.position.latitude,m.position.longitude];
            [arr addObject:positionString];
        }
        [mapView clear];
        for(GMSMarker *m in pathArray){
            m.map = mapView;
        }
        if (arr.count > 1) {
            NSDictionary *query = @{ @"sensor" : @"false",
                                     @"waypoints" : arr };
            MDDirectionService *mds = [[MDDirectionService alloc] init];
            SEL selector = @selector(addDirections:);
            [mds setDirectionsQuery:query
                       withSelector:selector
                       withDelegate:self];
        }
    }
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
    
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath*)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    GMSMarker *temp = [pathArray objectAtIndex:sourceIndexPath.row];
    [pathArray setObject:[pathArray objectAtIndex:destinationIndexPath.row] atIndexedSubscript:sourceIndexPath.row];
    [pathArray setObject:temp atIndexedSubscript:destinationIndexPath.row];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for(GMSMarker *m in pathArray){
        
        NSString *positionString = [NSString stringWithFormat:@"%f,%f", m.position.latitude,m.position.longitude];
        [arr addObject:positionString];
    }
    if (arr.count > 1) {
        NSDictionary *query = @{ @"sensor" : @"false",
                                 @"waypoints" : arr };
        MDDirectionService *mds = [[MDDirectionService alloc] init];
        SEL selector = @selector(addDirections:);
        [mds setDirectionsQuery:query
                   withSelector:selector
                   withDelegate:self];
    }
    
}
#pragma mark - UITextField Delegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchbar
{
    [searchArray removeAllObjects];
    CLGeocoder *myGeocoder = [[CLGeocoder alloc]init];
    [myGeocoder geocodeAddressString:searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        for(CLPlacemark *mark in placemarks){
            [searchArray addObject:mark];
        }
        [searchTable reloadData];
    }];
    [searchbar resignFirstResponder];
}


-(void) saveBtnClicked:(id)sender
{
    if(titleField.text.length == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You should text title at least one letter!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }if([pathArray count]== 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You should add location at least one!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    saveObject[@"pathName"] = titleField.text;
    NSMutableArray *pathArr = [[NSMutableArray alloc] init];
    for(int i=0;i<[pathArray count];i++){
        GMSMarker *marker = [pathArray objectAtIndex:i];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:marker.title forKey:@"markerName"];
        [dic setObject:[NSNumber numberWithFloat:marker.position.latitude] forKey:@"latitude"];
        [dic setObject:[NSNumber numberWithFloat:marker.position.longitude] forKey:@"longitude"];
        [pathArr addObject:dic];
        
    }
    saveObject[@"pathArray"] = pathArr;
    if(polyline != nil){
        saveObject[@"GMSPath"] = polyline.path.encodedPath;
    }
    [saveObject saveInBackground];
    
    [self.navigationController popViewControllerAnimated:NO];
}
-(void) CancelBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
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
