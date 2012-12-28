//
//  RepoDetailsViewController.m
//  CodeGrep
//
//  Created by Bo Yu on 12/25/12.
//  Copyright (c) 2012 Bo Yu. All rights reserved.
//

#import "RepoDetailsViewController.h"
#import "JSONKit/JSONKit.h"
#import "UserProfileViewController.h"

@interface RepoDetailsViewController ()

@property(strong, nonatomic) NSString * ownerAndRepo;
@property(strong, nonatomic) NSString * readmeContent;
@property(strong, nonatomic) NSString * watchersAndForks;
@property(strong, nonatomic) NSString * desc;
@property(retain, nonatomic) NSString * owner;

@property (weak, nonatomic) IBOutlet UILabel *repoInfoLabel;

@property (weak, nonatomic) IBOutlet UIButton *ownerInfoBtn;

@end

@implementation RepoDetailsViewController

@synthesize readmeTextView;
@synthesize readmeContent;
@synthesize ownerAndRepo;
@synthesize watchersAndForks;
@synthesize desc;
@synthesize owner;
@synthesize repoInfoLabel;
@synthesize ownerInfoBtn;

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
    self.ownerAndRepo = ownerAndRepoName;
    
    self.owner = [[self.ownerAndRepo componentsSeparatedByString:@"/"] objectAtIndex:0];
    
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
    if ( [repo valueForKey:@"description"] != [NSNull null] )
        self.desc = [repo valueForKey:@"description"];
    else
        self.desc = @"\n";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue.identifier isEqualToString:@"showRepoOnWeb"] )
    {
        [segue.destinationViewController initWithOwnerAndRepoName:self.ownerAndRepo];
    }
    else if ( [segue.identifier isEqualToString:@"showUserProfile"] )
    {
        [segue.destinationViewController initWithOwner:self.owner];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //
    // show repo details on the screen
    //
    
    NSString * repoLabel = [NSString stringWithFormat:@"%@\r\n%@",
                                self.ownerAndRepo,
                                self.watchersAndForks];
    [self.repoInfoLabel setText:repoLabel];
    
    [self.readmeTextView setText:self.readmeContent];
    
    [self.ownerInfoBtn setTitle:[NSString stringWithFormat:@"Owner: %@", self.owner] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
