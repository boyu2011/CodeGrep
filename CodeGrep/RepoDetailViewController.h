//
//  RepoDetailViewController.h
//  CodeGrep
//
//  Created by Bo Yu on 1/4/13.
//  Copyright (c) 2013 Bo Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepoDetailViewController : UITableViewController

- (void)initWithOwnerAndRepoName:(NSString *)ownerAndRepoName;
@end
