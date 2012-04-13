//
//  CustomTabBarItem.h
//  Mused
//
//  Created by Kevin Elliott on 5/10/11.
//  Copyright 2011 WeLike, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabBarItem : UITabBarItem    {
    UIImage *customHighlightedImage;
    UIImage *customStdImage;
}

@property (nonatomic, retain) UIImage *customHighlightedImage;
@property (nonatomic, retain) UIImage *customStdImage;

@end
