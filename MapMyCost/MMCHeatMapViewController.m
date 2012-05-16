//
//  MMCHeatMapViewController.m
//  MapMyCost
//
//  Created by Mélanie Bessagnet on 16/05/12.
//  Copyright (c) 2012 Ekito. All rights reserved.
//

#import "MMCHeatMapViewController.h"
#import "MBProgressHUD.h"

@implementation MMCHeatMapViewController

@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Navigation bar
    self.title = @"Heat Map";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    self.navigationItem.leftBarButtonItem = button;
    
    [MBProgressHUD showHUDAddedTo:self.webView animated:YES];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/phonemap", BASE_URL]]]];
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

#pragma mark - UIWebViewDelegate methods
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.webView animated:YES];
}

#pragma mark - Action methods
- (void)close
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
