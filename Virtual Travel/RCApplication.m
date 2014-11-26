//
//  RCApplication.m
//  RemoteControl
//
//  Created by Moshe Berman on 10/1/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "RCApplication.h"

@implementation RCApplication
- (BOOL)canBecomeFirstResponder
{
    return YES;
}


- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            break;
        case UIEventSubtypeRemoteControlPause:
            break;
        case UIEventSubtypeRemoteControlStop:
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            break;
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"move" object:nil];
}

- (void)postNotificationWithName:(NSString *)name
{

}


@end
