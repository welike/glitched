//
//  GLSkill.h
//  Glitched
//
//  Created by Kevin Elliott on 10/5/11.
//  Copyright (c) 2011 WeLike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLSkill : NSObject
{
    NSString *_skillId;
    NSString *_name;
    NSString *_description;
    NSString *_url;
    NSString *_icon44;
    NSString *_icon100;
    NSString *_icon460;
    NSNumber *_totalTime;
    NSNumber *_timeStart;
    NSNumber *_timeComplete;
    NSNumber *_timeRemaining;
    NSNumber *_requiredLevel;
    BOOL _isLearning;
    BOOL _isComplete;
}

@property (nonatomic, retain) NSString *skillId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *icon44;
@property (nonatomic, retain) NSString *icon100;
@property (nonatomic, retain) NSString *icon460;
@property (nonatomic, retain) NSNumber *totalTime;
@property (nonatomic, retain) NSNumber *timeStart;
@property (nonatomic, retain) NSNumber *timeComplete;
@property (nonatomic, retain) NSNumber *timeRemaining;
@property (nonatomic, retain) NSNumber *requiredLevel;
@property (readwrite) BOOL isLearning;
@property (readwrite) BOOL isComplete;

- (NSString *)friendlyTimeRemaining;

@end
