//
//  SkillCell.h
//

#import "PageCell.h"
#import "DDProgressView.h"

@class GLSkill;

@interface SkillCell : PageCell
{
    GLSkill *skill;
    IBOutlet UILabel *textLabel;
    IBOutlet UIImageView *imageView;
    DDProgressView *progressView;
    UILabel *timeRemainingLabel;
    NSTimer *glowTimer;
}

@property (nonatomic, retain) GLSkill *skill;
@property (nonatomic, retain) UILabel *textLabel;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) DDProgressView *progressView;
@property (nonatomic, retain) UILabel *timeRemainingLabel;
@property (nonatomic, retain) NSTimer *glowTimer;

- (void)updateProgressView;
- (void)startGlowTimer;
- (void)stopGlowTimer;

@end
