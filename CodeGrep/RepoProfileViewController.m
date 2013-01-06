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
#import "DEFINE.h"

@interface RepoProfileViewController ()

@property(nonatomic) JSONDecoder * jsonDecoder;
@property(nonatomic) NSString * ownerAndRepo;
@property(nonatomic) NSString * owner;
@property(nonatomic) NSString * forkAndWatcherString;
@property(strong, nonatomic) NSMutableArray * repoAttrs;
@property(nonatomic) NSString * urlString;
@property(nonatomic) NSURL * url;
@property(nonatomic) NSMutableURLRequest * urlRequest;
@property(nonatomic) NSData * data;
@property(nonatomic) NSString * readmeRawData;
@property (weak, nonatomic) IBOutlet UITextView *readmeTextView;

@end

@implementation RepoProfileViewController

@synthesize jsonDecoder;
@synthesize ownerAndRepo;
@synthesize owner;
@synthesize forkAndWatcherString;
@synthesize repoAttrs;
@synthesize urlString;
@synthesize url;
@synthesize urlRequest;
@synthesize data;
@synthesize readmeRawData;
@synthesize readmeTextView;

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
    // fill repo array which will be shown on the table view.
    //

    self.forkAndWatcherString = [NSString stringWithFormat:@"Forks: %@    Watchers: %@",
                                 [repoDict valueForKey:@"forks"],
                                 [repoDict valueForKey:@"watchers"]];
    
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

@end
