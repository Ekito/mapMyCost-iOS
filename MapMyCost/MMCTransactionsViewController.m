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
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Transactions";
    
    // Bouton photo
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"button_arrow.png"] forState:UIControlStateNormal];
    button.frame=CGRectMake(0.0, 50.0, 35.0, 30.0);
    [button addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    
    // Placement du bouton dans la barre de navigation
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
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
    
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:([[transaction objectForKey:@"date"] doubleValue] / 1000.0)];
    cell.date.text = [dateFormatter stringFromDate:date];
    
    cell.amount.text = [NSString stringWithFormat:@"%@ €", [transaction objectForKey:@"amount"]];
    
    cell.bgView.backgroundColor = [[transaction objectForKey:@"mapped"] boolValue] ? [UIColor whiteColor] : [UIColor colorWithRed:0.298 green:0.718 blue:0.851 alpha:1.000];
    
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
