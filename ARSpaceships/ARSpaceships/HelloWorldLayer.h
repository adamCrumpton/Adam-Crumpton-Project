//
//  HelloWorldLayer.h
//  ARSpaceships
//
//  Created by Nick on 6/8/11.
//  Copyright Nick Waynik Jr. 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#include <CoreMotion/CoreMotion.h>
#import <CoreFoundation/CoreFoundation.h>
#import "EnemyShip.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    CMMotionManager *motionManager;
    CCLabelTTF *yawLabel;
    CCLabelTTF *posIn360Label;
    NSMutableArray *enemySprites;
    int enemyCount;
    CCSpriteBatchNode *batchNode;
}

@property (nonatomic, retain) CMMotionManager *motionManager;
@property (readwrite) int enemyCount;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(EnemyShip *)addEnemyShip:(int)shipTag;
-(void)checkEnemyShipPosition:(EnemyShip *)enemyShip withYaw:(float)yawPosition;
-(void)updateEnemyShipPosition:(int)positionIn360 withEnemy:(EnemyShip *)enemyShip;
- (BOOL) circle:(CGPoint) circlePoint withRadius:(float) radius collisionWithCircle:(CGPoint) circlePointTwo collisionCircleRadius:(float) radiusTwo;
-(void)runStandardPositionCheck:(int)positionIn360 withDiff:(int)difference withEnemy:(EnemyShip *)enemyShip;

@end
