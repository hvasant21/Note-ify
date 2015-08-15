//
//  WaitingView.m
//  Notes
//
//  Created by Harini Vasanthakumar on 13/08/15.
//  Copyright (c) 2015 Sample. All rights reserved.
//

#import "WaitingView.h"
#import <QuartzCore/QuartzCore.h>

@implementation WaitingView
{
	IBOutlet UIView *activityIndicatorView;
    IBOutlet UILabel *loadingTxt;
    IBOutlet UIActivityIndicatorView* activityIndicator;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib{
    
    [activityIndicator startAnimating];
    //Round the corders of the inner waiting view
	[[activityIndicatorView layer] setMasksToBounds: YES];
	[[activityIndicatorView layer] setCornerRadius: 20];
	[[activityIndicatorView layer] setBorderWidth: 2.0];
	[[activityIndicatorView layer] setBorderColor: [[UIColor whiteColor] CGColor]];
}

- (void)setWaitingText:(NSString*)txt{
    [loadingTxt setText:txt];
}

+ (WaitingView *)waitingView
{
	NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"WaitingView" owner:self options:nil];
	for (id currentObject in nibContents) {
		if ([currentObject isKindOfClass:[WaitingView class]]) {
			return currentObject;
		}
	}
	return nil;
}

@end
