//
//  RepoReadMeViewController.m
//  CodeGrep
//
//  Created by Bo Yu on 1/4/13.
//  Copyright (c) 2013 Bo Yu. All rights reserved.
//

#import "RepoReadMeViewController.h"

@interface RepoReadMeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *readmeView;
@property(nonatomic) NSString * rawData;
@end

@implementation RepoReadMeViewController

@synthesize readmeView;
@synthesize rawData;

-(void) initWithReadMeRawData:(NSString *)readmeRawData
{
    self.rawData = readmeRawData;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.readmeView.text = self.rawData;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
