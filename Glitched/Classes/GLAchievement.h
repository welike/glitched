//
//  GLAchievement.h
//  Glitched
//
//  Created by Kevin Elliott on 10/5/11.
//  Copyright (c) 2011 WeLike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLAchievement : NSObject
{
    NSString *_achievementId;
    NSString *_name;
    NSString *_description;
    NSString *_url;
    NSString *_image60;
    NSString *_image180;
}

@property (nonatomic, retain) NSString *achievementId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *image60;
@property (nonatomic, retain) NSString *image180;

@end
