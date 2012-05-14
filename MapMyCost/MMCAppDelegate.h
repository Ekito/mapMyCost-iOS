//
//  MMCAppDelegate.h
//  MapMyCost
//
//  Created by Mélanie Bessagnet on 14/05/12.
//  Copyright (c) 2012 Ekito. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMCCameraViewController;

@interface MMCAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow                             *window;
@property (nonatomic, retain) UIViewController                              *rootController;
@property (nonatomic, retain) MMCCameraViewController                       *pickerController;

@end
