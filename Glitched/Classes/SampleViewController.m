/*-
 *  Glitch iOS SDK Sample App
 *  
 *  Copyright 2011 Tiny Speck, Inc.
 *  Created by Brady Archambo.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License. 
 *
 *  See more about Glitch at http://www.glitch.com
 *  http://www.tinyspeck.com
 */


#import "SampleViewController.h"
#import "InfoViewController.h"

@implementation SampleViewController


@synthesize glitch = _glitch;
@synthesize glitchedClient = _glitchedClient;
@synthesize _fetchTimer, _playerTsid, _avatarPackage;
@synthesize _authorized, _streetInfoCache;

#pragma mark - Glitch Requests

- (void)fetchTimerTriggered
{
    NSLog(@"========================================================");
    NSLog(@"Fetch timer was triggered...");
    
    [self playAnimation:@"walk1x" onImageView:_avatarImageView];                
    [_glitchedClient getPlayerFullInfo:self._playerTsid];
}

#pragma mark - Glitched Client Delegate

- (void)glitchedClient:(GlitchedClient *)client receivedLocationsStreetInfo:(NSDictionary *)result
{
    [self updateStreet:result];
    [self playRandomIdleAnimationOnImageView:_avatarImageView];
}

- (void)glitchedClient:(GlitchedClient *)client receivedPlayerInfo:(NSDictionary *)result
{
    id user_name = [(NSDictionary *)result objectForKey:@"user_name"];
    id player_name = [(NSDictionary*)result objectForKey:@"player_name"];
    id player_tsid = [(NSDictionary *)result objectForKey:@"player_tsid"];
    id avatar_url = [(NSDictionary *)result objectForKey:@"avatar_url"];
    
    if (player_name && [player_name isKindOfClass:[NSString class]])
    {
        _userNameLabel.text = [NSString stringWithFormat:@"%@", player_name];
        
    }
    
    self._playerTsid = [NSString stringWithFormat:@"%@", player_tsid];
    [_glitchedClient getPlayerFullInfo:player_tsid];
    [_glitchedClient getPlayerAnimations:player_tsid];
    
    if (self._fetchTimer)
    {
        [self._fetchTimer release];
        self._fetchTimer = nil;
    }
    self._fetchTimer = [NSTimer scheduledTimerWithTimeInterval:FETCH_TIMER_INTERVAL target:self selector:@selector(fetchTimerTriggered) userInfo:nil repeats:YES];
}

- (void)glitchedClient:(GlitchedClient *)client receivedPlayerStats:(NSDictionary *)result
{
    id level = [(NSDictionary *)result objectForKey:@"level"];
    id xp = [(NSDictionary *)result objectForKey:@"xp"];
    id xpMax = [(NSDictionary *)result objectForKey:@"xp_max"];
    id currants = [(NSDictionary *)result objectForKey:@"currants"];
    id energy = [(NSDictionary *)result objectForKey:@"energy"];
    id energyMax = [(NSDictionary *)result objectForKey:@"energy_max"];
    id mood = [(NSDictionary *)result objectForKey:@"mood"];
    id moodMax = [(NSDictionary *)result objectForKey:@"mood_max"];
    
    if (level && [level isKindOfClass:[NSNumber class]])
    {
        _levelLabel.text = [NSString stringWithFormat:@"%@", level];
        _currantsLabel.text = [NSString stringWithFormat:@"%@", currants];
        _xpLabel.text = [NSString stringWithFormat:@"%@", xp];
        _xpMaxLabel.text = [NSString stringWithFormat:@"%@", xpMax];
        _energyLabel.text = [NSString stringWithFormat:@"%@", energy];
        _energyMaxLabel.text = [NSString stringWithFormat:@"%@", energyMax];
        _moodLabel.text = [NSString stringWithFormat:@"%@", mood];
        _moodMaxLabel.text = [NSString stringWithFormat:@"%@", moodMax];
    }
}

