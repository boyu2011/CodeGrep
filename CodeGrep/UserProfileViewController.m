//
//  UserProfileViewController.m
//  CodeGrep
//
//  Created by Bo Yu on 12/27/12.
//  Copyright (c) 2012 Bo Yu. All rights reserved.
//

#import "UserProfileViewController.h"
#import "JSONKit/JSONKit.h"
#import "WebViewController.h"
#import "DEFINE.h"

@interface UserProfileViewController ()

@property(retain, nonatomic) NSString * urlString;
@property(retain, nonatomic) NSURL * url;
@property(retain, nonatomic) NSData * data;
@property(retain, nonatomic) JSONDecoder * jsonDecoder;
@property(retain, nonatomic) NSString * owner;
@property(retain, nonatomic) NSString * name;
@property(retain, nonatomic) NSString * avatar_url;
@property(nonatomic) NSString * blog;
@property(nonatomic) NSString * location;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UIButton *blogBtn;

@end

@implementation UserProfileViewController

@synthesize owner;
@synthesize name;
@synthesize blog;
@synthesize location;
@synthesize userImageView;
@synthesize userLabel;
@synthesize blogBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) initWithOwner:(NSString *)ownerString
{
    //
    // get user information
    //
    
    self.urlString = [NSString stringWithFormat:@"https://api.github.com/users/%@%@", ownerString, UNAUTH_CALL_HIGHER_RATE];
    self.url = [NSURL URLWithString:self.urlString];
    self.data = [NSData dataWithContentsOfURL:self.url];
    self.jsonDecoder = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionNone];
    NSDictionary * user = [self.jsonDecoder objectWithData:self.data];
    self.avatar_url = [user objectForKey:@"avatar_url"];
    self.name = [user objectForKey:@"name"];
    if ( [user objectForKey:@"blog"] == [NSNull null])
        self.blog = @"N/A";
    else
    {
        if ( [user objectForKey:@"blog"] == @"" )
            self.blog = @"N/A";
        else
            self.blog = [user objectForKey:@"blog"];
    }
    self.location = [user objectForKey:@"location"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue.identifier isEqualToString:@"showWebPage"] )
    {
        [segue.destinationViewController initWithUrlString:self.blogBtn.titleLabel.text];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // image
    NSURL * userImageUrl = [NSURL URLWithString:self.avatar_url];
    NSData * userImageData = [NSData dataWithContentsOfURL:userImageUrl];
    [self.userImageView setImage:[UIImage imageWithData:userImageData]];
    
    [self.userLabel setText:[NSString stringWithFormat:@"%@\r\n%@", self.name, self.location]];
    
    [self.blogBtn setTitle:self.blog forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
