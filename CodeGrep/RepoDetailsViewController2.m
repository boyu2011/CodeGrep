//
//  RepoDetailsViewController2.m
//  CodeGrep
//
//  Created by Bo Yu on 12/28/12.
//  Copyright (c) 2012 Bo Yu. All rights reserved.
//

#import "RepoDetailsViewController2.h"
#import "JSONKit/JSONKit.h"
#import "UserProfileViewController.h"
#import "DEFINE.h"

@interface RepoDetailsViewController2 ()

@property(nonatomic) JSONDecoder * jsonDecoder;
@property(nonatomic) NSString * ownerAndRepo;
@property(nonatomic) NSString * owner;
@property(strong, nonatomic) NSMutableArray * repoAttrs;
@property(nonatomic) NSString * urlString;
@property(nonatomic) NSURL * url;
@property(nonatomic) NSData * data;
@property(nonatomic) NSString * readmeRawData;

@end

@implementation RepoDetailsViewController2

@synthesize jsonDecoder;
@synthesize ownerAndRepo;
@synthesize owner;
@synthesize repoAttrs;
@synthesize urlString;
@synthesize url;
@synthesize data;
@synthesize readmeRawData;

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
    
    //
    // fill repo array
    //
    
    self.repoAttrs = [NSMutableArray arrayWithObjects:[repoDict valueForKey:@"name"],
                                                      [repoDict valueForKey:@"description"],
                                                      [repoDict valueForKey:@"html_url"],
                                                      self.owner,
                                                      nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.repoAttrs count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"repoAttr";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if ( [self.repoAttrs objectAtIndex:indexPath.section] != [NSNull null] )
        cell.textLabel.text = [self.repoAttrs objectAtIndex:indexPath.section];
    
    return cell;
}

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
    if ( [selectedCell.textLabel.text isEqualToString:self.owner] )
        [self performSegueWithIdentifier:@"showUserProfile" sender:self];
}

@end
