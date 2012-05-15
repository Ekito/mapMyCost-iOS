//
//  MMCTransactionsViewController.h
//  MapMyCost
//
//  Created by Mélanie Bessagnet on 14/05/12.
//  Copyright (c) 2012 Ekito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMCTransactionsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *transactions;

@end
