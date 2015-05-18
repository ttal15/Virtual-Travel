//
//  GoogleDataManager.h
//  Virtual Travel
//
//  Created by Steve-Mac on 2014. 11. 28..
//  Copyright (c) 2014년 InciteStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface GoogleDataManager : NSObject
{
}
+ (GoogleDataManager *) sharedManager;
-(NSMutableArray *) getSearchPlaceData:(NSString *) place;
@end