- (void)glitchedClient:(GlitchedClient *)client receivedPlayerFullInfo:(NSDictionary *)result
{
    id isOnline = [(NSDictionary *)result objectForKey:@"is_online"];
    id lastOnline = [(NSDictionary *)result objectForKey:@"last_online"];
    
    id location = [(NSDictionary *)result objectForKey:@"location"];
    id locationTsid = [(NSDictionary *)location objectForKey:@"tsid"];
    id locationName = [(NSDictionary *)location objectForKey:@"name"];
    
    id stats = [(NSDictionary *)result objectForKey:@"stats"];
    id level = [(NSDictionary *)stats objectForKey:@"level"];
    id xp = [(NSDictionary *)stats objectForKey:@"xp"];
    id xpMax = [(NSDictionary *)stats objectForKey:@"xp_max"];
    id currants = [(NSDictionary *)stats objectForKey:@"currants"];
    id energy = [(NSDictionary *)stats objectForKey:@"energy"];
    id energyMax = [(NSDictionary *)stats objectForKey:@"energy_max"];
    id mood = [(NSDictionary *)stats objectForKey:@"mood"];
    id moodMax = [(NSDictionary *)stats objectForKey:@"mood_max"];
    
    if (level && [level isKindOfClass:[NSNumber class]])
    {
        _levelLabel.text = [NSString stringWithFormat:@"%@", level];
        _currantsLabel.text = [NSString stringWithFormat:@"%@", currants];
        _xpLabel.text = [NSString stringWithFormat:@"%@", xp];
        _xpMaxLabel.text = [NSString stringWithFormat:@"%@", xpMax];
        _energyLabel.text = [NSString stringWithFormat:@"%@", energy];
        _energyMaxLabel.text = [NSString stringWithFormat:@"%@", energyMax];
        _moodLabel.text = [NSString stringWithFormat:@"%@", mood];
        _moodMaxLabel.text = [NSString stringWithFormat:@"%@", moodMax];
    }
    
    NSLog(@"Querying for streetInfo (tsid: %@)", locationTsid);
    NSDictionary *cachedStreetInfoResult = [_glitchedClient searchStreetInfoCache:(NSString *)locationTsid];
    if (cachedStreetInfoResult != nil)
    {
        NSLog(@"Cache hit, found streetInfo.");
        [self updateStreet:cachedStreetInfoResult];
        [self playRandomIdleAnimationOnImageView:_avatarImageView];
    }
    else
    {
        NSLog(@"Need to ask Glitch.");
        [_glitchedClient getLocationsStreetInfo:locationTsid];
    }
}

- (void)glitchedClient:(GlitchedClient *)client receivedPlayerAnimations:(NSDictionary *)result
{
    self._avatarPackage = [self buildAvatarPackageUsingResult:result];
    [self playAnimation:@"happy" onImageView:_avatarImageView];
}

- (void)glitchedClient:(GlitchedClient *)client authorizationSuccessful:(BOOL)successful
{
    // Now let's load up our walking avatar (if we already have it)
    [self playAnimation:@"walk1x" onImageView:_avatarImageView];                

    [_glitchedClient getPlayerInfo];
}

- (void)glitchedClient:(GlitchedClient *)client requestFailed:(NSDictionary *)result errorMessage:(NSString *)errorMessage
{
    // Let's play the angry avatar animation, because we have an error!
    [self playAnimation:@"angry" onImageView:_avatarImageView];
    
    [self showErrorForResult:result errorMessage:errorMessage];
}

#pragma mark - Glitch Animatations

- (void)playAnimation:(NSString *)animationName onImageView:(UIImageView *)imageView
{
    if ([imageView isAnimating])
    {
        [imageView stopAnimating];
        NSLog(@"Stopped previous animation.");
    }
    
    if (_avatarPackage && [_avatarPackage objectForKey:@"animationPackage"])
    {
        NSLog(@"Playing animation '%@'...", animationName);
        NSDictionary *animations = [_avatarPackage objectForKey:@"animationPackage"];
        imageView.animationImages = [animations objectForKey:animationName];
        imageView.animationRepeatCount = 0;
        
        [imageView startAnimating];
    }
}

- (void)playRandomIdleAnimationOnImageView:(UIImageView *)imageView
{
    [self playAnimation:[self randomIdleAnimationName] onImageView:imageView];
}

