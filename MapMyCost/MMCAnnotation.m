//
//  MMCAnnotation.m
//  MapMyCost
//
//  Created by Mélanie Bessagnet on 15/05/12.
//  Copyright (c) 2012 Ekito. All rights reserved.
//

#import "MMCAnnotation.h"
#import <CoreLocation/CoreLocation.h>

@implementation MMCAnnotation

@synthesize coordinate;
@synthesize data;

- (NSString *)subtitle{
    return @"";
}

- (NSString *)title{
    return [data objectForKey:@"title"];
}

- (id)initWithData:(NSDictionary *)_data {
    data = _data;
    coordinate = CLLocationCoordinate2DMake([[data objectForKey:@"latitude"] doubleValue], [[data objectForKey:@"longitude"] doubleValue]);

    return self;
}

@end
