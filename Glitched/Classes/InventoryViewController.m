//
//  InventoryViewController.m
//  Glitched
//
//  Created by Kevin Elliott on 10/5/11.
//  Copyright (c) 2011 WeLike. All rights reserved.
//

#import "InventoryViewController.h"
#import "AchievementsController.h"
#import "GradientBackgroundTable.h"

#import "GLItem.h"
#import "GLItemCell.h"

@implementation InventoryViewController

@synthesize glitchedClient = _glitchedClient;
@synthesize inventoryResult = _inventoryResult;
@synthesize slots = _slots;

- (NSString *)title
{
    return NSLocalizedString(@"Inventory", @"");
}

- (void)createRows
{
    // Slot 0
    [self addSectionAtIndex:0 withAnimation:UITableViewRowAnimationFade];
    if (_slots)
    {
        for (GLItem *item in _slots) 
        {
            [self appendRowToSection:0
                           cellClass:[GLItemCell class] 
                            cellData:item
                       withAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    
    [self hideLoadingIndicator];
}

- (void)refresh:(id)sender
{
    [self removeAllSectionsWithAnimation:UITableViewRowAnimationFade];
    [self performSelector:@selector(createRows) withObject:nil afterDelay:0.5];
    [self showLoadingIndicator];
}

- (NSString *)tableView:(UITableView *)aTableView
titleForHeaderInSection:(NSInteger)section
{
	if (section == 0)
	{
		return NSLocalizedString(@"Main Slots", nil);
	}
    
	return nil;
}

#pragma mark - Glitched Client Delegate

- (void)glitchedClient:(GlitchedClient *)client authorizationSuccessful:(BOOL)successful
{
    NSLog(@"Inventory: glitchedClient:authorizationSuccessful called");
    
    if (!_slots)
    {
        [_glitchedClient getPlayerInventory];
        [self showLoadingIndicator];
    }
}

- (void)glitchedClient:(GlitchedClient *)client receivedPlayerInfo:(NSDictionary *)result
{
    NSLog(@"Inventory: glitchedClient:receivedPlayerInfo called");
}

- (void)glitchedClient:(GlitchedClient *)client receivedPlayerInventory:(NSDictionary *)result
{
    NSLog(@"Inventory: glitchedClient:receivedPlayerInventory called");
    
    self.inventoryResult = [NSDictionary dictionaryWithDictionary:result];
    self.slots = [self sortItems:[self extractItemsFromResult:result itemsKey:@"contents"]];
    
    [self refresh:nil];
}

#pragma mark - Utilities

- (NSArray *)extractItemsFromResult:(NSDictionary *)result
{
    return [self extractItemsFromResult:result itemsKey:@"contents"];
}

- (NSArray *)extractItemsFromResult:(NSDictionary *)result itemsKey:(NSString *)itemsKey
{
    NSMutableArray *itemsArray = [NSMutableArray array];
    
    if (!itemsKey)
        itemsKey = @"contents";
    NSDictionary *items = [result objectForKey:itemsKey];
    NSEnumerator *enumerator = [items keyEnumerator];
    NSString *key;
    while (key = [enumerator nextObject])
    {
        NSDictionary *item = [items objectForKey:key];
        GLItem *i = [[GLItem alloc] init];
        if (![item isKindOfClass:[NSNull class]])
        {
            i.slotName = key;
            i.slotTsid = [item objectForKey:@"tsid"];
            i.pathTsid = [item objectForKey:@"path_tsid"];
            i.classTsid = [item objectForKey:@"class_tsid"];
            i.label = [item objectForKey:@"label"];
            i.itemCount = [item objectForKey:@"count"];
        
            NSDictionary *itemDef = [item objectForKey:@"item_def"];
            i.nameSingle = [itemDef objectForKey:@"name_single"];
            i.namePlural = [itemDef objectForKey:@"name_plural"];
            i.category = [itemDef objectForKey:@"category"];
            i.maxStack = [itemDef objectForKey:@"max_stack"];
            i.description = [itemDef objectForKey:@"desc"];
            i.baseCost = [itemDef objectForKey:@"base_cost"];
            i.swfUrl = [itemDef objectForKey:@"swf_url"];
            i.iconicUrl = [itemDef objectForKey:@"iconic_url"];
        }
        
        [itemsArray addObject:i];
        [i release];
    }
    return itemsArray;
}

- (NSArray *)sortItems:(NSArray *)items
{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"slotName"
                                                  ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [items sortedArrayUsingDescriptors:sortDescriptors];
    return sortedArray;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!_glitchedClient)
    {
        _glitchedClient = [[GlitchedClient alloc] init];
        _glitchedClient.delegate = self;
    }
    
    if (!_glitchedClient.authorized)
    {
        [_glitchedClient authorize];
    }
    else
    {
        [_glitchedClient getPlayerInventory];
    }

    [self showLoadingIndicator];
    self.useCustomHeaders = YES;
}

- (void)loadView
{
    GradientBackgroundTable *aTableView =
    [[[GradientBackgroundTable alloc]
      initWithFrame:CGRectZero
      style:UITableViewStyleGrouped]
     autorelease];
	
	self.view = aTableView;
	self.tableView = aTableView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end