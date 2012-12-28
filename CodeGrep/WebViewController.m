//
//  WebViewController.m
//  CodeGrep
//
//  Created by Bo Yu on 12/27/12.
//  Copyright (c) 2012 Bo Yu. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic) NSURL * url;
@property(nonatomic) NSURLRequest * request;

@end

@implementation WebViewController

@synthesize webView;
@synthesize url;
@synthesize request;

-(void) initWithUrlString:(NSString *)urlString
{
    self.url = [NSURL URLWithString:urlString];
    self.request = [NSURLRequest requestWithURL:self.url];
}

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
	// Do any additional setup after loading the view.
    [self.webView loadRequest:self.request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
