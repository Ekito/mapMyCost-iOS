//
//  MMCCameraViewController.h
//  MapMyCost
//
//  Created by Mélanie Bessagnet on 14/05/12.
//  Copyright (c) 2012 Ekito. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MMCCameraViewControllerDelegate;

@interface MMCCameraViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    UIImagePickerController *imagePickerController;
}

@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic, unsafe_unretained) id<MMCCameraViewControllerDelegate> delegate;

- (void)setupImagePickerController;
- (IBAction)takePhoto:(id)sender;
- (IBAction)transactions:(id)sender;

@end

@protocol MMCCameraViewControllerDelegate <NSObject>
- (void)getTransactions;
@end
