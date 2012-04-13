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


#import <UIKit/UIKit.h>

#import "GlitchedAppDelegate.h"
#import "Glitch.h"
#import "EGOImageView.h"
#import "GlitchedClient.h"
#import "InfoViewController.h"
#import "UIImageView+NotRootBeer.h"

#define FETCH_TIMER_INTERVAL 5

@interface SampleViewController : UIViewController <GlitchedClientDelegate, InfoViewDelegate> {
    Glitch *_glitch;
    GlitchedClient *_glitchedClient;
    NSTimer *_fetchTimer;
    NSString *_playerTsid;
    NSDictionary *_avatarPackage;
    BOOL _authorized;
    NSCache *_streetInfoCache;
    
    IBOutlet UILabel *_userNameLabel;
    IBOutlet UILabel *_locationLabel;
    IBOutlet UILabel *_levelLabel;
    IBOutlet UILabel *_xpLabel;
    IBOutlet UILabel *_xpMaxLabel;
    IBOutlet UILabel *_currantsLabel;
    IBOutlet UILabel *_energyLabel;
    IBOutlet UILabel *_energyMaxLabel;
    IBOutlet UILabel *_moodLabel;
    IBOutlet UILabel *_moodMaxLabel;
    IBOutlet EGOImageView *_avatarImageView;
}


@property (nonatomic, retain) Glitch *glitch;
@property (nonatomic, retain) GlitchedClient *glitchedClient;
@property (nonatomic, retain) NSTimer *_fetchTimer;
@property (nonatomic, retain) NSString *_playerTsid;
@property (nonatomic, retain) NSDictionary *_avatarPackage;
@property (readwrite) BOOL _authorized;
@property (nonatomic, retain) NSCache *_streetInfoCache;

- (UIImage *)getImage:(NSString *)imageUrl;
- (NSArray *)chopSpriteSheet:(UIImage *)spriteSheet columns:(int)columns rows:(int)rows;
- (NSDictionary *)buildSpriteIndexForSpriteSheet:(NSDictionary *)sheet;
- (NSDictionary *)buildSpriteIndexPackageUsingResult:(NSDictionary *)results;
- (NSArray *)buildAnimation:(NSDictionary *)animation spriteIndexPackage:(NSDictionary *)spriteIndexPackage;
- (NSDictionary *)buildAnimationPackageUsingResult:(NSDictionary *)result spriteIndexPackage:(NSDictionary *)spriteIndexPackage;
- (NSDictionary *)buildAvatarPackageUsingResult:(NSDictionary *)result;

- (void)playAnimation:(NSString *)animationName onImageView:(UIImageView *)imageView;
- (void)playRandomIdleAnimationOnImageView:(UIImageView *)imageView;
- (NSString *)randomIdleAnimationName;

- (void)updateStreet:(NSDictionary *)streetInfoResult;
- (IBAction)launchFeedback;
- (IBAction)infoButtonPressed;
- (void)showErrorForResult:(NSDictionary *)result errorMessage:(NSString *)errorMessage title:(NSString *)title;
- (void)showErrorForResult:(NSDictionary *)result errorMessage:(NSString *)errorMessage;

- (NSDictionary *)searchStreetInfoCache:(NSString *)streetTsid;
- (void)cacheStreetInfoResult:(NSDictionary *)result;

- (void)clearContentLabels;

@end
