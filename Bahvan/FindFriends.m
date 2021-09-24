//
//  FindFriends.m
//  Bahvan
//
//  Created by MacOwner on 12/4/16.
//  Copyright © 2016 Bahvan. All rights reserved.
//

#import "FindFriends.h"

@implementation FindFriends

NSArray *FriendsSmplx;
NSArray *FriendsFiltered;

- (id) init {
    self = [super initWithNibName:nil bundle:nil];
    return self;
}
- (void) viewDidLoad {
    [super viewDidLoad];
 
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel target:self action:@selector(dismissView:)];
 
    self.navigationItem.leftBarButtonItem = item;

    self.searchBarSearchbtnpressed = NO;
    self.searchResultsController = [[UITableViewController alloc] init];
//    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultsController];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    /*
    self.searchResultsController.view.frame = self.view.bounds;
    [self addChildViewController:self.searchResultsController];
    [self.view addSubview:self.searchResultsController.view];
    [self.searchResultsController didMoveToParentViewController:self];
    
    self.searchResultsController.tableView.dataSource = self;
    self.searchResultsController.tableView.delegate = self;
    */
    
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.placeholder = @"Search";
    self.searchController.searchBar.delegate = self;
    self.definesPresentationContext = YES;
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.showsCancelButton = NO;
    
    FriendsSmplx = [NSArray arrayWithObjects:@"George Hamiltonxxxxxxxxxxxxxxxxxx", @"Chris Foley", @"Steven Philson", @"EricSchmidt", nil];
    FriendsFiltered = [[NSArray alloc] init];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,375, 150) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 44;
    self.tableView.userInteractionEnabled = YES;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    //self.searchResultsController.tableView.tableHeaderView = self.searchController.searchBar;
    [self.view addSubview:self.tableView];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO ;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [tapGR setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tapGR];
     

    // Set Autolayout Constraints for Signup Table View Controller Container

    NSLayoutConstraint *constraint = [NSLayoutConstraint
                                      constraintWithItem: self.tableView
                                      attribute: NSLayoutAttributeLeading
                                      relatedBy: NSLayoutRelationEqual
                                      toItem: self.view
                                      attribute: NSLayoutAttributeLeading
                                      multiplier:1.0
                                      constant:0];
    [self.view addConstraint:constraint];
    
    constraint  = [NSLayoutConstraint
                             constraintWithItem: self.tableView
                             attribute: NSLayoutAttributeTop
                             relatedBy: NSLayoutRelationEqual
                             toItem: self.tableView
                             attribute: NSLayoutAttributeTop
                             multiplier:1.0
                             constant:0];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint
                  constraintWithItem: self.tableView
                  attribute: NSLayoutAttributeHeight
                  relatedBy: NSLayoutRelationEqual
                  toItem: nil
                  attribute: NSLayoutAttributeNotAnAttribute
                  multiplier:1.0
                  constant:400];
    [self.tableView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint
                  constraintWithItem: self.tableView
                  attribute: NSLayoutAttributeWidth
                  relatedBy: NSLayoutRelationEqual
                  toItem: nil
                  attribute: NSLayoutAttributeNotAnAttribute
                  multiplier:1.0
                  constant:self.view.frame.size.width];
    [self.tableView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint
                  constraintWithItem: self.tableView
                  attribute: NSLayoutAttributeTrailing
                  relatedBy: NSLayoutRelationEqual
                  toItem: self.view
                  attribute: NSLayoutAttributeTrailing
                  multiplier:1.0
                  constant:0];
    [self.view addConstraint:constraint];

     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];


}

- (void) dismissView: (id) sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self dismissModalViewControllerAnimated: YES];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active && [self.searchController.searchBar.text length] != 0){
        return [FriendsFiltered count];
    }
    else{
    return [FriendsSmplx count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifierx = @"SimpleTableItemx";
    NSString *arrayText;
    
    UITableViewCell *cellx = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifierx];
    
    if (cellx == nil) {
        cellx = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifierx];
    }
    cellx.imageView.image = [UIImage imageNamed:@"mark1.jpg"];
    
    //Button
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(cellx.bounds.origin.x + 210, cellx.bounds.origin.y + 10, 100, 30);
    [button setTitle:@"Add" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [[button layer] setBackgroundColor:[UIColor whiteColor].CGColor];
    [[button layer] setBorderColor:[UIColor blackColor].CGColor];
    [[button layer] setBorderWidth:1.0f];
    [cellx.contentView addSubview:button];
    if (self.searchController.active  && [self.searchController.searchBar.text length] != 0)
    {
        arrayText = [FriendsFiltered objectAtIndex:indexPath.row];
    }
    else
    {
        arrayText = [FriendsSmplx objectAtIndex:indexPath.row];
    }
    
    cellx.textLabel.text = arrayText;
    return cellx;
}

- (void)buttonPressed:(id)sender
{
    NSLog(@"Buttonpressed!");
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)cancelFindFriends:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)KeyboardDidShow:(NSNotification *) Not
{
}

// Notification Method for when Keyboard will be hidden.
- (void)KeyboardWillHide:(NSNotification *) not
{
}


#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length >0)
    {
        //FriendsFiltered = [FriendsSmplx mutableCopy];
        self.searchBarSearchbtnpressed = YES;
        NSPredicate *resultsPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchBar.text];
        NSLog(@"searchbartext length %lu", [searchBar.text length]);
        
        
        FriendsFiltered = [FriendsSmplx filteredArrayUsingPredicate:resultsPredicate];
        [self.tableView reloadData];
    }
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([self.searchController.searchBar.text length] == 0)
    {
        [self.tableView reloadData];
    }
    self.searchBarSearchbtnpressed = NO;
}

@end
