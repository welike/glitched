//
//  AchievementViewController.h
//  Glitched
//
//  Created by Kevin Elliott on 10/8/11.
//  Copyright (c) 2011 WeLike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlitchedClient.h"

@class GLAchievement;

@interface AchievementViewController : UIViewController
{
    GLAchievement *_achievement;
    IBOutlet UIImageView *_imageView;
    IBOutlet UILabel *_name;
    IBOutlet UITextView *_description;
}

@property (nonatomic, retain) GLAchievement *achievement;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UILabel *name;
@property (nonatomic, retain) UITextView *description;

- (void)displayAchievement:(GLAchievement *)achievement;

@end
