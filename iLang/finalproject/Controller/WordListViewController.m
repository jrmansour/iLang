//
//  WorldListViewController.m
//  finalproject
//
//  Created by Jahan on 12/01/14.
//  Copyright (c) 2014 Jahangir Rostamzad. All rights reserved.
//

#import "WordListViewController.h"
#import "Word.h"
#import "WordListCell.h"
#import "EditWordViewController.h"

@interface WordListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) NSIndexPath* toBeDeletedPath;
@property (weak, nonatomic) IBOutlet UITableView *tableView;    
// The controller (this class fetches nothing if this is not set).
@property (strong, nonatomic) CoreDataTableViewController *coreDataTableViewController;

@end

@implementation WordListViewController

// Create an NSFetchRequest to get all words and hook it up to our table via an NSFetchedResultsController

- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Word"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"nr" ascending:YES]];
    
    // no predicate because we want ALL the Photographers
    self.coreDataTableViewController = [[CoreDataTableViewController alloc] init];
    self.coreDataTableViewController.fetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                        managedObjectContext:self.database.managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:nil];
    
    self.coreDataTableViewController.tableView = self.tableView;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}

- (void)setupGesturesForDelete
{
    self.toBeDeletedPath = nil;
    
    //Add a right swipe gesture recognizer
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(handleSwipeRight:)];
    //recognizer.delegate = self;
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.tableView addGestureRecognizer:recognizer];
    
    //Add a left swipe gesture recognizer
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.tableView addGestureRecognizer:recognizer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupFetchedResultsController];
    
    [self setupGesturesForDelete];
}

- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer
{
    // hide delete button of another cell (if shown)
    [self hideDeleteButton];
    
    //Get location of the swipe
    CGPoint location = [gestureRecognizer locationInView:self.tableView];
    
    //Get the corresponding index path within the table view
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    // check if index path is valid
    if(indexPath)
    {
        // get the cell out of the table view
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        // create delete button
        UIButton* deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [deleteButton setTitle: @"Delete" forState:UIControlStateNormal];
        [deleteButton setFrame:CGRectMake(0, 10, 60, 40)];
        [deleteButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        deleteButton.backgroundColor = [UIColor redColor];
        [deleteButton addTarget: self action: @selector(deletePressed:) forControlEvents:UIControlEventTouchUpInside];
        
        // show delete button in the cell
        cell.accessoryView = deleteButton;
        
        // remember the path of the row to be deleted
        self.toBeDeletedPath = indexPath;
    }
}

- (void)handleSwipeRight:(UISwipeGestureRecognizer *)gestureRecognizer
{
    [self hideDeleteButton];
}

- (void) hideDeleteButton
{
    if (self.toBeDeletedPath != nil) {
        // get the cell out of the table view
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.toBeDeletedPath];
        
        // hide the delete button
        cell.accessoryView = nil;
        
        self.toBeDeletedPath = nil;
    }
}

- (void)deletePressed:(id)sender {
    Word* word = [self.coreDataTableViewController.fetchedResultsController objectAtIndexPath:self.toBeDeletedPath];
    [self hideDeleteButton];
    [word.managedObjectContext deleteObject: word];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.coreDataTableViewController numberOfSectionsInTableView: tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.coreDataTableViewController tableView:tableView numberOfRowsInSection: section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [self.coreDataTableViewController tableView:tableView titleForHeaderInSection: section];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	return [self.coreDataTableViewController tableView:tableView sectionForSectionIndexTitle: title atIndex: index];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.coreDataTableViewController sectionIndexTitlesForTableView:tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TableCell";
    WordListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WordListCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.userInteractionEnabled = TRUE;
    }
    
    // ask NSFetchedResultsController for the NSMO at the row in question
    Word *word = [self.coreDataTableViewController.fetchedResultsController objectAtIndexPath:indexPath];
    // Then configure the cell using it ...
    cell.nrLabel.text = [NSString stringWithFormat:@"%d", [word.nr intValue]];
    cell.wordLabel.text = word.word;
    cell.translationLabel.text = word.translation;
    cell.statusLabel.text = word.status;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"EditWord" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EditWord"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Word *word = [self.coreDataTableViewController.fetchedResultsController objectAtIndexPath:indexPath];
        EditWordViewController* editWordController = segue.destinationViewController;
        editWordController.word = word;
        editWordController.newWord = false;
    } else if ([segue.identifier isEqualToString:@"NewWord"]) {
        Word* word = [NSEntityDescription insertNewObjectForEntityForName:@"Word"
                                                   inManagedObjectContext:self.database.managedObjectContext];
        word.nr = [NSNumber numberWithInt: [self.database maxWordNumber] + 1];
        word.status = @"new";
        EditWordViewController* editWordController = segue.destinationViewController;
        editWordController.word = word;
        editWordController.newWord = true;
    }
}

@end
