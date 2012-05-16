//
//  MMCTransactionsViewController.m
//  MapMyCost
//
//  Created by Mélanie Bessagnet on 14/05/12.
//  Copyright (c) 2012 Ekito. All rights reserved.
//

#import "MMCTransactionsViewController.h"
#import "MMCTransactionsViewCell.h"
#import "MMCTransactionDetailViewController.h"
#import "MBProgressHUD.h"
#import "MMCAppDelegate.h"
#import "SVPullToRefresh.h"

@implementation MMCTransactionsViewController

@synthesize tableView;
@synthesize transactions;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)reload:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    [[MMCWSFacade sharedMMCWSFacade] getTransactionsWithBlock:^(NSArray *_transactions) {
        if (_transactions) {
            self.transactions = _transactions;
            [self.tableView reloadData];
        }
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        tableView.pullToRefreshView.lastUpdatedDate = [NSDate date];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Navigation bar
    self.title = @"Transactions";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"take_photo.png"] style:UIBarButtonItemStylePlain target:self action:@selector(photoAction)];
    self.navigationItem.rightBarButtonItem = button;
    
    // Add pullToRefresh to tableView
    [tableView addPullToRefreshWithActionHandler:^{
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        [[MMCWSFacade sharedMMCWSFacade] getTransactionsWithBlock:^(NSArray *_transactions) {
            if (_transactions) {
                self.transactions = _transactions;
                [self.tableView reloadData];
            }
            
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            tableView.pullToRefreshView.lastUpdatedDate = [NSDate date];
        }];
        
        [tableView.pullToRefreshView stopAnimating];
    }];
    
    [self reload:nil];
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

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section
{
    return [transactions count];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyCellIdent";
    
    MMCTransactionsViewCell *cell = (MMCTransactionsViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // On initialise un ViewController à partir du Nib qui a été fait
        UIViewController *c = [[UIViewController alloc] initWithNibName:@"MMCTransactionsViewCell"  bundle:nil];
        cell = (MMCTransactionsViewCell *)c.view;
    }
    
    // Configure cell
    cell.title.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    cell.date.font = [UIFont fontWithName:@"ArialMT" size:14.0];
    cell.amount.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    
    NSDictionary *transaction = [transactions objectAtIndex:indexPath.row];
    cell.title.text = [transaction objectForKey:@"title"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *frLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];
    [dateFormatter setLocale:frLocale];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    // Timestamp in milliseconds
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:([[transaction objectForKey:@"date"] doubleValue] / 1000.0)];
    cell.date.text = [dateFormatter stringFromDate:date];
    
    cell.amount.text = [NSString stringWithFormat:@"%@ €", [transaction objectForKey:@"amount"]];
    
    cell.bgView.image = [[transaction objectForKey:@"mapped"] boolValue] ? nil : [UIImage imageNamed:@"highlighted.png"];
    
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.429 green:0.750 blue:0.963 alpha:1.0];
    cell.selectedBackgroundView = selectedBackgroundView;
    
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Transaction details
    MMCTransactionDetailViewController *nextViewController = [[MMCTransactionDetailViewController alloc] initWithTransactionId:[[transactions objectAtIndex:indexPath.row] objectForKey:@"id"]];
    [self.navigationController pushViewController:nextViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Action methods
- (void)photoAction
{
    [(MMCAppDelegate *)[[UIApplication sharedApplication] delegate] takePhoto];
}

@end
