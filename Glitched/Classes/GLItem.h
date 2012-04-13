//
//  GLItem.h
//  Glitched
//
//  Created by Kevin Elliott on 10/5/11.
//  Copyright (c) 2011 WeLike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLItem : NSObject
{
    // Slot details
    NSString *_slotTsid;
    NSString *_slotName;
    NSString *_pathTsid;
    NSString *_label;
    NSString *_itemCount;
    
    // Item definition
    NSString *_classTsid;
    NSString *_nameSingle;
    NSString *_namePlural;
    NSString *_category;
    NSString *_maxStack;
    NSString *_description;
    NSString *_baseCost;
    NSString *_swfUrl;
    NSString *_iconicUrl;
}

@property (nonatomic, retain) NSString *slotTsid;
@property (nonatomic, retain) NSString *slotName;
@property (nonatomic, retain) NSString *pathTsid;
@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) NSString *itemCount;

@property (nonatomic, retain) NSString *classTsid;
@property (nonatomic, retain) NSString *nameSingle;
@property (nonatomic, retain) NSString *namePlural;
@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSString *maxStack;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *baseCost;
@property (nonatomic, retain) NSString *swfUrl;
@property (nonatomic, retain) NSString *iconicUrl;

@end
