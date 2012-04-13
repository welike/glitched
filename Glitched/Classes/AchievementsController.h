//
//  AchievementsController.h
//  Glitched
//
//  Created by Kevin Elliott on 10/4/11.
//  Copyright (c) 2011 WeLike. All rights reserved.
//

#import "PageViewController.h"
#import "GlitchedClient.h"
#import "AchievementViewController.h"

@interface AchievementsController : PageViewController <GlitchedClientDelegate>
{
    GlitchedClient *_glitchedClient;
    NSDictionary *_achievementsResult;
    NSArray *_achievements;
    NSCache *_achievementCache;
}

@property (nonatomic, retain) GlitchedClient *glitchedClient;
@property (nonatomic, retain) NSDictionary *achievementsResult;
@property (nonatomic, retain) NSArray *achievements;
@property (nonatomic, retain) NSCache *achievementCache;

- (NSArray *)extractItemsFromResult:(NSDictionary *)result;
- (NSArray *)sortItems:(NSArray *)items;
@end
