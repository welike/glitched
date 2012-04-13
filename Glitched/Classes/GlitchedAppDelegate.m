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


#import "GlitchedAppDelegate.h"

#import "SampleViewController.h"
#import "GLSkill.h"

@implementation GlitchedAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [TestFlight takeOff:@"80028ba59d621b0fe8c8f50ea410df52_MjIxMg"];

    // Local Notifications
    Class cls = NSClassFromString(@"UILocalNotification");
    if (cls) {
        UILocalNotification *notification = [launchOptions objectForKey:
                                             UIApplicationLaunchOptionsLocalNotificationKey];
        
        if (notification) {
            NSString *learningSkillId = [notification.userInfo 
                                      objectForKey:@"learningSkillId"];
            NSLog(@"GlitchedAppDelegate: Local notification for skill (%@) executed when app was not running, switching to skills tab...", learningSkillId);
            [self.tabBarController setSelectedIndex:3];
        }
    }
    application.applicationIconBadgeNumber = 0;
    
    // Show window
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [[_viewController glitch] handleOpenURL:url];
    
    return YES;
}

#pragma mark - Notifications

- (void)application:(UIApplication *)application 
didReceiveLocalNotification:(UILocalNotification *)notification
{
    application.applicationIconBadgeNumber = 0;
    NSString *learningSkillId = [notification.userInfo
                                 objectForKey:@"learningSkillId"];

    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateInactive) {
        
        // Application was in the background when notification
        // was delivered.
        NSLog(@"GlitchedAppDelegate: Local notification for skill (%@) executed while application was running, switching to skills tab...", learningSkillId);
    }
    else
    {
        // Application was in the background
        NSLog(@"GlitchedAppDelegate: Local notification for skill (%@) executed while application was running in background, switching to skills tab...", learningSkillId);
    }
    [self.tabBarController setSelectedIndex:3];
}

- (void)cancelAllLocalNotifications
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];    
}

- (void)scheduleLearningNotification:(GLSkill *)skill
{
    
    Class cls = NSClassFromString(@"UILocalNotification");
    if (cls != nil)
    {
        UILocalNotification *notif = [[cls alloc] init];
        notif.fireDate = [NSDate dateWithTimeIntervalSinceNow:[skill.timeRemaining intValue]];
        notif.timeZone = [NSTimeZone defaultTimeZone];
            
        notif.alertBody = [NSString stringWithFormat:@"Learning '%@' is complete!", skill.name];
        notif.alertAction = @"Show me";
        notif.soundName = UILocalNotificationDefaultSoundName;
        notif.applicationIconBadgeNumber = 1;
            
        NSDictionary *userDict = [NSDictionary dictionaryWithObject:skill.skillId 
                                                             forKey:@"learningSkillId"];
        notif.userInfo = userDict;
            
        [[UIApplication sharedApplication] scheduleLocalNotification:notif];
        [notif release];
    }
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

@end
