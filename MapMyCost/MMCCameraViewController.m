//
//  MMCCameraViewController.m
//  MapMyCost
//
//  Created by Mélanie Bessagnet on 14/05/12.
//  Copyright (c) 2012 Ekito. All rights reserved.
//

#import "MMCCameraViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation MMCCameraViewController

@synthesize imagePickerController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
#if TARGET_IPHONE_SIMULATOR
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#elif TARGET_OS_IPHONE
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
#endif
        imagePickerController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    NSLog(@"Got a memory warning");
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setupImagePickerController
{
    imagePickerController.showsCameraControls = NO;
    
    if (imagePickerController.cameraOverlayView != self.view) {
        CGRect newFrame = CGRectMake(0.0, 0.0, 320.0, 480.0);
        self.view.frame = newFrame;
        imagePickerController.cameraOverlayView = self.view;
    }   
}

- (IBAction)takePhoto:(id)sender {
    [imagePickerController takePicture];
}

#pragma mark - UIImagePickerControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];  
    // Request to save the image to camera roll  
    [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){  
        if (error) {  
            NSLog(@"error");  
        } else {  
            NSLog(@"url %@", assetURL);  
        }  
    }];  
}

@end