- (NSString *)randomIdleAnimationName
{
    NSArray *idleAnimations = [NSArray arrayWithObjects:@"idle1", 
                               @"idle2",
                               @"idle3",
                               @"idle4",
                               @"idle4",
                               @"idle4",
                               @"idle4",
                               @"idle4",
                               nil];
    NSUInteger randomIndex = arc4random() % [idleAnimations count];
    return [idleAnimations objectAtIndex:randomIndex];
}

#pragma mark - Sprite Utilities

- (UIImage *)getImage:(NSString *)imageUrl
{
    NSLog(@"Retrieving image from %@...", imageUrl);
    return [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
}

- (NSDictionary *)buildSpriteIndexForSpriteSheet:(NSDictionary *)sheet
{
    NSMutableDictionary *spriteIndex = [NSMutableDictionary dictionary];
    
    id columns = [sheet objectForKey:@"cols"];
    id rows = [sheet objectForKey:@"rows"];
    id frames = [sheet objectForKey:@"frames"];
    id url = [sheet objectForKey:@"url"];
    
    UIImage *spriteSheetImage = [self getImage:url];
    NSArray *rawFrameArray = [UIImageView chopSpriteSheet:spriteSheetImage columns:[columns intValue] rows:[rows intValue]];
    for (int i=0; i<[frames count]; i++) {
        //NSLog(@"Sprite: Frame %d has ID %@", i, [(NSArray *)frames objectAtIndex:i]);
        [spriteIndex setObject:[rawFrameArray objectAtIndex:i] forKey:[(NSArray *)frames objectAtIndex:i]];
    }
    
    return spriteIndex;
}

- (NSDictionary *)buildSpriteIndexPackageUsingResult:(NSDictionary *)result
{
    NSMutableDictionary *indexPackage = [NSMutableDictionary dictionary];

    id sheets = [result objectForKey:@"sheets"];
    
    NSArray *sheetKeys = [sheets allKeys];
    for (int i=0; i<[sheetKeys count]; i++)
    {
        NSDictionary *sheet = [sheets objectForKey:[sheetKeys objectAtIndex:i]];
        NSLog(@"Sheet: Adding '%@' to index...", [sheetKeys objectAtIndex:i]);
        NSDictionary *spriteIndex = [self buildSpriteIndexForSpriteSheet:sheet];
        [indexPackage addEntriesFromDictionary:spriteIndex];
    }
    
    return indexPackage;
}

- (NSArray *)buildAnimation:(NSDictionary *)animation spriteIndexPackage:(NSDictionary *)spriteIndexPackage
{    
    NSMutableArray *animatedFrames = [NSMutableArray array];
    for (int i=0; i<[animation count]; i++) {
        //NSLog(@"Animation: Frame %d uses Sprite Frame ID %@", i, [(NSArray *)animation objectAtIndex:i]);
        [animatedFrames addObject:[spriteIndexPackage objectForKey:[(NSArray *)animation objectAtIndex:i]]];
    }
    
    return animatedFrames;
}

- (NSDictionary *)buildAnimationPackageUsingResult:(NSDictionary *)result spriteIndexPackage:(NSDictionary *)spriteIndexPackage
{
    NSMutableDictionary *animationPackage = [NSMutableDictionary dictionary];

    id anims = [result objectForKey:@"anims"];

    NSArray *animKeys = [anims allKeys];
    for (int i=0; i<[animKeys count]; i++)
    {
        NSDictionary *anim = [anims objectForKey:[animKeys objectAtIndex:i]];
        NSLog(@"Animation: Building '%@'...", [animKeys objectAtIndex:i]);
        NSArray *animation = [self buildAnimation:anim spriteIndexPackage:spriteIndexPackage];
        [animationPackage setObject:animation forKey:[animKeys objectAtIndex:i]];
    }
    
    return animationPackage;
}

- (NSDictionary *)buildAvatarPackageUsingResult:(NSDictionary *)result
{
    NSMutableDictionary *avatarPackage = [NSMutableDictionary dictionary];
    
    NSDictionary *spriteIndexPackage = [self buildSpriteIndexPackageUsingResult:result];
    NSDictionary *animationPackage = [self buildAnimationPackageUsingResult:result spriteIndexPackage:spriteIndexPackage];
    
    [avatarPackage setObject:spriteIndexPackage forKey:@"spriteIndexPackage"];
    [avatarPackage setObject:animationPackage forKey:@"animationPackage"];
        
    return avatarPackage;
}

#pragma mark - UI Actions

- (void)updateStreet:(NSDictionary *)streetInfoResult
{
    NSString *streetName = [streetInfoResult objectForKey:@"name"];
    
    NSDictionary *hub = [streetInfoResult objectForKey:@"hub"];
    NSString *hubName = [hub objectForKey:@"name"];
    
    if (streetName && [streetName isKindOfClass:[NSString class]])
    {
        _locationLabel.text = [NSString stringWithFormat:@"%@, %@", hubName, streetName];
    }
    else
    {
        _locationLabel.text = @"Unknown Location";
    }
}

- (IBAction)launchFeedback
{
    [TestFlight openFeedbackView];
}

- (IBAction)infoButtonPressed
{
    InfoViewController *ivc = [[InfoViewController alloc] initWithNibName:@"InfoView" bundle:nil];
    ivc.modalPresentationStyle = UIModalPresentationFormSheet;
    ivc.delegate = self;
    [self presentModalViewController:ivc animated:YES];
    [ivc release];
}

- (void)showErrorForResult:(NSDictionary *)result errorMessage:(NSString *)errorMessage title:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
                                                    message:errorMessage
                                                   delegate:self
                                          cancelButtonTitle:@"Shucks!"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    
    if (result)
    {
        if ([result objectForKey:@"required_scope"] != nil)
        {
            NSLog(@"Error: %@, '%@' is necessary", [result objectForKey:@"error"], [result objectForKey:@"required_scope"]);
        }
        else
        {
            NSLog(@"Error: %@", [result objectForKey:@"error"]);
        }
    }
}

