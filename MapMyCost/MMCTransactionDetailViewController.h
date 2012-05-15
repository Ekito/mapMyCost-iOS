//
//  MMCTransactionDetailViewController.h
//  MapMyCost
//
//  Created by Mélanie Bessagnet on 15/05/12.
//  Copyright (c) 2012 Ekito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MMCImagePickerViewController.h"

@interface MMCTransactionDetailViewController : UIViewController <MKMapViewDelegate, MMCImagePickerViewControllerDelegate> {
    
}

@property (strong, nonatomic) NSString              *transactionId;
@property (strong, nonatomic) NSDictionary          *transaction;

@property (strong, nonatomic) IBOutlet UILabel      *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel      *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel      *amountLabel;
@property (strong, nonatomic) IBOutlet UIImageView  *imageView;
@property (strong, nonatomic) IBOutlet MKMapView    *mapView;
@property (strong, nonatomic) IBOutlet UIButton     *choosePhotoButton;

- (id)initWithTransactionId:(NSString *)_transactionId;
- (IBAction)choosePhoto:(id)sender;

@end