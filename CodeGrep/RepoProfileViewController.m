//
//  RepoDetailsViewController2.m
//  CodeGrep
//
//  Created by Bo Yu on 12/28/12.
//  Copyright (c) 2012 Bo Yu. All rights reserved.
//

#import "RepoProfileViewController.h"
#import "JSONKit/JSONKit.h"
#import "UserProfileViewController.h"
#import "RepoReadMeViewController.h"
#import "RepoDetailViewController.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "DEFINE.h"

@interface RepoProfileViewController ()

@property(nonatomic) JSONDecoder * jsonDecoder;
@property(nonatomic) NSString * ownerAndRepo;
@property(nonatomic) NSString * owner;
@property(nonatomic) NSString * forkAndWatcherString;
@property(nonatomic) NSString * description;
@property(strong, nonatomic) NSMutableArray * repoAttrs;
@property(nonatomic) NSString * urlString;
@property(nonatomic) NSURL * url;
@property(nonatomic) NSMutableURLRequest * urlRequest;
@property(nonatomic) NSData * data;
@property(nonatomic) NSMutableData * readmeHtmlData;
@property(nonatomic) NSString * readmeRawData;
@property (weak, nonatomic) IBOutlet UITextView *readmeTextView;
@property (weak, nonatomic) IBOutlet UIWebView *readmeWebView;

@end

@implementation RepoProfileViewController

@synthesize jsonDecoder;
@synthesize ownerAndRepo;
@synthesize owner;
@synthesize forkAndWatcherString;
@synthesize description;
@synthesize repoAttrs;
@synthesize urlString;
@synthesize url;
@synthesize urlRequest;
@synthesize data;
@synthesize readmeRawData;
@synthesize readmeTextView;
@synthesize readmeWebView;
@synthesize readmeHtmlData;

//
// send a tweet.
//

- (IBAction)sendTweet:(id)sender
{
    //  Create an instance of the Tweet Sheet
    SLComposeViewController *tweetSheet = [SLComposeViewController
                                           composeViewControllerForServiceType:
                                           SLServiceTypeTwitter];
    
    // Sets the completion handler.  Note that we don't know which thread the
    // block will be called on, so we need to ensure that any UI updates occur
    // on the main queue
    tweetSheet.completionHandler = ^(SLComposeViewControllerResult result) {
        switch(result) {
            //  This means the user cancelled without sending the Tweet
            case SLComposeViewControllerResultCancelled:
                break;
            //  This means the user hit 'Send'
            case SLComposeViewControllerResultDone:
                break;
        }
        
        //  dismiss the Tweet Sheet
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:^{
                NSLog(@"Tweet Sheet has been dismissed.");
            }];
        });
    };
        
    //  Set the initial body of the Tweet
    [tweetSheet setInitialText:[NSString stringWithFormat:@"%@: %@", self.ownerAndRepo, self.description]];
    
    //  Add an URL to the Tweet.  You can add multiple URLs.
    if (![tweetSheet addURL:[NSURL URLWithString:[NSString stringWithFormat:@"github.com/%@", self.ownerAndRepo]]])
    {
        NSLog(@"Unable to add the URL!");
    }
    
    //  Presents the Tweet Sheet to the user
    [self presentViewController:tweetSheet animated:YES completion:^{
        NSLog(@"Tweet sheet has been presented.");
    }];
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

//
// Initialize the world...
//

