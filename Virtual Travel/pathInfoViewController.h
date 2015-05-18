//
//  pathInfoViewController.h
//  Virtual Travel
//
//  Created by Steve-Mac on 2014. 11. 30..
//  Copyright (c) 2014년 InciteStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
@interface pathInfoViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,GMSMapViewDelegate>
{
    UITableView *searchTable;
    UISearchBar *searchBar;
    UITableView *pathTable;
    NSMutableArray *searchArray;
    NSMutableArray *pathArray;
    GMSMapView *mapView;
    UIButton *pickButton;
    
    UIImageView *selectedPickImage;
    GMSPolyline *polyline;
    UIBarButtonItem *editButton;
    UITextField *titleField;
    PFObject *saveObject;
    int index;
}
-(void) setSaveObject:(PFObject *) obj;
-(void) editPath:(id)sender;
-(void) addDirections:(NSDictionary *)json;
-(void) saveBtnClicked:(id)sender;
-(void) CancelBtnClicked:(id)sender;
-(void) pickButtonClicked:(id)sender;
@end
