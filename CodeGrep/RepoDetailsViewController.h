//
//  RepoDetailsViewController.h
//  CodeGrep
//
//  Created by Bo Yu on 12/25/12.
//  Copyright (c) 2012 Bo Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepoDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *readmeTextView;

- (void)initWithOwnerAndRepoName:(NSString *)ownerAndRepoName;

@end
