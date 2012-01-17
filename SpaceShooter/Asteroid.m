#import "Asteroid.h"

@implementation Asteroid
@synthesize fire;

-(id)init {
    self = [super initWithSpriteFrameName:@"asteroid.png"];
    return self;    
}

+(id)asteroid {
    return [[[self alloc] init] autorelease];    
}

-(void) activateWithYPos:(int) yPos andDuration:(float)duration {
    [super activateWithYPos:yPos andDuration:duration];
    
    fire = [[CCParticleSystemQuad alloc] initWithFile:@"Comet.plist"];
    fire.position = ccp(8, 8);
    [self addChild:fire z:1];
}

-(void) setInvisible {
    [super setInvisible];

    [self removeChild:fire cleanup:YES];
    self.fire = nil;
}

@end
