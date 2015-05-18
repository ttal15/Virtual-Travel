//
//  pathViewController.h
//  Virtual Travel
//
//  Created by Steve-Mac on 2014. 11. 30..
//  Copyright (c) 2014년 InciteStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "pathInfoViewController.h"
#import "streetViewController.h"
@interface pathViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    GMSMapView *mapView;
    UITableView *pathListView;
    NSMutableArray *pathList;
    
}
-(void) editBtnClicked:(id)sender;
-(void) goBtnClicked:(id)sender;
@end
