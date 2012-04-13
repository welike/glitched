//
//  GlitchedClient.m
//  Glitched
//
//  Created by Kevin Elliott on 10/4/11.
//  Copyright (c) 2011 WeLike. All rights reserved.
//

#import "GlitchedAppDelegate.h"
#import "GlitchedClient.h"

@implementation GlitchedClient

@synthesize delegate = _delegate;
@synthesize glitch = _glitch;
@synthesize authorized = _authorized;
@synthesize avatarPackage = _avatarPackage;
@synthesize streetInfoCache = _streetInfoCache;

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        _glitch = [[Glitch alloc] initWithDelegate:self];
        _authorized = [_glitch isAuthenticated];
        _streetInfoCache = [[NSCache alloc] init];
        _streetInfoCache.name = @"streetInfoCache";
        _streetInfoCache.delegate = self;
        [_streetInfoCache setTotalCostLimit: 50 * 1024 * 1024];
    }
    return self;
}

- (id)initWithGlitch:(Glitch *)glitch
{
    self = [super init];
    if (self)
    {
        _glitch = glitch;
        _authorized = [_glitch isAuthenticated];
        _streetInfoCache = [[NSCache alloc] init];
        _streetInfoCache.name = @"streetInfoCache";
        _streetInfoCache.delegate = self;
        [_streetInfoCache setTotalCostLimit: 50 * 1024 * 1024];
    }
    return self;
}

#pragma mark - Glitch Requests

- (void)authorize
{
    if (!_authorized)
    {
        NSLog(@"GlitchedClient: Authorizing...");
        [_glitch authorizeWithScope:@"write"];
        self.authorized = TRUE;
    }
}

- (void)getAchievements
{
    [self getAchievements:[NSNumber numberWithInteger:1] perPage:[NSNumber numberWithInteger:1000]];
}

- (void)getAchievements:(NSNumber *)page perPage:(NSNumber *)perPage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   page, @"page",
                                   perPage, @"per_page",
                                   nil];
    GCRequest *request = [_glitch requestWithMethod:@"achievements.listAll" 
                                           delegate:self 
                                             params:params];
    [request connect];
}

- (void)getLocationsStreetInfo:(NSString *)streetTsid
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   streetTsid, @"street_tsid",
                                   nil];
    GCRequest *request = [_glitch requestWithMethod:@"locations.streetInfo" 
                                           delegate:self 
                                             params:params];
    [request connect];
}

- (void)getPlayerAnimations:(NSString *)playerTsid
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   playerTsid, @"player_tsid",
                                   nil];
    GCRequest *request = [_glitch requestWithMethod:@"players.getAnimations" 
                                           delegate:self 
                                             params:params];
    [request connect];
}

- (void)getPlayerFullInfo:(NSString *)playerTsid
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   playerTsid, @"player_tsid",
                                   nil];
    GCRequest *request = [_glitch requestWithMethod:@"players.fullInfo" 
                                           delegate:self 
                                             params:params];
    [request connect];
}

- (void)getPlayerInfo
{
    GCRequest * request = [_glitch requestWithMethod:@"players.info" delegate:self];
    [request connect];
}

- (void)getPlayerInventory
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInteger:1], @"defs",
                                   nil];
    GCRequest *request = [_glitch requestWithMethod:@"players.inventory" 
                                           delegate:self 
                                             params:params];
    [request connect];
}

- (void)getSkills
{
    [self getSkills:[NSNumber numberWithInteger:1] perPage:[NSNumber numberWithInteger:1000]];
}

- (void)getSkills:(NSNumber *)page perPage:(NSNumber *)perPage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   page, @"page",
                                   perPage, @"per_page",
                                   nil];
    GCRequest *request = [_glitch requestWithMethod:@"skills.listAll" 
                                           delegate:self 
                                             params:params];
    [request connect];
}

- (void)getSkillsAvailable
{
    [self getSkillsAvailable:[NSNumber numberWithInteger:1] perPage:[NSNumber numberWithInteger:1000]];
}

- (void)getSkillsAvailable:(NSNumber *)page perPage:(NSNumber *)perPage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   page, @"page",
                                   perPage, @"per_page",
                                   nil];
    GCRequest *request = [_glitch requestWithMethod:@"skills.listAvailable" 
                                           delegate:self 
                                             params:params];
    [request connect];
}

- (void)getSkillsLearned
{
    [self getSkillsLearned:[NSNumber numberWithInteger:1] perPage:[NSNumber numberWithInteger:1000]];
}

- (void)getSkillsLearned:(NSNumber *)page perPage:(NSNumber *)perPage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   page, @"page",
                                   perPage, @"per_page",
                                   nil];
    GCRequest *request = [_glitch requestWithMethod:@"skills.listLearned" 
                                           delegate:self 
                                             params:params];
    [request connect];
}

