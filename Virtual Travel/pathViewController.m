//
//  pathViewController.m
//  Virtual Travel
//
//  Created by Steve-Mac on 2014. 11. 30..
//  Copyright (c) 2014년 InciteStudio. All rights reserved.
//

#import "pathViewController.h"
#import "MDDirectionService.h"


@interface pathViewController () <GMSMapViewDelegate>
@end


@implementation pathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SWRevealViewController *revealController = self.revealViewController;
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    [self.navigationItem setTitle:@"PathList"];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"] style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)]];
    // Do any additional setup after loading the view.
    
    pathListView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 220.0f, 320.0f)];
    pathListView.delegate = self;
    pathListView.dataSource = self;
//    [pathListView setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:pathListView];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:0.0f longitude:0.0f zoom:1];
    
    mapView = [GMSMapView mapWithFrame:CGRectMake(220.0f, 30.0f, 348.0f, 290.0f) camera:camera];
    [mapView setIndoorEnabled:NO];
    mapView.mapType = kGMSTypeNormal;
    mapView.delegate = self;
    [self.view addSubview:mapView];
}
-(void) viewWillAppear:(BOOL)animated
{
    PFQuery *query = [PFQuery queryWithClassName:@"PathList"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            pathList = [[NSMutableArray alloc] initWithArray:objects];
            [pathListView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
-(void) editBtnClicked:(id)sender
{
    pathInfoViewController *vc = [[pathInfoViewController alloc] init];
    [vc setSaveObject:[pathList objectAtIndex:[sender tag]]];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void) goBtnClicked:(id)sender
{
    streetViewController *street = [[streetViewController alloc] init];
    PFObject *obj = [pathList objectAtIndex:[sender tag]];
    GMSPath *path = [GMSPath pathFromEncodedPath:obj[@"GMSPath"]];
    NSMutableArray *arr = [[pathList objectAtIndex:[sender tag]] objectForKey:@"pathArray"];
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([[[arr objectAtIndex:0] objectForKey:@"latitude"] floatValue], [[[arr objectAtIndex:0] objectForKey:@"longitude"] floatValue]);
    [street setStartCoord:loc];
    [street setPath:path];
    [self.navigationController pushViewController:street animated:YES];
}
#pragma mark - UITableView Delegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [pathList count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if(indexPath.row == 0){ cell.textLabel.text = @"ADD PATH";
    }else{
        PFObject *obj = [pathList objectAtIndex:indexPath.row-1];
        cell.textLabel.text =obj[@"pathName"];
        
        UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        editBtn.tag = indexPath.row-1;
        [editBtn setFrame:CGRectMake(160.0f, 2.5f, 50.0f, 20.0f)];
        [editBtn setTitle:@"Edit" forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:editBtn];
        
        UIButton *goBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        goBtn.tag = indexPath.row-1;
        [goBtn setFrame:CGRectMake(160.0f, 22.5f, 50.0f, 20.0f)];
        [goBtn setTitle:@"Go" forState:UIControlStateNormal];
        [goBtn addTarget:self action:@selector(goBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:goBtn];
        
    }
    
    return cell;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        pathInfoViewController *vc = [[pathInfoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
    }else{
        
        PFObject *obj = [pathList objectAtIndex:indexPath.row - 1];
        NSArray *pathArr = obj[@"pathArray"];
        [mapView clear];
        for(int i=0;i<[pathArr count];i++){
            
            NSMutableDictionary *dic = [pathArr objectAtIndex:i];
            CLLocationCoordinate2D loc;
            loc.latitude = [[dic objectForKey:@"latitude"] floatValue];
            loc.longitude = [[dic objectForKey:@"longitude" ] floatValue];
            GMSMarker *marker = [GMSMarker markerWithPosition:loc];
            marker.title = [dic objectForKey:@"markerName"];
            marker.map = mapView;
            [mapView setCamera:[GMSCameraPosition cameraWithLatitude:loc.latitude longitude:loc.longitude zoom:12.0f]];
        }
        GMSPath *path = [GMSPath pathFromEncodedPath:obj[@"GMSPath"]];
        GMSPolyline *p_line = [GMSPolyline polylineWithPath:path];
        p_line.map = mapView;
        
        
    }
}


#pragma mark - GMSMapViewDelegate
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
