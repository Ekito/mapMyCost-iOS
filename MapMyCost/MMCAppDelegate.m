//
//  MMCAppDelegate.m
//  MapMyCost
//
//  Created by Mélanie Bessagnet on 14/05/12.
//  Copyright (c) 2012 Ekito. All rights reserved.
//

#import "MMCAppDelegate.h"
#import "MMCTransactionsViewController.h"
#import "MMCWSFacade.h"
#import "MBProgressHUD.h"

@implementation MMCAppDelegate

@synthesize window = _window;
@synthesize pickerController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIViewController *controller = [[UIViewController alloc] init];
    self.window.rootViewController = controller;
    
    pickerController = [[MMCCameraViewController alloc] initWithNibName:@"MMCCameraViewController" bundle:nil];
    pickerController.delegate = self;
    [pickerController setupImagePickerController];
    if ([self.window.rootViewController respondsToSelector:@selector(presentViewController:animated:completion:)]) {
        [self.window.rootViewController presentViewController:pickerController.imagePickerController animated:YES completion:nil];
    } else {
        [self.window.rootViewController presentModalViewController:pickerController.imagePickerController animated:YES];
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark - Private methods
- (void)takePhoto
{
    UIViewController *controller = [[UIViewController alloc] init];
    self.window.rootViewController = controller;
    
    if ([self.window.rootViewController respondsToSelector:@selector(presentViewController:animated:completion:)]) {
        [self.window.rootViewController presentViewController:pickerController.imagePickerController animated:YES completion:nil];
    } else {
        [self.window.rootViewController presentModalViewController:pickerController.imagePickerController animated:YES];
    }
}

#pragma mark - MMCCameraViewControllerDelegate methods
- (void)getTransactions
{
    if ([self.window.rootViewController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.window.rootViewController dismissModalViewControllerAnimated:YES];
    }
    
    MMCTransactionsViewController *viewController = [[MMCTransactionsViewController alloc] initWithNibName:@"MMCTransactionsViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.window.rootViewController = navigationController;
}

@end
