//
//  MMCTransactionsViewCell.h
//  MapMyCost
//
//  Created by Mélanie Bessagnet on 14/05/12.
//  Copyright (c) 2012 Ekito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMCTransactionsViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView   *bgView;
@property (strong, nonatomic) IBOutlet UILabel  *title;
@property (strong, nonatomic) IBOutlet UILabel  *date;
@property (strong, nonatomic) IBOutlet UILabel  *amount;

@end
