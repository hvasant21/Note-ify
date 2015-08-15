//
//  NotesViewCell.h
//  Notes
//
//  Created by Harini Vasanthakumar on 11/08/15.
//  Copyright (c) 2015 Sample. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotesViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *notesTitleLbl;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
