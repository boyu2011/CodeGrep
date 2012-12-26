//
//  SearchResultViewController.m
//  CodeGrep
//
//  Created by Bo Yu on 12/25/12.
//  Copyright (c) 2012 Bo Yu. All rights reserved.
//

#import "SearchResultViewController.h"
#import "JSONKit/JSONKit.h"
#import "RepoDetailsViewController.h"

@interface SearchResultViewController ()

@property (nonatomic, retain) NSMutableArray * searchResultArray;

@end

@implementation SearchResultViewController

@synthesize searchResultArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initWithSearchString:(NSString *)searchString
{
    //
    // do search
    //
    
    NSString *theUrlString =
        [NSString stringWithFormat:@"https://api.github.com/legacy/repos/search/%@", searchString];
    NSURL *url = [NSURL URLWithString:theUrlString];
    NSData *data = [NSData dataWithContentsOfURL:url];    
    JSONDecoder * jsonDecoder = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionNone];
    NSDictionary * repos = [jsonDecoder objectWithData:data];
    self.searchResultArray = [repos valueForKey:@"repositories"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [ self.searchResultArray count ];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchResultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSDictionary * repo = [self.searchResultArray objectAtIndex:indexPath.row];
    NSString * owner = [repo valueForKey:@"owner"];
    NSString * repoName = [repo valueForKey:@"name"];
    NSString * ownerAndRepoName = [NSString stringWithFormat:@"%@/%@", owner, repoName];
    cell.textLabel.text = ownerAndRepoName;
    cell.detailTextLabel.text = [repo valueForKey:@"description"];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue.identifier isEqualToString:@"showRepoDetails"] )
    {
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSString * ownerAndRepoName = [[cell textLabel] text];
        [segue.destinationViewController initWithOwnerAndRepoName:ownerAndRepoName];
    }
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
}

@end
