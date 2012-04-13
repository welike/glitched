//
//  InventoryViewController.h
//  Glitched
//
//  Created by Kevin Elliott on 10/5/11.
//  Copyright (c) 2011 WeLike. All rights reserved.
//

#import "PageViewController.h"
#import "GlitchedClient.h"

@interface InventoryViewController : PageViewController <GlitchedClientDelegate>
{    
    GlitchedClient *_glitchedClient;
    NSDictionary *_inventoryResult;
    NSArray *_slots;
}

@property (nonatomic, retain) GlitchedClient *glitchedClient;
@property (nonatomic, retain) NSDictionary *inventoryResult;
@property (nonatomic, retain) NSArray *slots;

- (NSArray *)extractItemsFromResult:(NSDictionary *)result;
- (NSArray *)extractItemsFromResult:(NSDictionary *)result itemsKey:(NSString *)itemsKey;
- (NSArray *)sortItems:(NSArray *)items;

@end
