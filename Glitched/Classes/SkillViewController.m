//
//  SkillViewController.m
//  Glitched
//
//  Created by Kevin Elliott on 10/8/11.
//  Copyright (c) 2011 WeLike. All rights reserved.
//

#import "SkillViewController.h"
#import "GlitchedClient.h"
#import "GLSkill.h"
#import "UIImageView+WebCache.h"

@implementation SkillViewController

@synthesize delegate = _delegate;
@synthesize glitchedClient = _glitchedClient;
@synthesize skill = _skill;
@synthesize learnResult = _learnResult;
@synthesize imageView = _imageView;
@synthesize name = _name;
@synthesize time = _time;
@synthesize description = _description;
@synthesize learnButton = _learnButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)displaySkill:(GLSkill *)skill
{
    self.skill = skill;
    [_imageView setImageWithURL:[NSURL URLWithString:skill.icon460]];
    _name.text = skill.name;
    _time.text = [skill friendlyTimeRemaining];
    _description.text = skill.description;
    self.title = skill.name;
    
    if (skill.isLearning && !skill.isComplete)
    {
        [self setSkillStatus:kSkillStatusLearning];
    }
    if (skill.isComplete)
    {
        [self setSkillStatus:kSkillStatusComplete];
    }
    if (!skill.isLearning && !skill.isComplete)
    {
        [self setSkillStatus:kSkillStatusAvailable];
    }
}

- (void)setSkillStatus:(int)kSkillStatus
{
    switch (kSkillStatus) {
        case kSkillStatusAvailable:
            [self.learnButton setEnabled:YES];
            [self.learnButton setTitle:@"Learn" forState:UIControlStateNormal];            
            break;
        case kSkillStatusLearning:
            [self.learnButton setEnabled:NO];
            [self.learnButton setTitle:@"Learning" forState:UIControlStateNormal];
            [self.learnButton setTitle:@"Learning" forState:UIControlStateHighlighted];
            [self.learnButton setTitle:@"Learning" forState:UIControlStateDisabled];
            break;
        case kSkillStatusComplete:
            [_learnButton setEnabled:NO];
            [_learnButton setTitle:@"Complete" forState:UIControlStateNormal];
            [_learnButton setTitle:@"Complete" forState:UIControlStateHighlighted];
            [_learnButton setTitle:@"Complete" forState:UIControlStateDisabled];
            break;
        default:
            break;
    }
}

- (IBAction)learnButtonPressed
{
    NSLog(@"Skill: Learn button pressed!");
    if (!_glitchedClient)
    {
        [self authorize];
    }
    else
    {
        [self learnSkill];
    }
}

- (void)authorize
{
    [_learnButton setEnabled:NO];
    if (!_glitchedClient)
    {
        _glitchedClient = [[GlitchedClient alloc] init];
        _glitchedClient.delegate = self;
    }
    [_glitchedClient authorize];
}

- (void)learnSkill
{
    NSLog(@"Skill: Requesting to learn skill '%@' (id: %@)", _skill.name, _skill.skillId);
    [_learnButton setEnabled:NO];
    [_glitchedClient learnSkill:_skill.skillId];
}

#pragma mark - Glitched Client Delegate

- (void)glitchedClient:(GlitchedClient *)client authorizationSuccessful:(BOOL)successful
{
    NSLog(@"Skill: glitchedClient:authorizationSuccessful called");    
    [self learnSkill];
}

- (void)glitchedClient:(GlitchedClient *)client receivedSkillLearnStatus:(NSDictionary *)result
{
    NSLog(@"Skill: Received skill learn status");
    self.learnResult = result;
    
    BOOL ok = [[result objectForKey:@"ok"] boolValue];
    if (ok)
    {
        [self setSkillStatus:kSkillStatusLearning];
        [_delegate skillLearningBegan:_skill];
    }
    else
    {
        NSString *error = [result objectForKey:@"error"];
        if ([error isEqualToString:@"Doesn't meet requirements"])
        {
            NSLog(@"Skill: Learn status is already 'learning'");
            [self setSkillStatus:kSkillStatusLearning];
        }
        else
        {
            NSLog(@"Skill: Learn status is 'complete'");
            [self setSkillStatus:kSkillStatusComplete];
        }
    }
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (_skill)
        [self displaySkill:_skill];
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
