//
//  GLItemCell.m
//

#import "GLItemCell.h"
#import "GLItem.h"
#import "UIImageView+WebCache.h"

@implementation GLItemCell

//
// configureForData:tableView:indexPath:
//
// Invoked when the cell is given data. All fields should be updated to reflect
// the data.
//
// Parameters:
//    dataObject - the dataObject (can be nil for data-less objects)
//    aTableView - the tableView (passed in since the cell may not be in the
//		hierarchy)
//    anIndexPath - the indexPath of the cell
//
- (void)configureForData:(id)dataObject
	tableView:(UITableView *)aTableView
	indexPath:(NSIndexPath *)anIndexPath
{
	[super configureForData:dataObject tableView:aTableView indexPath:anIndexPath];
	
    GLItem *i = (GLItem *)dataObject;
    [self.imageView setImageWithURL:[NSURL URLWithString:i.iconicUrl] placeholderImage:[UIImage imageNamed:@"default_achievement_60.png"]];
	self.textLabel.text = i.label ? i.label : @"Empty";
    
    if ([i.category isEqualToString:@"container"])
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
