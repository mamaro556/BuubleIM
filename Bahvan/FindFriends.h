    //
//  FindFriends.h
//  Bahvan
//
//  Created by MacOwner on 12/4/16.
//  Copyright © 2016 Bahvan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindFriends : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, UITextFieldDelegate, UITextViewDelegate>
@property(strong) UITableView  *tableView;
@property(nonatomic, strong) UISearchController *searchController;
@property(nonatomic, strong) UITableViewController *searchResultsController;
@property bool searchBarSearchbtnpressed;

- (IBAction)cancelFindFriends:(UIBarButtonItem *)sender;
@end