- (void)getSkillsLearning
{
    [self getSkillsLearning:[NSNumber numberWithInteger:1] perPage:[NSNumber numberWithInteger:1000]];
}

- (void)getSkillsLearning:(NSNumber *)page perPage:(NSNumber *)perPage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   page, @"page",
                                   perPage, @"per_page",
                                   nil];
    GCRequest *request = [_glitch requestWithMethod:@"skills.listLearning" 
                                           delegate:self 
                                             params:params];
    [request connect];
}

- (void)learnSkill:(NSString *)skillId
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   skillId, @"skill_id",
                                   nil];
    GCRequest *request = [_glitch requestWithMethod:@"skills.learn" 
                                           delegate:self 
                                             params:params];
    [request connect]; 
}

#pragma mark - Glitch Login Delegate

// Called when login was successful
- (void)glitchLoginSuccess
{
    NSLog(@"GlitchedClient: Authorization successful.");
    [_delegate glitchedClient:self authorizationSuccessful:TRUE];
}

// Called when login fails
- (void)glitchLoginFail:(NSError *)error
{
    NSLog(@"GlitchedClient: Authorization failed.");
    [_delegate glitchedClient:self authorizationFailed:TRUE];
}

#pragma mark - Glitch Request Delegate

// Called when request was completed
- (void)requestFinished:(GCRequest*)request withResult:(id)result
{
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"API Result from '%@'", request.method]];
    
    // Validate we've got the right response

    if ([request.method isEqualToString:@"achievements.listAll"])
    {
        if ([result isKindOfClass:[NSDictionary class]])
        {
            id ok = [(NSDictionary *)result objectForKey:@"ok"];
            
            if (ok && [ok isKindOfClass:[NSNumber class]])
            {
                [_delegate glitchedClient:self receivedAchievements:result];
            }
            else
            {
                [_delegate glitchedClient:self requestFailed:result errorMessage:@"The API request for 'achievements.listAll' was not ok!"];
            }
        }
    }
    
    if ([request.method isEqualToString:@"locations.streetInfo"])
    {
        if ([result isKindOfClass:[NSDictionary class]])
        {
            id ok = [(NSDictionary *)result objectForKey:@"ok"];
            
            if (ok && [ok isKindOfClass:[NSNumber class]])
            {
                // Cache the streetInfo result so we can use it again
                [self cacheStreetInfoResult:result];
                [_delegate glitchedClient:self receivedLocationsStreetInfo:result];
            }
            else
            {
                [_delegate glitchedClient:self requestFailed:result errorMessage:@"The API request for 'players.streetInfo' was not ok!"];
            }
        }
    }
    
    if ([request.method isEqualToString:@"players.info"])
    {
        // Perform validation on the response
        if ([result isKindOfClass:[NSDictionary class]])
        {
            // Get the status of the auth token
            id ok = [(NSDictionary*)result objectForKey:@"ok"];
            
            // Ensure that we're ok before proceeding! (the ok number is 1)
            if (ok && [ok isKindOfClass:[NSNumber class]] && [(NSNumber*)ok boolValue])
            {
                [_delegate glitchedClient:self receivedPlayerInfo:result];
            }
            else
            {
                [_delegate glitchedClient:self requestFailed:result errorMessage:@"The API request for 'players.info' was not ok!"];
            }
        }
    }
    
    if ([request.method isEqualToString:@"players.fullInfo"])
    {
        if ([result isKindOfClass:[NSDictionary class]])
        {
            id ok = [(NSDictionary *)result objectForKey:@"ok"];
            
            if (ok && [ok isKindOfClass:[NSNumber class]])
            {
                [_delegate glitchedClient:self receivedPlayerFullInfo:result];
            }
            else
            {
                [_delegate glitchedClient:self requestFailed:result errorMessage:@"The API request for 'players.fullInfo' was not ok"];
            }
        }
    }
    
    if ([request.method isEqualToString:@"players.getAnimations"])
    {
        if ([result isKindOfClass:[NSDictionary class]])
        {
            id ok = [(NSDictionary *)result objectForKey:@"ok"];
            
            if (ok && [ok isKindOfClass:[NSNumber class]])
            {
                [_delegate glitchedClient:self receivedPlayerAnimations:result];
            }
            else
            {
                [_delegate glitchedClient:self requestFailed:result errorMessage:@"The API request for 'players.getAnimations' was not ok!"];
            }
        }
    }
    
    if ([request.method isEqualToString:@"players.inventory"])
    {
        if ([result isKindOfClass:[NSDictionary class]])
        {
            id ok = [(NSDictionary *)result objectForKey:@"ok"];
            
            if (ok && [ok isKindOfClass:[NSNumber class]])
            {
                [_delegate glitchedClient:self receivedPlayerInventory:result];
            }
            else
            {
                [_delegate glitchedClient:self requestFailed:result errorMessage:@"The API request for 'players.inventory' was not ok!"];
            }
        }
    }
    
    if ([request.method isEqualToString:@"players.stats"])
    {
        if ([result isKindOfClass:[NSDictionary class]])
        {
            id ok = [(NSDictionary *)result objectForKey:@"ok"];
            
            if (ok && [ok isKindOfClass:[NSNumber class]] && [(NSNumber *)ok boolValue])
            {
                [_delegate glitchedClient:self receivedPlayerStats:result];
            }
            else
            {
                [_delegate glitchedClient:self requestFailed:result errorMessage:@"The API request for 'players.stats' was not ok!"];
            }
        }
    }
 
    if ([request.method isEqualToString:@"skills.learn"])
    {
        if ([result isKindOfClass:[NSDictionary class]])
        {
            id ok = [(NSDictionary *)result objectForKey:@"ok"];
            
            if (ok && [ok isKindOfClass:[NSNumber class]])
            {
                [_delegate glitchedClient:self receivedSkillLearnStatus:result];
            }
            else
            {
                [_delegate glitchedClient:self requestFailed:result errorMessage:@"The API request for 'skills.learn' was not ok!"];
            }
        }
    }
    
    if ([request.method isEqualToString:@"skills.listAll"])
    {
        if ([result isKindOfClass:[NSDictionary class]])
        {
            id ok = [(NSDictionary *)result objectForKey:@"ok"];
            
            if (ok && [ok isKindOfClass:[NSNumber class]])
            {
                [_delegate glitchedClient:self receivedSkills:result];
            }
            else
            {
                [_delegate glitchedClient:self requestFailed:result errorMessage:@"The API request for 'skills.listAll' was not ok!"];
            }
        }
    }

    if ([request.method isEqualToString:@"skills.listAvailable"])
    {
        if ([result isKindOfClass:[NSDictionary class]])
        {
            id ok = [(NSDictionary *)result objectForKey:@"ok"];
            
            if (ok && [ok isKindOfClass:[NSNumber class]])
            {
                [_delegate glitchedClient:self receivedSkillsAvailable:result];
            }
            else
            {
                [_delegate glitchedClient:self requestFailed:result errorMessage:@"The API request for 'skills.listAvailable' was not ok!"];
            }
        }
    }

    if ([request.method isEqualToString:@"skills.listLearned"])
    {
        if ([result isKindOfClass:[NSDictionary class]])
        {
            id ok = [(NSDictionary *)result objectForKey:@"ok"];
            
            if (ok && [ok isKindOfClass:[NSNumber class]])
            {
                [_delegate glitchedClient:self receivedSkillsLearned:result];
            }
            else
            {
                [_delegate glitchedClient:self requestFailed:result errorMessage:@"The API request for 'skills.listLearned' was not ok!"];
            }
        }
    }
    
    if ([request.method isEqualToString:@"skills.listLearning"])
    {
        if ([result isKindOfClass:[NSDictionary class]])
        {
            id ok = [(NSDictionary *)result objectForKey:@"ok"];
            
            if (ok && [ok isKindOfClass:[NSNumber class]])
            {
                [_delegate glitchedClient:self receivedSkillsLearning:result];
            }
            else
            {
                [_delegate glitchedClient:self requestFailed:result errorMessage:@"The API request for 'skills.listLearning' was not ok!"];
            }
        }
    }
}


