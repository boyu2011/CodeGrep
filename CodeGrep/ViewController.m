//
//  ViewController.m
//  CodeGrep
//
//  Created by Bo Yu on 12/25/12.
//  Copyright (c) 2012 Bo Yu. All rights reserved.
//

#import "ViewController.h"
#import "SearchResultViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize searchText;
@synthesize searchButton;

- (IBAction)doSearch:(id)sender
{
    if ( [self.searchText.text isEqualToString:@""] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hint"
                                                    message:@"Please enter a keyword."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        [self performSegueWithIdentifier:@"showSearchResult" sender:self];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue.identifier isEqualToString:@"showSearchResult"] )
    {
        NSString * search = [self.searchText.text stringByReplacingOccurrencesOfString:@" " withString:@"+" ];
        [segue.destinationViewController initWithSearchString:search];
        
    }
}


@end
