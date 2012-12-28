//
//  RepoWebViewController.m
//  CodeGrep
//
//  Created by Bo Yu on 12/25/12.
//  Copyright (c) 2012 Bo Yu. All rights reserved.
//

#import "RepoWebViewController.h"
#import "DEFINE.h"

@interface RepoWebViewController ()

@property(nonatomic, retain) NSString * repoFullName;
@property(nonatomic, retain) NSURL * url;
@property(nonatomic, retain) NSURLRequest * request;

@end

@implementation RepoWebViewController

@synthesize repoWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initWithOwnerAndRepoName:(NSString *)ownerAndRepoName
{
    //
    // construct a request for browsering.
    //
    
    NSString * repoURLString = [NSString stringWithFormat:@"https://github.com/%@%@", ownerAndRepoName, UNAUTH_CALL_HIGHER_RATE];
    self.url = [NSURL URLWithString:repoURLString];
    self.request = [NSURLRequest requestWithURL:self.url];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.repoWebView loadRequest:self.request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