// Called when request fails
- (void)requestFailed:(GCRequest*)request withError:(NSError*)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" 
                                                    message:@"The API request failed!" 
                                                   delegate:self 
                                          cancelButtonTitle:@"Shucks!" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark - Caching

- (NSDictionary *)searchStreetInfoCache:(NSString *)streetTsid
{
    NSDictionary *streetInfo = nil;
    if (_streetInfoCache)
    {
        streetInfo = [_streetInfoCache objectForKey:streetTsid];
    }
    return streetInfo;
}

- (void)cacheStreetInfoResult:(NSDictionary *)result
{    
    NSString *key = [NSString stringWithFormat:@"%@", [result objectForKey:@"tsid"]];
    [_streetInfoCache setObject:result forKey:key];
    NSLog(@"GlitchedClient - StreetInfoCache: Cached streetInfo: %@ (key: %@)", [result objectForKey:@"name"], [result objectForKey:@"tsid"]); 
}

#pragma mark - NSCache Delegate Methods

- (void)cache:(NSCache *)cache willEvictObject:(id)obj
{
    if ([cache.name isEqualToString:@"streetInfoCache"])
    {
        NSLog(@"GlitchedClient - StreetInfoCache: Evicting a streetInfo: %@ (key: %@)", [(NSDictionary *)obj objectForKey:@"name"], [(NSDictionary *)obj objectForKey:@"tsid"]);
    }
    else
    {
        NSLog(@"GlitchedClient - StreetInfoCache: Evicting an object");
    }
}

@end
