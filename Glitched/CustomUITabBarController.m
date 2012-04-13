//
//  CustomUITabBarController.m
//  Mused
//
//  Created by Kevin Elliott on 4/7/11.
//  Copyright 2011 WeLike, LLC. All rights reserved.
//

#import "CustomUITabBarController.h"
#import "CustomTabBarItem.h"

@interface CustomUITabBarController (PrivateMethods)
- (CGFloat) horizontalLocationFor:(NSUInteger)tabIndex;
- (void) addTabBarArrow;
@end

@implementation CustomUITabBarController

@synthesize tabBar1, tabBarArrow;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tabBar1.backgroundColor = [UIColor clearColor];
    CGRect frame = CGRectMake(0, 0, 480, 49);
    UIView *v = [[UIView alloc] initWithFrame:frame];
    UIImage *i = [UIImage imageNamed:@"tabbar-bg.png"];
    UIColor *c = [[UIColor alloc] initWithPatternImage:i];
    v.backgroundColor = c;
    [c release];
    [[self tabBar] setClipsToBounds:NO];
    [[self tabBar] setBackgroundColor:[UIColor clearColor]];
    [[self tabBar] insertSubview:v atIndex:0];
    [v release];
    
    self.delegate = self;

    //[self addTabBarArrow];
}

- (void)viewDidAppear:(BOOL)animated
{
}

- (void)addTabBarArrow
{
    UIImage *tabBarArrowImage = [UIImage imageNamed:@"tab-pointer.png"];
    self.tabBarArrow = [[[UIImageView alloc] initWithImage:tabBarArrowImage] autorelease];
    // To get the vertical location we start at the bottom of the window, go up by height of the tab bar, go up again by the height of arrow and then come back down 2 pixels so the arrow is slightly on top of the tab bar.
    CGFloat verticalLocation = -6;
    self.tabBarArrow.frame = CGRectMake([self horizontalLocationFor:0], verticalLocation, tabBarArrowImage.size.width, tabBarArrowImage.size.height);
    NSLog(@"x = %f, y = %f, w = %f, h = %f", self.tabBarArrow.frame.origin.x, self.tabBarArrow.frame.origin.y, self.tabBarArrow.frame.size.width, self.tabBarArrow.frame.size.height);
    
    [self.tabBar addSubview:tabBarArrow];
}

- (CGFloat)horizontalLocationFor:(NSUInteger)tabIndex
{
    // A single tab item's width is the entire width of the tab bar divided by number of items
    CGFloat tabItemWidth = self.tabBar.frame.size.width / self.tabBar.items.count;
    // A half width is tabItemWidth divided by 2 minus half the width of the arrow
    CGFloat halfTabItemWidth = (tabItemWidth / 2.0) - (self.tabBarArrow.frame.size.width / 2.0);
    NSLog(@"tabItemWidth = %f, halfTabItemWidth = %f", tabItemWidth, halfTabItemWidth);
    // The horizontal location is the index times the width plus a half width
    return (tabIndex * tabItemWidth) + halfTabItemWidth;
}

- (void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    CGRect frame = tabBarArrow.frame;
    frame.origin.x = [self horizontalLocationFor:self.selectedIndex];
    tabBarArrow.frame = frame;
    [UIView commitAnimations];  
}

@end
