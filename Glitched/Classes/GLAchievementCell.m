//
//  GLAchievementCell.m
//

#import "GLAchievementCell.h"
#import "GLAchievement.h"
#import "UIImageView+WebCache.h"

@implementation GLAchievementCell

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
	
    GLAchievement *a = (GLAchievement *)dataObject;
    [self.imageView setImageWithURL:[NSURL URLWithString:a.image60] placeholderImage:[UIImage imageNamed:@"default_achievement_60.png"]];
	self.textLabel.text = a.name;
}

@end
