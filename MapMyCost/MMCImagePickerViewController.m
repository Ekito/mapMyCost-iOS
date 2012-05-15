//
//  MMCImagePickerViewController.m
//  MapMyCost
//
//  Created by Mélanie Bessagnet on 15/05/12.
//  Copyright (c) 2012 Ekito. All rights reserved.
//

#import "MMCImagePickerViewController.h"
#import "MBProgressHUD.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import <CoreLocation/CoreLocation.h>

@implementation MMCImagePickerViewController

@synthesize tableView;
@synthesize assets;
@synthesize transaction;
@synthesize library;
@synthesize delegate;

- (id)initWithData:(NSDictionary *)_data
{
    self = [super init];
    if (self) {
        transaction = _data;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (NSDate*) dateWithNoTime:(NSDate *)date {
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:flags fromDate:date];
    NSDate* dateOnly = [calendar dateFromComponents:components];
    return dateOnly;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    assets = [[NSMutableArray alloc] init];  
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *frLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];
    [dateFormatter setLocale:frLocale];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    NSDate *transactionDate = [[NSDate alloc] initWithTimeIntervalSince1970:([[transaction objectForKey:@"date"] doubleValue] / 1000.0)];
    NSDate *transactionDateWithNoTime = [self dateWithNoTime:transactionDate];
    NSLog(@"transactionDateWithNoTime %@", [transactionDateWithNoTime description]);
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    ALAssetsGroupEnumerationResultsBlock assetEnumerator = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result != NULL) {
            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                NSDate *photoDateWithNoTime = [self dateWithNoTime:[result valueForProperty:ALAssetPropertyDate]];
                if ([transactionDateWithNoTime compare:photoDateWithNoTime] == NSOrderedSame) {
                    [assets addObject:result];
                }
            }
        }
    };
    
    ALAssetsLibraryGroupsEnumerationResultsBlock assetGroupEnumerator = ^(ALAssetsGroup *group, BOOL *stop) {
        if(group != nil) {
            [group enumerateAssetsUsingBlock:assetEnumerator];
        }
        
        [self.tableView reloadData];
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    };
    
    library = [[ALAssetsLibrary alloc] init];
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
     
                           usingBlock:assetGroupEnumerator
     
                         failureBlock: ^(NSError *error) {
                             
                             NSLog(@"Failure");
                             
                         }];
    
}

#pragma mark UITableViewDataSource Methods

// Customize the number of rows in the table view.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [assets count];
    
}

// Customize the number of sections in the table view.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

// Customize the appearance of table view cells.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"id";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    
    
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
        
    ALAssetRepresentation *representation = [[assets objectAtIndex:indexPath.row] defaultRepresentation];
    NSURL *url = [representation url];
    
    [[cell imageView] setImage:[UIImage imageWithCGImage:[representation fullResolutionImage]]];
    [[cell textLabel] setText:[NSString stringWithFormat:@"Photo %d", indexPath.row+1]];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = [assets objectAtIndex:indexPath.row];
    
    NSURL *url = [NSURL URLWithString:BASE_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    CLLocation* location = [asset valueForProperty:ALAssetPropertyLocation];
    CLLocationCoordinate2D coord = [location coordinate];
    NSLog(@"%@ %f %f", location, coord.latitude, coord.longitude);
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:[transaction objectForKey:@"id"], @"id", [NSNumber numberWithFloat:coord.latitude], @"latitude", [NSNumber numberWithFloat:coord.longitude], @"longitude", nil];
    NSLog(@"parameters %@", parameters);
    
    ALAssetRepresentation *representation = [asset defaultRepresentation];
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageWithCGImage:[representation fullResolutionImage]], 0.5);
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"PUT" path:@"/transactions/mapping" parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:imageData name:@"picture" fileName:@"picture.jpg" mimeType:@"image/jpeg"];
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success");
        if (delegate) {
            [self.delegate sendPhotoCallback];
        }
    }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"error %@", [error localizedDescription]); 
                                     }];
    [operation start];
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
