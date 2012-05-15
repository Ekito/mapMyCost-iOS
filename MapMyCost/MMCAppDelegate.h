//
//  MMCAppDelegate.h
//  MapMyCost
//
//  Created by Mélanie Bessagnet on 14/05/12.
//  Copyright (c) 2012 Ekito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMCCameraViewController.h"

@interface MMCAppDelegate : NSObject <UIApplicationDelegate, MMCCameraViewControllerDelegate>

@property (nonatomic, retain) IBOutlet UIWindow                             *window;
@property (nonatomic, retain) MMCCameraViewController                       *pickerController;

- (void)takePhoto;

@end
