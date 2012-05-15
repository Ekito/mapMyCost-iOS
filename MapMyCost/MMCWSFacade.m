//
//  MMCWSFacade.m
//  MapMyCost
//
//  Created by Mélanie Bessagnet on 15/05/12.
//  Copyright (c) 2012 Ekito. All rights reserved.
//

#import "MMCWSFacade.h"
#import "AFJSONRequestOperation.h"

NSInteger compareTransactionsByDate (id tr1, id tr2, void* context)
{
    NSDictionary *transaction1 = (NSDictionary *)tr1;
    NSDictionary *transaction2 = (NSDictionary *)tr2;
    
    BOOL transaction1IsMapped = [[transaction1 objectForKey:@"mapped"] boolValue];
    BOOL transaction2IsMapped = [[transaction2 objectForKey:@"mapped"] boolValue];
    
    if ((transaction1IsMapped && transaction2IsMapped) || (!transaction1IsMapped && !transaction2IsMapped)) {
        // Compare dates
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *frLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];
        [dateFormatter setLocale:frLocale];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        
        NSDate *transactionDate1 = [[NSDate alloc] initWithTimeIntervalSince1970:([[transaction1 objectForKey:@"date"] doubleValue] / 1000.0)];
        NSDate *transactionDate2 = [[NSDate alloc] initWithTimeIntervalSince1970:([[transaction2 objectForKey:@"date"] doubleValue] / 1000.0)];
        
        return [transactionDate1 compare:transactionDate2];
    } else if (transaction1IsMapped) {
        return NSOrderedDescending;
    } else if (transaction2IsMapped) {
        return NSOrderedAscending;
    }
}

@implementation MMCWSFacade

+ (id) sharedMMCWSFacade {
    
    static MMCWSFacade *_sharedObject = nil;
    
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        _sharedObject = [[MMCWSFacade alloc] init];
    });
    
    return _sharedObject;
}

- (id)init {
    self = [super init];
	if(self) {
        
    }
    return self;
}

- (void)getTransactionsWithBlock:(void (^)(NSArray *_transactions))block 
{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:[[BASE_URL stringByAppendingFormat:@"/transactions"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"JSON: %@", JSON);
        if ([JSON isKindOfClass:[NSArray class]]) {
            [results addObjectsFromArray:[JSON sortedArrayUsingFunction:compareTransactionsByDate context:NULL]];
        }
        if (block) {
            block([NSArray arrayWithArray:results]);
        }
    } failure:nil];
    
    [operation start];    
}

- (void)getDetailsForTransaction:(NSString *)transactionId withBlock:(void (^)(NSDictionary *_transaction))block
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    NSURL *url = [NSURL URLWithString:[[BASE_URL stringByAppendingFormat:@"/transactions/%@", transactionId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"url %@", [url absoluteString]);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"JSON: %@", JSON);
        if ([JSON isKindOfClass:[NSDictionary class]]) {
            [result addEntriesFromDictionary:JSON];
        }
        if (block) {
            block([NSDictionary dictionaryWithDictionary:result]);
        }
    } failure:nil];
    
    [operation start];  
}

@end
