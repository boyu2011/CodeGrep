//
//  RepoProfileViewController.h
//  CodeGrep
//
//  Created by Bo Yu on 12/28/12.
//  Copyright (c) 2012 Bo Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepoProfileViewController : UITableViewController

- (void)initWithOwnerAndRepoName:(NSString *)ownerAndRepoName;

@end
