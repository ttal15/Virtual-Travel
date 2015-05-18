//
//  menuViewController.h
//  Virtual Travel
//
//  Created by Steve-Mac on 2014. 11. 28..
//  Copyright (c) 2014년 InciteStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import <KakaoOpenSDK/KakaoOpenSDK.h>
#import "mainViewController.h"
@interface menuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *menuArray;
    UITableView *menuTable;
    id mainVC;
    
}
@property (nonatomic,strong) id mainVC;
-(void) invokeLoginWithTarget;

@end
