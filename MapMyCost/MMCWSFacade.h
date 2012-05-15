//
//  MMCWSFacade.h
//  MapMyCost
//
//  Created by Mélanie Bessagnet on 15/05/12.
//  Copyright (c) 2012 Ekito. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMCWSFacade : NSObject {
}

+ (MMCWSFacade *) sharedMMCWSFacade;
- (void)getTransactionsWithBlock:(void (^)(NSArray *_transactions))block;
- (void)getDetailsForTransaction:(NSString *)transactionId withBlock:(void (^)(NSDictionary *_transaction))block;

@end
