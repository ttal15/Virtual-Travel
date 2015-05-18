//
//  quickStartViewController.h
//  Virtual Travel
//
//  Created by Steve-Mac on 2014. 11. 28..
//  Copyright (c) 2014년 InciteStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "streetViewController.h"
#import "SWRevealViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface quickStartViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    GMSMapView *mapView;
    UITableView *searchListView;
    UISearchBar *placeSearchBar;
    NSMutableArray *resultArray;
    GMSMarker *marker;
}
-(void) hideKeyboard;
-(void) startBtnClicked:(id)sender;
@end