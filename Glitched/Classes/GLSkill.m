//
//  GLSkill.m
//  Glitched
//
//  Created by Kevin Elliott on 10/5/11.
//  Copyright (c) 2011 WeLike. All rights reserved.
//

#import "GLSkill.h"

@implementation GLSkill

@synthesize skillId = _skillId;
@synthesize name = _name;
@synthesize description = _description;
@synthesize url = _url;
@synthesize icon44 = _icon44;
@synthesize icon100 = _icon100;
@synthesize icon460 = _icon460;
@synthesize totalTime = _totalTime;
@synthesize timeStart = _timeStart;
@synthesize timeComplete = _timeComplete;
@synthesize timeRemaining = _timeRemaining;
@synthesize requiredLevel = _requiredLevel;
@synthesize isLearning = _isLearning;
@synthesize isComplete = _isComplete;

- (NSString *)friendlyTimeRemaining
{
    // Time Remaining
    int numSeconds = [self.timeRemaining intValue];
    int days = numSeconds / (60 * 60 * 24);
    numSeconds -= days * (60 * 60 * 24);
    int hours = numSeconds / (60 * 60);
    numSeconds -= hours * (60 * 60);
    int minutes = numSeconds / 60;
    numSeconds -= minutes * (60);
    int seconds = numSeconds;
    
    NSMutableArray *pieces = [NSMutableArray array];
    if (days > 0)
        [pieces addObject:[NSString stringWithFormat:@"%d days", days]];
    if (hours > 0)
        [pieces addObject:[NSString stringWithFormat:@"%d hours", hours]];
    if (minutes > 0)
        [pieces addObject:[NSString stringWithFormat:@"%d minutes", minutes]];
    if (seconds > 0)
        [pieces addObject:[NSString stringWithFormat:@"%d seconds", seconds]];
    
    return [pieces componentsJoinedByString:@", "];
}

@end
