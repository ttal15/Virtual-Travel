//
//  GoogleDataManager.m
//  Virtual Travel
//
//  Created by Steve-Mac on 2014. 11. 28..
//  Copyright (c) 2014년 InciteStudio. All rights reserved.
//

#import "GoogleDataManager.h"

@implementation GoogleDataManager
+ (GoogleDataManager *) sharedManager{
    static GoogleDataManager *instance = nil;
    if(instance == nil){
        instance = [[GoogleDataManager alloc] init];
    }
    return instance;
}

-(NSMutableArray *) getSearchPlaceData:(NSString *) place
{
    CLGeocoder *myGeocoder = [[CLGeocoder alloc]init];
    [myGeocoder geocodeAddressString:place completionHandler:^(NSArray *placemarks, NSError *error) {
        for(CLPlacemark *mark in placemarks){
            NSLog(@"%@",mark.name);
        }
    }];
    
    return nil;
}
@end