- (void)showErrorForResult:(NSDictionary *)result errorMessage:(NSString *)errorMessage
{
    [self showErrorForResult:result errorMessage:errorMessage title:@"Oops!"];
}

#pragma mark - View lifecycle

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _glitch = [[Glitch alloc] initWithDelegate:self];
        _glitchedClient = [[GlitchedClient alloc] init];
        _glitchedClient.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [self clearContentLabels];
}

- (void)viewWillAppear:(BOOL)animated
{
}

- (void)viewDidAppear:(BOOL)animated
{
    [_glitchedClient authorize];
}

- (void)clearContentLabels
{
    _userNameLabel.text = @"";
    _locationLabel.text = @"";
    _levelLabel.text = @"";
    _xpLabel.text = @"";
    _xpMaxLabel.text = @"";
    _currantsLabel.text = @"";
    _energyLabel.text = @"";
    _energyMaxLabel.text = @"";
    _moodLabel.text = @"";
    _moodMaxLabel.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [self._streetInfoCache removeAllObjects];
}

- (void)dealloc
{
    [_glitch release];
    
    [_userNameLabel release];
    [_locationLabel release];
    [_levelLabel release];
    [_xpLabel release];
    [_xpMaxLabel release];
    [_currantsLabel release];
    [_energyLabel release];
    [_energyMaxLabel release];
    [_moodLabel release];
    [_moodMaxLabel release];
    [_avatarImageView release];
    [super dealloc];
}


- (void)viewDidUnload
{
    [_userNameLabel release];
    _userNameLabel = nil;
    [_locationLabel release];
    _locationLabel = nil;
    [_levelLabel release];
    _levelLabel = nil;
    [_xpLabel release];
    _xpLabel = nil;
    [_xpMaxLabel release];
    _xpMaxLabel = nil;
    [_currantsLabel release];
    _currantsLabel = nil;
    [_energyLabel release];
    _energyLabel = nil;
    [_energyMaxLabel release];
    _energyMaxLabel = nil;
    [_moodLabel release];
    _moodLabel = nil;
    [_avatarImageView release];
    _avatarImageView = nil;
    
    [super viewDidUnload];
}

@end
