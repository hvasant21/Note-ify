//
//  NotesEditViewController.m
//  Notes
//
//  Created by Harini Vasanthakumar on 13/08/15.
//  Copyright (c) 2015 Sample. All rights reserved.
//

#import "NotesEditViewController.h"
#import "FileUtil.h"
#import "NotesEditViewController.h"
#import "NotesEditUtil.h"

@interface NotesEditViewController ()<UITextViewDelegate>

@property(nonatomic,strong) IBOutlet UITextView* notesTxtView;
@property(nonatomic,strong) IBOutlet UILabel* notesTitleLbl;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) BOOL textViewLoaded;
@end

@implementation NotesEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _notesTxtView.delegate = self;
    [self loadEditView];
    // Do any additional setup after loading the view.
}



- (void)unloadViews {
    self.activityIndicator = nil;
    _notesTxtView = nil;
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self checkAndUpdateNotesText];
}



#pragma mark - private methods

- (void)loadEditView
{
    if(_file)
    {
        self.title = @"Edit Note";
        _notesTitleLbl.text = _file.title;
        _notesTxtView.text = [FileUtil getContentOfFileWithFilePath: _file.localPath];
    }
    else
    {
        _notesTitleLbl.text = @"Untitled note";
        self.title = @"Chalk a new one!";
    }
    [_notesTxtView becomeFirstResponder ];
}


- (void)checkAndUpdateNotesText{
    do
    {
        //By default notes are valid.
        bool isTextValid = YES;
        
        //If its a new file then check for validity of data (disallow empty note)
        if(!_file)
        {
            isTextValid = [NotesEditUtil isNoteValidWithContent:_notesTxtView.text];
        }
        
        //To avoid creating empty note.
        if(!isTextValid)
        {
            break;
        }
        
        if([_delegate respondsToSelector:@selector(shouldUpdateNoteWithFile:withContent:)])
        {
            [_delegate shouldUpdateNoteWithFile:_file withContent:_notesTxtView.text];
        }
    }while (NO);
}

#pragma mark - UITextViewDelegate methods

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
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
