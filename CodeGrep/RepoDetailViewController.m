//
//  RepoDetailViewController.m
//  CodeGrep
//
//  Created by Bo Yu on 1/4/13.
//  Copyright (c) 2013 Bo Yu. All rights reserved.
//

#import "RepoDetailViewController.h"
#import "JSONKit/JSONKit.h"
#import "DEFINE.h"

@interface RepoDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *repoAttrTableView;
@property(nonatomic) JSONDecoder * jsonDecoder;
@property(nonatomic) NSString * ownerAndRepo;
@property(nonatomic) NSString * owner;
@property(strong, nonatomic) NSMutableArray * repoAttrArray;
@property(nonatomic) NSString * urlString;
@property(nonatomic) NSURL * url;
@property(nonatomic) NSMutableURLRequest * urlRequest;
@property(nonatomic) NSData * data;

@end

@implementation RepoDetailViewController

@synthesize repoAttrTableView;
@synthesize jsonDecoder;
@synthesize ownerAndRepo;
@synthesize owner;
@synthesize repoAttrArray;
@synthesize urlString;
@synthesize url;
@synthesize urlRequest;
@synthesize data;

- (void)initWithOwnerAndRepoName:(NSString *)ownerAndRepoName
{
    self.ownerAndRepo = ownerAndRepoName;
    self.owner = [[self.ownerAndRepo componentsSeparatedByString:@"/"] objectAtIndex:0];
    
    //
    // get repo details
    //
    
    self.jsonDecoder = [[JSONDecoder alloc]initWithParseOptions:JKParseOptionNone];
    self.urlString = [NSString stringWithFormat:@"https://api.github.com/repos/%@%@", ownerAndRepoName, UNAUTH_CALL_HIGHER_RATE];
    self.url = [NSURL URLWithString:self.urlString];
    self.data = [NSData dataWithContentsOfURL:self.url];
    NSDictionary * repoDict = [self.jsonDecoder objectWithData:self.data];
    
    //
    // fill repo array which will be shown on the table view.
    //
    /*
     self.repoAttrs = [NSMutableArray arrayWithObjects:[repoDict valueForKey:@"name"],
     self.owner,
     nil];
     */
    self.repoAttrArray = [NSMutableArray arrayWithObjects:
                      [NSDictionary dictionaryWithObjectsAndKeys:
                       @"Name", @"sectionTitle",
                       [repoDict valueForKey:@"name"], @"attrValue",
                       nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:
                       @"Description", @"sectionTitle",
                       [repoDict valueForKey:@"description"], @"attrValue",
                       nil],
                      /*
                       [NSDictionary dictionaryWithObjectsAndKeys:
                       @"Owner",@"sectionTitle",
                       self.owner, @"attrValue",
                       nil],
                       */
                      nil];
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RepoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
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
}

@end
