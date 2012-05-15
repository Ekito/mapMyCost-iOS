//
//  MMCImagePickerViewController.h
//  MapMyCost
//
//  Created by Mélanie Bessagnet on 15/05/12.
//  Copyright (c) 2012 Ekito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol MMCImagePickerViewControllerDelegate;

@interface MMCImagePickerViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource> {
    
}

@property (strong, nonatomic) NSDictionary          *transaction;
@property (strong, nonatomic) IBOutlet UITableView  *tableView;
@property (strong, nonatomic) NSMutableArray        *assets;
@property (strong, nonatomic) ALAssetsLibrary       *library;

@property (unsafe_unretained, nonatomic) id<MMCImagePickerViewControllerDelegate> delegate;

- (id)initWithData:(NSDictionary *)_data;

@end

@protocol MMCImagePickerViewControllerDelegate
- (void)sendPhotoCallback;
@end