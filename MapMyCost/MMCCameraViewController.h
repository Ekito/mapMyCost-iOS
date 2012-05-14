//
//  MMCCameraViewController.h
//  MapMyCost
//
//  Created by Mélanie Bessagnet on 14/05/12.
//  Copyright (c) 2012 Ekito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMCCameraViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    UIImagePickerController *imagePickerController;
}

@property (nonatomic, retain) UIImagePickerController *imagePickerController;

- (void)setupImagePickerController;
- (IBAction)takePhoto:(id)sender;

@end
