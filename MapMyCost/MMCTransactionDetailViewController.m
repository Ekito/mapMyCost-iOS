//
//  MMCTransactionDetailViewController.m
//  MapMyCost
//
//  Created by Mélanie Bessagnet on 15/05/12.
//  Copyright (c) 2012 Ekito. All rights reserved.
//

#import "MMCTransactionDetailViewController.h"
#import "MBProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "MMCAnnotation.h"
#import "MMCAppDelegate.h"
#import "MMCHeatMapViewController.h"

@implementation MMCTransactionDetailViewController

@synthesize transactionId;
@synthesize transaction;
@synthesize titleLabel, dateLabel, amountLabel;
@synthesize imageView, mapView;
@synthesize choosePhotoButton;

- (id)initWithTransactionId:(NSString *)_transactionId;
{
    self = [super initWithNibName:@"MMCTransactionDetailViewController" bundle:nil];
    if (self) {
        transactionId = _transactionId;
    }
    return self;
}

- (void)load:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    [[MMCWSFacade sharedMMCWSFacade] getDetailsForTransaction:transactionId withBlock:^(NSDictionary *_transaction) {
        if (_transaction) {
            transaction = _transaction;
            
            // Update view with transaction details
            self.titleLabel.text = [_transaction objectForKey:@"title"];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            NSLocale *frLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];
            [dateFormatter setLocale:frLocale];
            [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
            [dateFormatter setDateFormat:@"dd/MM/yyyy"];
            
            NSDate *transactionDate = [[NSDate alloc] initWithTimeIntervalSince1970:([[_transaction objectForKey:@"date"] doubleValue] / 1000.0)];
            self.dateLabel.text = [dateFormatter stringFromDate:transactionDate];
            
            self.amountLabel.text = [NSString stringWithFormat:@"%@ €", [_transaction objectForKey:@"amount"]];
            
            // Image
            if ([[_transaction objectForKey:@"mapped"] boolValue]) {
                self.choosePhotoButton.hidden = YES;
                self.imageView.hidden = NO;
                
                NSString *imageURLString = [NSString stringWithFormat:@"%@%@", BASE_URL, [_transaction objectForKey:@"picture"]];
                [self.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageURLString]] 
                                      placeholderImage:[UIImage imageNamed:@"placeholder.png"] 
                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                   NSLog(@"success");
                                               }
                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                   NSLog(@"error %@", error.description);
                                                   self.imageView.hidden = YES;
                                               }];
            } else {
                self.choosePhotoButton.hidden = NO;
                self.imageView.hidden = YES;
            }
            
            // MapView
            if ([[_transaction objectForKey:@"latitude"] doubleValue] != 0.0 && [[_transaction objectForKey:@"longitude"] doubleValue] != 0.0) {
                self.mapView.hidden = NO;
                
                MMCAnnotation *annotation = [[MMCAnnotation alloc] initWithData:_transaction];
                
                MKCoordinateRegion region;
                MKCoordinateSpan span;
                span.latitudeDelta = 0.005;
                span.longitudeDelta = 0.005;
                region.span = span;
                region.center = annotation.coordinate;
                [mapView addAnnotation:annotation];
                [mapView setRegion:region animated:TRUE];
                [mapView regionThatFits:region];
                
                CGRect mapViewFrame = self.imageView.frame;
                mapViewFrame.origin.y = CGRectGetMaxY(mapViewFrame) + 30.0;
                self.mapView.frame = mapViewFrame;
            } else {
                self.mapView.hidden = YES;
            }
            
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        } 
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Navigation bar
    self.title = @"Details";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 110, 44.01)];
    toolbar.tintColor = [UIColor blackColor];
    toolbar.opaque = NO;
    toolbar.backgroundColor = [UIColor clearColor];
    toolbar.clearsContextBeforeDrawing = YES;  
    
    // Array stockant les boutons
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
    UIBarButtonItem *heatMapButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"heatMap.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(heatMapAction)];
    [buttons addObject:heatMapButton];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [buttons addObject:spacer];
    UIBarButtonItem *photoButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"take_photo.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(photoAction)];
    [buttons addObject:photoButton];
    
    [toolbar setItems:buttons animated:NO];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
    
    [self load:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Action methods
- (void)photoAction
{
    [(MMCAppDelegate *)[[UIApplication sharedApplication] delegate] takePhoto];
}

- (void)heatMapAction
{
    MMCHeatMapViewController *heapMapViewController = [[MMCHeatMapViewController alloc] initWithNibName:@"MMCHeatMapViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:heapMapViewController];
    [self presentModalViewController:navController animated:YES];
}

- (IBAction)choosePhoto:(id)sender
{
    // Pick a photo to map with transaction
    MMCImagePickerViewController *imagePicker = [[MMCImagePickerViewController alloc] initWithData:transaction];
    imagePicker.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:imagePicker];
    [self presentModalViewController:navController animated:YES];
}

#pragma mark - MMCImagePickerViewControllerDelegate
- (void)sendPhotoCallback
{
    // Reload content view after photo upload
    [self load:nil];
}

@end
