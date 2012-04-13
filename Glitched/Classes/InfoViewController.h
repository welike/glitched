//
//  InfoViewController.h
//  Glitched
//
//  Created by Kevin Elliott on 10/5/11.
//  Copyright (c) 2011 WeLike. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InfoViewController;

@protocol InfoViewDelegate <NSObject>
- (void)infoViewDismissed:(InfoViewController *)infoView;
@end

@interface InfoViewController : UIViewController
{
    id<InfoViewDelegate> _delegate;
}

@property (nonatomic, retain) id<InfoViewDelegate> delegate;

- (IBAction)dismissButtonPressed;

@end
