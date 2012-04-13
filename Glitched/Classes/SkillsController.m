//
//  SkillsController.m
//  Glitched
//
//  Created by Kevin Elliott on 10/5/11.
//  Copyright (c) 2011 WeLike. All rights reserved.
//

#import "SkillsController.h"
#import "AchievementsController.h"
#import "GradientBackgroundTable.h"

#import "GLSkill.h"
#import "SkillCell.h"
#import "SkillViewController.h"
#import "GlitchedAppDelegate.h"

@implementation SkillsController

@synthesize glitchedClient = _glitchedClient;
@synthesize allSkillsResult = _allSkillsResult;
@synthesize availableSkillsResult = _availableSkillsResult;
@synthesize learnedSkillsResult = _learnedSkillsResult;
@synthesize learningSkillsResult = _learningSkillsResult;
@synthesize allSkills = _allSkills;
@synthesize availableSkills = _availableSkills;
@synthesize learnedSkills = _learnedSkills;
@synthesize learningSkills = _learningSkills;
@synthesize skillCache = _skillCache;
@synthesize isRefreshNeeded = _isRefreshNeeded;

- (NSString *)title
{
    return NSLocalizedString(@"Skills", @"");
}

- (void)createRows
{
    // Learning Skills
    [self addSectionAtIndex:0 withAnimation:UITableViewRowAnimationFade];
    if (_learningSkills)
    {
        for (GLSkill *item in _learningSkills) 
        {
            [self appendRowToSection:0
                           cellClass:[SkillCell class] 
                            cellData:item
                       withAnimation:UITableViewRowAnimationAutomatic];
        }
    }

    // Available Skills
    [self addSectionAtIndex:1 withAnimation:UITableViewRowAnimationFade];
    if (_availableSkills)
    {
        for (GLSkill *item in _availableSkills) 
        {
            [self appendRowToSection:1
                           cellClass:[SkillCell class] 
                            cellData:item
                       withAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    
    // Learned Skills
    [self addSectionAtIndex:2 withAnimation:UITableViewRowAnimationFade];
    if (_learnedSkills)
    {
        for (GLSkill *item in _learnedSkills) 
        {
            [self appendRowToSection:2
                           cellClass:[SkillCell class] 
                            cellData:item
                       withAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    
    [self hideLoadingIndicator];
}

- (void)refreshButtonPressed:(id)sender
{
    [self showLoadingIndicator];
    [_glitchedClient getSkillsLearning];
}

- (void)refresh:(id)sender
{
    [self removeAllSectionsWithAnimation:UITableViewRowAnimationFade];
    [self performSelector:@selector(createRows) withObject:nil afterDelay:0.5];
    [self showLoadingIndicator];
}

- (NSString *)tableView:(UITableView *)aTableView
titleForHeaderInSection:(NSInteger)section
{
	if (section == 0)
	{
		return NSLocalizedString(@"Learning", nil);
	}
	else if (section == 1)
	{
		return NSLocalizedString(@"Available", nil);
	}
	else if (section == 2)
	{
		return NSLocalizedString(@"Learned", nil);
	}
    
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    GLSkill *skill = nil;
    
    switch (section) {
        case 0:
            skill = [_learningSkills objectAtIndex:row];
            break;
        
        case 1:
            skill = [_availableSkills objectAtIndex:row];
            break;
            
        case 2:
            skill = [_learnedSkills objectAtIndex:row];
            break;
            
        default:
            break;
    }
    
    if (skill)
    {
        SkillViewController *skillViewController = [[SkillViewController alloc] initWithNibName:@"SkillView" bundle:nil];
        skillViewController.delegate = self;
        skillViewController.skill = skill;
        [self.navigationController pushViewController:skillViewController animated:YES];
        [skillViewController release];
    }
}

#pragma mark - Glitched Client Delegate

- (void)glitchedClient:(GlitchedClient *)client authorizationSuccessful:(BOOL)successful
{
    NSLog(@"Skills: glitchedClient:authorizationSuccessful called");
    
    if (!_learningSkills)
    {
        [_glitchedClient getSkillsLearning];
        [self showLoadingIndicator];

    }
}

- (void)glitchedClient:(GlitchedClient *)client receivedPlayerInfo:(NSDictionary *)result
{
    NSLog(@"Skills: glitchedClient:receivedPlayerInfo called");
}

- (void)glitchedClient:(GlitchedClient *)client receivedSkills:(NSDictionary *)result
{
    NSLog(@"Skills: glitchedClient:receivedSkills called");
    
    self.allSkillsResult = [NSDictionary dictionaryWithDictionary:result];
    self.allSkills = [self sortItems:[self extractItemsFromResult:result]];
    
    [_glitchedClient performSelector:@selector(getSkillsLearning) withObject:nil afterDelay:SKILL_FETCH_DELAY];
}

- (void)glitchedClient:(GlitchedClient *)client receivedSkillsLearning:(NSDictionary *)result
{
    NSLog(@"Skills: glitchedClient:receivedSkillsLearning called");
    
    self.learningSkillsResult = [NSDictionary dictionaryWithDictionary:result];
    self.learningSkills = [self sortItems:[self extractItemsFromResult:result itemsKey:@"learning"]];
    for (GLSkill *skill in _learningSkills)
    {
        skill.isLearning = TRUE;
        skill.isComplete = NO;
    }
    
    [self scheduleLearningNotification];
    
    [_glitchedClient performSelector:@selector(getSkillsAvailable) withObject:nil afterDelay:SKILL_FETCH_DELAY];

}

- (void)glitchedClient:(GlitchedClient *)client receivedSkillsAvailable:(NSDictionary *)result
{
    NSLog(@"Skills: glitchedClient:receivedSkillsAvailable called");
    
    self.availableSkillsResult = [NSDictionary dictionaryWithDictionary:result];
    self.availableSkills = [self sortItems:[self extractItemsFromResult:result itemsKey:@"skills"]];
    for (GLSkill *skill in _availableSkills)
    {
        skill.isLearning = NO;
        skill.isComplete = NO;
    }
    
    [_glitchedClient performSelector:@selector(getSkillsLearned) withObject:nil afterDelay:SKILL_FETCH_DELAY];
}

- (void)glitchedClient:(GlitchedClient *)client receivedSkillsLearned:(NSDictionary *)result
{
    NSLog(@"Skills: glitchedClient:receivedSkillsLearned called");
    
    self.learnedSkillsResult = [NSDictionary dictionaryWithDictionary:result];
    self.learnedSkills = [self sortItems:[self extractItemsFromResult:result itemsKey:@"skills"]];
    for (GLSkill *skill in _learnedSkills)
    {
        skill.isLearning = NO;
        skill.isComplete = YES;
    }
    
    self.isRefreshNeeded = NO;
    [self refresh:nil];
}

#pragma mark - Skill View Delegate Methods

- (void)skillLearningBegan:(GLSkill *)skill
{
    self.learningSkills = [NSArray arrayWithObjects:skill, nil];

    [self setData:skill forRow:0 inSection:0];
    [self refreshCellForRow:0 inSection:0];

    self.isRefreshNeeded = YES;
}

#pragma mark - Utilities

- (NSArray *)extractItemsFromResult:(NSDictionary *)result
{
    return [self extractItemsFromResult:result itemsKey:@"items"];
}

- (NSArray *)extractItemsFromResult:(NSDictionary *)result itemsKey:(NSString *)itemsKey
{
    NSMutableArray *itemsArray = [NSMutableArray array];
    
    if (!itemsKey)
        itemsKey = @"items";
    NSDictionary *items = [result objectForKey:itemsKey];
    if ([items isKindOfClass:[NSDictionary class]])
    {
        NSEnumerator *enumerator = [items keyEnumerator];
        NSString *key;
        while (key = [enumerator nextObject])
        {
            NSDictionary *item = [items objectForKey:key];
            GLSkill *s = [[GLSkill alloc] init];
            s.skillId = key;
            s.name = [item objectForKey:@"name"];
            s.description = [item objectForKey:@"description"];
            s.url = [item objectForKey:@"url"];
            s.icon44 = [item objectForKey:@"icon_44"];
            s.icon100 = [item objectForKey:@"icon_100"];
            s.icon460 = [item objectForKey:@"icon_460"];
            s.totalTime = [item objectForKey:@"total_time"];
            s.timeStart = [item objectForKey:@"time_start"];
            s.timeComplete = [item objectForKey:@"time_complete"];
            s.timeRemaining = [item objectForKey:@"time_remaining"];
            s.requiredLevel = [item objectForKey:@"required_level"];
            [itemsArray addObject:s];
            [s release];
        }
    }
    return itemsArray;
}

- (NSArray *)sortItems:(NSArray *)items
{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"name"
                                                  ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [items sortedArrayUsingDescriptors:sortDescriptors];
    return sortedArray;
}

- (void)scheduleLearningNotification
{
    GlitchedAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate cancelAllLocalNotifications];
    
    if (_learningSkills && [_learningSkills count] > 0)
    {
        GLSkill *learningSkill = [_learningSkills objectAtIndex:0];
        [appDelegate scheduleLearningNotification:learningSkill];
    }
    else
    {
        NSLog(@"Skills: Schedule Notification: No skills currently learning, skipping scheduling.");
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!_glitchedClient)
    {
        _glitchedClient = [[GlitchedClient alloc] init];
        _glitchedClient.delegate = self;
        [_glitchedClient authorize];
    }
    
    self.isRefreshNeeded = NO;
    self.useCustomHeaders = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
        
    if (self.isRefreshNeeded)
    {
        [self refreshButtonPressed:nil];
    }
}

- (void)loadView
{
    GradientBackgroundTable *aTableView =
    [[[GradientBackgroundTable alloc]
      initWithFrame:CGRectZero
      style:UITableViewStyleGrouped]
     autorelease];
	
	self.view = aTableView;
	self.tableView = aTableView;
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