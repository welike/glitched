//
//  SkillCell.m
//

#import "SkillCell.h"
#import "GLSkill.h"
#import "UIImageView+WebCache.h"

@implementation SkillCell

@synthesize textLabel, imageView;
@synthesize skill, progressView, timeRemainingLabel;
@synthesize glowTimer;

//
// nibName
//
// returns the name of the nib file from which the cell is loaded.
//
+ (NSString *)nibName
{
	return @"SkillCell";
}

//
// handleSelectionInTableView:
//
// Performs the appropriate action when the cell is selected
//
- (void)handleSelectionInTableView:(UITableView *)aTableView
{
	[super handleSelectionInTableView:aTableView];
	
	NSInteger rowIndex = [aTableView indexPathForCell:self].row;
	//[((PageViewController *)aTableView.delegate).navigationController
    // pushViewController:[[[DetailViewController alloc] initWithRowIndex:rowIndex] autorelease]
    // animated:YES];
}

- (void)finishConstruction
{
	[super finishConstruction];
    
    // Progress view
	self.progressView = [[DDProgressView alloc] initWithFrame:CGRectMake(60.0f, 27.0f, self.contentView.bounds.size.width-90.0f, 0.0f)];
    [progressView setOuterColor:[UIColor clearColor]];
    [progressView setInnerColor:[UIColor grayColor]];
    [progressView setEmptyColor:[UIColor lightGrayColor]];
    [self.contentView addSubview:progressView];
    
    // Time remaining
    self.timeRemainingLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0f, 32.0f, self.contentView.bounds.size.width-120.0f, 20.0f)];
    timeRemainingLabel.textColor = [UIColor darkGrayColor];
    timeRemainingLabel.backgroundColor = [UIColor clearColor];
    timeRemainingLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
    [self.contentView addSubview:timeRemainingLabel];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    //CGRect labelFrame = self.textLabel.frame;
    // self.textLabel.frame = CGRectMake(labelFrame.origin.x, labelFrame.origin.y-13.0f, labelFrame.size.width, labelFrame.size.height);
}

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
	
    GLSkill *s = (GLSkill *)dataObject;

    [self.imageView setImageWithURL:[NSURL URLWithString:s.icon100] placeholderImage:[UIImage imageNamed:@"default_achievement_60.png"]];
	self.textLabel.text = s.name;
    
    if ([s.timeRemaining intValue] > 0)
    {
        NSString *remainingText = [s friendlyTimeRemaining];
        // Skill is not learned yet
        if ([s.timeRemaining intValue] < [s.totalTime intValue])
        {
            if (s.isLearning)
            {
                // Skill is actively being learned
                timeRemainingLabel.text = [NSString stringWithFormat:@"%@ left", remainingText];
                timeRemainingLabel.textColor = [UIColor whiteColor];
                [progressView setInnerColor:[UIColor brownColor]];
            }
            else
            {
                // Skill has been paused
                timeRemainingLabel.text = [NSString stringWithFormat:@"%@", remainingText];
                timeRemainingLabel.textColor = [UIColor darkGrayColor];
                [progressView setInnerColor:[UIColor yellowColor]];
            }
        }
        else
        {
            // Skill hasn't been started yet
            timeRemainingLabel.text = remainingText;
            timeRemainingLabel.textColor = [UIColor darkGrayColor];
            [progressView setInnerColor:[UIColor grayColor]];
        }
    }
    else
    {
        // Skill was completed
        timeRemainingLabel.text = @"Completed";
        timeRemainingLabel.textColor = [UIColor darkGrayColor];
        [progressView setInnerColor:[UIColor grayColor]];
    }
    
    self.skill = s;
    [self updateProgressView];
    
    if (skill.isLearning)
    {
        [self startGlowTimer];
    }
}

- (void)prepareForReuse
{
    [self stopGlowTimer];
}

#pragma mark - Progress Bar
- (void)updateProgressView
{
    float totalTime = [skill.totalTime floatValue];
    float timeRemaining = [skill.timeRemaining floatValue];
    float current = (totalTime - timeRemaining) / totalTime;
    
    NSLog(@"SkillCell: updateProgressView: (%f - %f) / %f = %f", totalTime, timeRemaining, totalTime, current);
    [progressView setProgress:current];
}

- (void)glowAnimationIteration
{
    NSLog(@"glowAnimationIteration");
    [self beginGlowAnimation];
}

- (void)beginGlowAnimation
{
    NSLog(@"Progress bar fade out animation");
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(glowAnimationDidStop)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    [self.progressView setInnerColor:[UIColor orangeColor]];
    
    [UIView commitAnimations];
}

- (void)glowAnimationDidStop
{
    NSLog(@"Progress bar fade in animation");
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:1.0];
    
    [self.progressView setInnerColor:[UIColor brownColor]];
    
    [UIView commitAnimations];
}

- (void)startGlowTimer
{
    if (self.glowTimer == nil)
    {
        NSLog(@"Starting glow timer");
        self.glowTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(glowAnimationIteration) userInfo:nil repeats:YES];
    }
}

- (void)stopGlowTimer;
{
    if (self.glowTimer)
    {
        NSLog(@"Stopping glow timer");
        [glowTimer invalidate];
        self.glowTimer = nil;
        [glowTimer release];
    }
}

@end
