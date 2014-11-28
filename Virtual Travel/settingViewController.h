//
//  settingViewController.h
//  VitualTravel
//
//  Created by Steve-Mac on 2014. 11. 26..
//  Copyright (c) 2014년 InciteStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "streetViewController.h"
#import "GoogleDataManager.h"
@interface settingViewController : UIViewController
{
    GMSMapView *mapView;
}
-(void) startBtnClicked:(id)sender;
@end






    