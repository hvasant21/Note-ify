//
//  NotesViewController.m
//  Notes
//
//  Created by Harini Vasanthakumar on 11/08/15.
//  Copyright (c) 2015 Sample. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "NotesViewController.h"
#import "NotesViewModel.h"
#import "NotesViewCell.h"
#import "NotesEditViewController.h"
#import "FileObject.h"
#import "AppUtil.h"
#import "DropBoxSessionManager.h"

static NSString * const reuseIdentifier = @"NotesViewCell";


@interface NotesViewController ()<NotesViewModelDelegate,NotesEditViewControllerDelegate,UIAlertViewDelegate>
@property(nonatomic,strong) IBOutlet UITableView* notesTableView;
@property(nonatomic,strong ) NotesViewModel* notesViewModel;
@property(nonatomic,strong) IBOutlet UILabel* noResultsFoundLbl;
@end

@implementation NotesViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    _notesViewModel = [[NotesViewModel alloc]init];
    _notesViewModel.delegate = self;
  
    [self addNavBarControls];

    if([_notesViewModel isLoggedIn])
    {
        [self refreshFilesList];
    }
    
    self.title = @"Notes";
    _noResultsFoundLbl.text = @"No Results found.";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSession) name:userLoggedIn object:nil];

}

- (void)viewDidAppear:(BOOL)animated
{
    if(![_notesViewModel isLoggedIn])
    {
        [_notesViewModel doLogin:self];
    }
  
}

- (void)dealloc
{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:userLoggedIn object:nil];
}

- (void)addNavBarControls
{
    
    UIBarButtonItem* addBtn = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                               target:self action:@selector(didPressAdd)];
    UIBarButtonItem* syncBtn = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                target:self action:@selector(didPressSync)];
    
    self.navigationItem.rightBarButtonItems =  [[NSArray alloc] initWithObjects:addBtn,syncBtn, nil];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(didPressLogout)];
}

- (void)refreshSession
{
    [_notesViewModel refreshSession];
    [self refreshFilesList];
}

- (void)refreshFilesList
{
    [self showActivityIndicator];
     [_notesViewModel syncFiles];
}

- (void)showActivityIndicator{
    [[AppUtil sharedManager] showWaitingViewWithText:@"Syncing notes..."];
    _noResultsFoundLbl.alpha = 0.0;
}

- (void)hideActivityIndicator{
    [[AppUtil sharedManager] hideWaitingView];
    [self loadTableView];
}

- (void)loadTableView
{
    if(_notesViewModel.notesArray.count)
    {
        _notesTableView.alpha = 1.0;
        _noResultsFoundLbl.alpha = 0.0;
    }
    else
    {
        _notesTableView.alpha = 0.0;
        _noResultsFoundLbl.alpha = 1.0;
    }
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _notesViewModel.notesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NotesViewCell *cell = (NotesViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[NotesViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.deleteButton.tag = indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(onClickOfDeleteNote:) forControlEvents:UIControlEventTouchUpInside];
    
    // Configure the cell
    FileObject* file = [_notesViewModel.notesArray objectAtIndex:[indexPath row]];
    cell.notesTitleLbl.text = file.title;
    return cell;
}


#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FileObject* file = [_notesViewModel.notesArray objectAtIndex:[indexPath row]];
    [self navigateToNotesEditViewControllerWithFile:file];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

//On clicking delete show alert view.
//row index is set to alert.tag

- (void)onClickOfDeleteNote:(UIButton *)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Do you want to delete this note?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alert.tag = sender.tag;
    [alert show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == alertView.cancelButtonIndex){
        return;
    }
    
    FileObject* file = [_notesViewModel.notesArray objectAtIndex:[alertView tag]];
    [_notesViewModel deleteFileWithObject:file];
    
    
}

- (void)didPressLogout
{
    [_notesViewModel doLogout];
    [_notesViewModel doLogin:self];
}

- (void)didPressAdd {
    [self navigateToNotesEditViewControllerWithFile:nil];
}

- (void)didPressSync
{
    [self refreshFilesList];
}

-(void)navigateToNotesEditViewControllerWithFile:(FileObject*)file{
    NotesEditViewController* notesEditVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotesEditViewController"];
    
    notesEditVC.delegate = self;
    notesEditVC.file = file;
    
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self.navigationController pushViewController:notesEditVC animated:NO];
}



- (void)showAlertViewWithText:(NSString*)alertString
{
    UIAlertView* errAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:alertString delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errAlert show];
}


#pragma -mark NotesViewModelDelegate implementation
- (void)didFinishListUpdateListWithError:(NSError *)error
{
    if (error)
    {
        [self showAlertViewWithText:@"There was an error while updating notes list"];
    }
    else
    {
        [_notesTableView reloadData];
    }
    [self hideActivityIndicator];
}


#pragma -mark NotesEditViewControllerDelegate implementation

- (void)shouldUpdateNoteWithFile:(FileObject*)file withContent:(NSString*)content
{
    [_notesViewModel updateFileWithObject:file withContent:content];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
