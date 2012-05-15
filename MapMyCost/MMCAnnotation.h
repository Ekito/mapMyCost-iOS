//
//  MMCAnnotation.h
//  MapMyCost
//
//  Created by Mélanie Bessagnet on 15/05/12.
//  Copyright (c) 2012 Ekito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MMCAnnotation : NSObject<MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *mTitle;
    NSString *mSubTitle;
}

- (id)initWithData:(NSDictionary *)_data;

@property (nonatomic, strong) NSDictionary *data;

@end
