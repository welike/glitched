//
//  SkillViewController.h
//  Glitched
//
//  Created by Kevin Elliott on 10/8/11.
//  Copyright (c) 2011 WeLike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlitchedClient.h"

@class GLSkill;

enum kSkillStatus {
    kSkillStatusAvailable = 0,
    kSkillStatusLearning = 1,
    kSkillStatusComplete = 2
    };

@protocol SkillViewDelegate <NSObject>

- (void)skillLearningBegan:(GLSkill *)skill;

@end

@interface SkillViewController : UIViewController <GlitchedClientDelegate>
{
    id<SkillViewDelegate> _delegate;
    GlitchedClient *_glitchedClient;
    GLSkill *_skill;
    NSDictionary *_learnResult;
    IBOutlet UIImageView *_imageView;
    IBOutlet UILabel *_name;
    IBOutlet UILabel *_time;
    IBOutlet UITextView *_description;
    IBOutlet UIButton *_learnButton;
}

@property (nonatomic, retain) id<SkillViewDelegate> delegate;
@property (nonatomic, retain) GlitchedClient *glitchedClient;
@property (nonatomic, retain) GLSkill *skill;
@property (nonatomic, retain) NSDictionary *learnResult;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UILabel *name;
@property (nonatomic, retain) UILabel *time;
@property (nonatomic, retain) UITextView *description;
@property (nonatomic, retain) UIButton *learnButton;

- (void)displaySkill:(GLSkill *)skill;
- (void)setSkillStatus:(int)kSkillStatus;
- (IBAction)learnButtonPressed;
- (void)authorize;
- (void)learnSkill;

@end
