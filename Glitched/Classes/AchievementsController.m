//
//  AchievementsController.m
//  Glitched
//
//  Created by Kevin Elliott on 10/4/11.
//  Copyright (c) 2011 WeLike. All rights reserved.
//

#import "AchievementsController.h"
#import "GradientBackgroundTable.h"
#import "GLAchievementCell.h"
#import "GLAchievement.h"

@class AchievementViewController;

@implementation AchievementsController

@synthesize glitchedClient = _glitchedClient;
@synthesize achievementsResult = _achievementsResult;
@synthesize achievements = _achievements;
@synthesize achievementCache = _achievementCache;

- (NSString *)title
{
    return NSLocalizedString(@"Achievements", @"");
}

- (void)createRows
{
    [self addSectionAtIndex:0 withAnimation:UITableViewRowAnimationFade];
    if (_achievements)
    {
        for (GLAchievement *item in _achievements) 
        {
            [self appendRowToSection:0
                           cellClass:[GLAchievementCell class] 
                            cellData:item
                       withAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    
    [self hideLoadingIndicator];
}

- (void)refresh:(id)sender
{
    [self removeAllSectionsWithAnimation:UITableViewRowAnimationFade];
    [self performSelector:@selector(createRows) withObject:nil afterDelay:0.5];
    [self showLoadingIndicator];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    GLAchievement *achievement = [_achievements objectAtIndex:row];

    if (achievement)
    {
        AchievementViewController *achievementViewController = [[AchievementViewController alloc] initWithNibName:@"AchievementView" bundle:nil];
        achievementViewController.achievement = achievement;
        [self.navigationController pushViewController:achievementViewController animated:YES];
        [achievementViewController release];
    }
}

#pragma mark - Glitched Client Delegate

- (void)glitchedClient:(GlitchedClient *)client authorizationSuccessful:(BOOL)successful
{
    NSLog(@"Achievements: glitchedClient:authorizationSuccessful called");

    [_glitchedClient getAchievements];
}

- (void)glitchedClient:(GlitchedClient *)client receivedPlayerInfo:(NSDictionary *)result
{
    NSLog(@"Achievements: glitchedClient:receivedPlayerInfo called");
}

- (void)glitchedClient:(GlitchedClient *)client receivedAchievements:(NSDictionary *)result
{
    NSLog(@"Achievements: glitchedClient:receivedAchievements called");

    self.achievementsResult = [NSDictionary dictionaryWithDictionary:result];
    self.achievements = [self sortItems:[self extractItemsFromResult:result]];
    
    [self refresh:nil];
}

#pragma mark - Utilities

- (NSArray *)extractItemsFromResult:(NSDictionary *)result
{
    NSMutableArray *itemsArray = [NSMutableArray array];
    
    NSDictionary *items = [_achievementsResult objectForKey:@"items"];
    NSEnumerator *enumerator = [items keyEnumerator];
    NSString *key;
    while (key = [enumerator nextObject])
    {
        NSDictionary *item = [items objectForKey:key];
        GLAchievement *a = [[GLAchievement alloc] init];
        a.achievementId = key;
        a.name = [item objectForKey:@"name"];
        a.description = [item objectForKey:@"desc"];
        a.url = [item objectForKey:@"url"];
        a.image60 = [item objectForKey:@"image_60"];
        a.image180 = [item objectForKey:@"image_180"];
        [itemsArray addObject:a];
        [a release];
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!_glitchedClient)
    {
        _glitchedClient = [[GlitchedClient alloc] init];
        _glitchedClient.delegate = self;
    }
    [_glitchedClient authorize];
    
    self.useCustomHeaders = NO;
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
