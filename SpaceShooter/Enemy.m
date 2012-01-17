#import "Enemy.h"
@implementation Enemy

//@synthesize particleSystem;
//@synthesize moveDuration;

-(id) initWithSpriteName:(NSString *)spriteName {    
    if (self = [super initWithSpriteFrameName:spriteName]) {
        // all enemies start off invisible on screen and should be
        // manually activated through the activate() method.
        self.visible = NO;
    }
    return self;    
}

+(id) enemyWithSpriteName:(NSString *)spriteName {
    return [[[self alloc] initWithSpriteName:spriteName] autorelease];
}

-(void) activateWithDuration:(float)duration {
    CGSize winSize = [CCDirector sharedDirector].winSize;    
    [self activateWithYPos:arc4random_uniform(winSize.height) andDuration:duration];
}

-(void) activateWithYPos:(int) yPos andDuration:(float)duration {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    [self stopAllActions];
    self.visible = YES;
    self.position = ccp(winSize.width + self.contentSize.width/2, yPos);
    [self runAction:[CCSequence actions:
                     [CCMoveBy actionWithDuration:duration position:ccp(-winSize.width-self.contentSize.width, 0)],
                     [CCCallFuncN actionWithTarget:self selector:@selector(setInvisible)],
                     nil]];
}

-(void) destroy {
    [self setInvisible];
}

-(BOOL) isActive {
    return self.visible;
}

-(BOOL) collidesWith:(CCSprite *)obj {
    return CGRectIntersectsRect(self.boundingBox, obj.boundingBox);
}

-(void) setInvisible {
    self.visible = NO;
}

@end
