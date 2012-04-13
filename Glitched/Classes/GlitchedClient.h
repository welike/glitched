//
//  GlitchedClient.h
//  Glitched
//
//  Created by Kevin Elliott on 10/4/11.
//  Copyright (c) 2011 WeLike. All rights reserved.
//

#import "Glitch.h"

@protocol GlitchedClientDelegate;

@interface GlitchedClient : NSObject <GCSessionDelegate, GCRequestDelegate, NSCacheDelegate>
{
    id<GlitchedClientDelegate> _delegate;
    Glitch *_glitch;
    BOOL _authorized;

    NSDictionary *_avatarPackage;
    NSCache *_streetInfoCache;
}

@property (nonatomic, retain) id<GlitchedClientDelegate> delegate;
@property (nonatomic, retain) Glitch *glitch;
@property (readwrite)         BOOL authorized;
@property (nonatomic, retain) NSDictionary *avatarPackage;
@property (nonatomic, retain) NSCache *streetInfoCache;

- (void)authorize;
- (void)getAchievements;
- (void)getAchievements:(NSNumber *)page perPage:(NSNumber *)perPage;
- (void)getLocationsStreetInfo:(NSString *)streetTsid;
- (void)getPlayerAnimations:(NSString *)playerTsid;
- (void)getPlayerFullInfo:(NSString *)playerTsid;
- (void)getPlayerInfo;
- (void)getPlayerInventory;
- (void)getSkills;
- (void)getSkills:(NSNumber *)page perPage:(NSNumber *)perPage;
- (void)getSkillsAvailable;
- (void)getSkillsAvailable:(NSNumber *)page perPage:(NSNumber *)perPage;
- (void)getSkillsLearned;
- (void)getSkillsLearned:(NSNumber *)page perPage:(NSNumber *)perPage;
- (void)getSkillsLearning;
- (void)getSkillsLearning:(NSNumber *)page perPage:(NSNumber *)perPage;
- (void)learnSkill:(NSString *)skillId;

- (NSDictionary *)searchStreetInfoCache:(NSString *)streetTsid;
- (void)cacheStreetInfoResult:(NSDictionary *)result;

@end

@protocol GlitchedClientDelegate <NSObject>

@optional

- (void)glitchedClient:(GlitchedClient *)client authorizationSuccessful:(BOOL)successful;
- (void)glitchedClient:(GlitchedClient *)client authorizationFailed:(BOOL)failed;

- (void)glitchedClient:(GlitchedClient *)client receivedAchievements:(NSDictionary *)result;
- (void)glitchedClient:(GlitchedClient *)client receivedLocationsStreetInfo:(NSDictionary *)result;
- (void)glitchedClient:(GlitchedClient *)client receivedPlayerAnimations:(NSDictionary *)result;
- (void)glitchedClient:(GlitchedClient *)client receivedPlayerInfo:(NSDictionary *)result;
- (void)glitchedClient:(GlitchedClient *)client receivedPlayerInventory:(NSDictionary *)result;
- (void)glitchedClient:(GlitchedClient *)client receivedPlayerStats:(NSDictionary *)result;
- (void)glitchedClient:(GlitchedClient *)client receivedPlayerFullInfo:(NSDictionary *)result;
- (void)glitchedClient:(GlitchedClient *)client receivedSkills:(NSDictionary *)result;
- (void)glitchedClient:(GlitchedClient *)client receivedSkillsAvailable:(NSDictionary *)result;
- (void)glitchedClient:(GlitchedClient *)client receivedSkillLearnStatus:(NSDictionary *)result;
- (void)glitchedClient:(GlitchedClient *)client receivedSkillsLearned:(NSDictionary *)result;
- (void)glitchedClient:(GlitchedClient *)client receivedSkillsLearning:(NSDictionary *)result;

- (void)glitchedClient:(GlitchedClient *)client requestFailed:(NSDictionary *)result errorMessage:(NSString *)errorMessage;

@end