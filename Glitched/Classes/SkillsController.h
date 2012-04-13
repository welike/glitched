//
//  SkillsController.h
//  Glitched
//
//  Created by Kevin Elliott on 10/5/11.
//  Copyright (c) 2011 WeLike. All rights reserved.
//

#import "PageViewController.h"
#import "GlitchedClient.h"
#import "SkillViewController.h"

#define SKILL_FETCH_DELAY 0.25

@interface SkillsController : PageViewController <GlitchedClientDelegate, SkillViewDelegate>
{    
    GlitchedClient *_glitchedClient;
    NSDictionary *_allSkillsResult;
    NSDictionary *_availableSkillsResult;
    NSDictionary *_LearnedSkillsResult;
    NSDictionary *_LearningSkillsResult;
    NSArray *_allSkills;
    NSArray *_availableSkills;
    NSArray *_learnedSkills;
    NSArray *_learningSkills;
    NSCache *_skillCache;
    BOOL _isRefreshNeeded;
}

@property (nonatomic, retain) GlitchedClient *glitchedClient;
@property (nonatomic, retain) NSDictionary *allSkillsResult;
@property (nonatomic, retain) NSDictionary *availableSkillsResult;
@property (nonatomic, retain) NSDictionary *learnedSkillsResult;
@property (nonatomic, retain) NSDictionary *learningSkillsResult;
@property (nonatomic, retain) NSArray *allSkills;
@property (nonatomic, retain) NSArray *availableSkills;
@property (nonatomic, retain) NSArray *learnedSkills;
@property (nonatomic, retain) NSArray *learningSkills;
@property (nonatomic, retain) NSCache *skillCache;
@property (readwrite) BOOL isRefreshNeeded;

- (NSArray *)extractItemsFromResult:(NSDictionary *)result;
- (NSArray *)extractItemsFromResult:(NSDictionary *)result itemsKey:(NSString *)itemsKey;
- (NSArray *)sortItems:(NSArray *)items;
- (void)scheduleLearningNotification;

@end
