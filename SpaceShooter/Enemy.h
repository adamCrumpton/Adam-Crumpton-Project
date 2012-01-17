#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

@interface Enemy : CCSprite {
}

-(id)initWithSpriteName: (NSString *) spriteName;
+(id)enemyWithSpriteName: (NSString *) spriteName;

-(void)activateWithDuration: (float) duration;
-(void)activateWithYPos: (int) yPos andDuration: (float) duration;
-(void)destroy;
-(BOOL)isActive;
-(BOOL)collidesWith: (CCSprite *) obj;
-(void)setInvisible;

@end
