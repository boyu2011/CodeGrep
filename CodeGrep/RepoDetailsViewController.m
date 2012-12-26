//
//  RepoDetailsViewController.m
//  CodeGrep
//
//  Created by Bo Yu on 12/25/12.
//  Copyright (c) 2012 Bo Yu. All rights reserved.
//

#import "RepoDetailsViewController.h"
#import "JSONKit/JSONKit.h"

@interface RepoDetailsViewController ()

@property(weak, nonatomic) NSString * ownerAndRepo;
@property(strong, nonatomic) NSString * readmeContent;
@property(weak, nonatomic) NSString * watchersAndForks;

@end

@implementation RepoDetailsViewController

@synthesize readmeTextView;
@synthesize readmeContent;
@synthesize ownerAndRepo;
@synthesize watchersAndForks;

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
    // get readme path
    //
    // template:
    // $ curl https://api.github.com/repos/boyu2011/iCode/readme
    //
    
    NSMutableString *theUrlString =
    [NSString stringWithFormat:@"https://api.github.com/repos/%@/readme", ownerAndRepoName];
    NSURL *url = [NSURL URLWithString:theUrlString];
    NSMutableData *data = [NSData dataWithContentsOfURL:url];
    JSONDecoder * jsonDecoder = [[JSONDecoder alloc]initWithParseOptions:JKParseOptionNone];
    NSDictionary * readme = [jsonDecoder objectWithData:data];
    NSString * readmePath = [readme valueForKey:@"path"];
    
    //
    // get readme raw data
    //
    // templage:
    // $ curl https://raw.github.com/ajaxorg/cloud9/master/README.md
    //
    
    theUrlString = [NSString stringWithFormat:@"https://raw.github.com/%@/master/%@",
                    ownerAndRepoName, readmePath];
    url = [NSURL URLWithString:theUrlString];
    data = [NSData dataWithContentsOfURL:url];
    NSString * r = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
    
    // assign content to a var for display later.
    self.readmeContent = r;
    //NSLog(self.readmeContent);
    self.ownerAndRepo = ownerAndRepoName;
    
    //
    // get repo details info
    //
    
    theUrlString = [NSString stringWithFormat:@"https://api.github.com/repos/%@", ownerAndRepo];
    url = [NSURL URLWithString:theUrlString];
    data = [NSData dataWithContentsOfURL:url];
    NSDictionary * repo = [jsonDecoder objectWithData:data];
    self.watchersAndForks = [NSString stringWithFormat:@"Watchers: %@    Forks: %@",
                             [repo valueForKey:@"watchers"],
                             [repo valueForKey:@"forks"]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue.identifier isEqualToString:@"showRepoOnWeb"] )
    {
        [segue.destinationViewController initWithOwnerAndRepoName:self.ownerAndRepo];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //
    // show repo details on the screen
    //
    
    NSString * summaryString = [NSString stringWithFormat:@"%@\n%@\n\n%@",
                                self.ownerAndRepo,
                                self.watchersAndForks,
                                self.readmeContent];
    
    [self.readmeTextView setText:summaryString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
