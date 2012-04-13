//
//  CustomUITabBarController.h
//  Mused
//
//  Created by Kevin Elliott on 4/7/11.
//  Copyright 2011 WeLike, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <QuartzCore/QuartzCore.h>


@interface CustomUITabBarController : UITabBarController <UITabBarControllerDelegate> {
    IBOutlet UITabBar *tabBar1;
    UIImageView *tabBarArrow;
}

@property (nonatomic, retain) UITabBar *tabBar1;
@property (nonatomic, retain) UIImageView *tabBarArrow;

@end
