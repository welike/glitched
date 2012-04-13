//
//  AchievementViewController.m
//  Glitched
//
//  Created by Kevin Elliott on 10/8/11.
//  Copyright (c) 2011 WeLike. All rights reserved.
//

#import "AchievementViewController.h"
#import "GLAchievement.h"
#import "UIImageView+WebCache.h"

@implementation AchievementViewController

@synthesize achievement = _achievement;
@synthesize imageView = _imageView;
@synthesize name = _name;
@synthesize description = _description;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)displayAchievement:(GLAchievement *)achievement
{
    self.achievement = achievement;
    [_imageView setImageWithURL:[NSURL URLWithString:achievement.image180]];
    self.title = achievement.name;
    _name.text = achievement.name;
    _description.text = achievement.description;
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (_achievement)
        [self displayAchievement:_achievement];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end