- (void)initWithOwnerAndRepoName:(NSString *)ownerAndRepoName
{
    self.ownerAndRepo = ownerAndRepoName;
    self.owner = [[self.ownerAndRepo componentsSeparatedByString:@"/"] objectAtIndex:0];
    
    //
    // get repo details info
    //
    
    self.jsonDecoder = [[JSONDecoder alloc]initWithParseOptions:JKParseOptionNone];
    self.urlString = [NSString stringWithFormat:@"https://api.github.com/repos/%@%@", ownerAndRepoName, UNAUTH_CALL_HIGHER_RATE];
    self.url = [NSURL URLWithString:self.urlString];
    self.data = [NSData dataWithContentsOfURL:self.url];    
    NSDictionary * repoDict = [self.jsonDecoder objectWithData:self.data];
    
    //
    // get readme path
    //
    // $ curl https://api.github.com/repos/boyu2011/iCode/readme
    //
    
    self.urlString = [NSString stringWithFormat:@"https://api.github.com/repos/%@/readme%@", self.ownerAndRepo, UNAUTH_CALL_HIGHER_RATE];
    self.url = [NSURL URLWithString:self.urlString];
    self.data = [NSData dataWithContentsOfURL:self.url];
    NSDictionary * readme = [self.jsonDecoder objectWithData:self.data];
    NSString * readmePath = [readme valueForKey:@"path"];
    
    //
    // get readme raw data
    //
    // $ curl https://raw.github.com/ajaxorg/cloud9/master/README.md
    //
    
    self.urlString = [NSString stringWithFormat:@"https://raw.github.com/%@/master/%@%@",
                    self.ownerAndRepo, readmePath, UNAUTH_CALL_HIGHER_RATE];
    self.url = [NSURL URLWithString:self.urlString];
    NSString * readmeRaw = [NSString stringWithContentsOfURL:self.url encoding:NSUTF8StringEncoding error:NULL];
    self.readmeRawData = readmeRaw;
    
    /*
    self.urlString = [NSString stringWithFormat:@"https://github.com/repos/%@/blob/master"]
    [self.urlRequest setValue:@"application/vnd.github.full+html" forHTTPHeaderField:@"Accept"];
    */
    
    //
    // get readme with HTML format
    //
    
    self.urlString = [NSString stringWithFormat:@"https://api.github.com/repos/%@/readme%@",
                      self.ownerAndRepo, UNAUTH_CALL_HIGHER_RATE];
    self.url = [NSURL URLWithString:self.urlString];
    self.urlRequest = [[NSMutableURLRequest alloc] initWithURL:self.url];
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] initWithCapacity:2];
    [headers setValue:@"application/vnd.github.v3.html+json" forKey:@"Accept"];
    [self.urlRequest setAllHTTPHeaderFields:headers];
                                    
                                    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:self.urlRequest delegate:self];
    if (theConnection)
    {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        //self.webData = [[NSMutableData data] retain];
    }
    else
    {
        // Inform the user that the connection failed.
    }
    [theConnection start];
                                    
                                    
    //
    // fill repo array which will be shown on the table view.
    //

    self.forkAndWatcherString = [NSString stringWithFormat:@"Forks: %@    Watchers: %@",
                                 [repoDict valueForKey:@"forks"],
                                 [repoDict valueForKey:@"watchers"]];
    self.description = [repoDict valueForKey:@"description"];
    
    self.repoAttrs = [NSMutableArray arrayWithObjects:
                        [NSDictionary dictionaryWithObjectsAndKeys:
                            [repoDict valueForKey:@"name"], @"sectionTitle",
                            self.forkAndWatcherString, @"attrValue",
                            nil],
                      /*
                        [NSDictionary dictionaryWithObjectsAndKeys:
                            @"Description", @"sectionTitle",
                            [repoDict valueForKey:@"description"], @"attrValue",
                            nil],
                      
                        [NSDictionary dictionaryWithObjectsAndKeys:
                            @"README", @"sectionTitle",
                            @"", @"attrValue",
                            nil],
                      */
                       /*
                        [NSDictionary dictionaryWithObjectsAndKeys:
                            @"Owner",@"sectionTitle",
                            self.owner, @"attrValue",
                            nil],
                       */
                        nil];
    

    /*
    NSLog([ [self.repoAttrs objectAtIndex:0] valueForKey:@"name"] );
    NSLog([[self.repoAttrs objectAtIndex:0] valueForKey:@"value"] );
     */
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.readmeTextView setText: self.readmeRawData];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    else if ( [segue.identifier isEqualToString:@"showRepoReadMe"] )
    {
        [segue.destinationViewController initWithReadMeRawData:self.readmeRawData];
    }
    else if ([segue.identifier isEqualToString:@"showRepoDetails"])
    {
        [segue.destinationViewController initWithOwnerAndRepoName:
         self.ownerAndRepo];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return [self.repoAttrs count];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return 1;
    return [self.repoAttrs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"repoAttr";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...

    if ( [self.repoAttrs objectAtIndex:indexPath.row] != [NSNull null] )
    {
        cell.textLabel.text = [[self.repoAttrs objectAtIndex:indexPath.row]
                               valueForKey:@"sectionTitle"];
        cell.detailTextLabel.text = [[self.repoAttrs objectAtIndex:indexPath.row] valueForKey:@"attrValue"];
        
        if ( [cell.textLabel.text isEqualToString:@"Description"] )
        {
            cell.userInteractionEnabled = NO;
        }
        
        //cell.textLabel.numberOfLines = 10;
        //cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    }
    
    return cell;
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (44.0 + (10 - 1) * 19.0);
}
*/
/*
- (NSString *) tableView:(UITableView *)tableView
    titleForHeaderInSection:(NSInteger)section
{
    return [[self.repoAttrs objectAtIndex:section] valueForKey:@"sectionTitle"];
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    /*
    if ( [selectedCell.detailTextLabel.text isEqualToString:self.owner] )
        [self performSegueWithIdentifier:@"showUserProfile" sender:self];
    else if ( [selectedCell.textLabel.text isEqualToString:@"Name"] )
    */
    [self performSegueWithIdentifier:@"showRepoDetails" sender:self];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{    
    self.readmeHtmlData = [[NSMutableData alloc] init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.readmeHtmlData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString * readmeHtml = [[NSString alloc] initWithData:self.readmeHtmlData encoding:NSUTF8StringEncoding];
    [self.readmeWebView loadHTMLString:readmeHtml baseURL:nil];
}

@end
