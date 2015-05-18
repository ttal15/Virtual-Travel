//
//  mainViewController.h
//  Virtual Travel
//
//  Created by Steve-Mac on 2014. 11. 28..
//  Copyright (c) 2014년 InciteStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "menuViewController.h"
#import "quickStartViewController.h"
#import "pathViewController.h"
//@class SWRevealViewController;

@interface mainViewController : SWRevealViewController<SWRevealViewControllerDelegate>
{
    UINavigationController *quickStartNav;
    UINavigationController *pathNav;
}
-(void) setFrontViewWithIndex:(int)index;
@end
