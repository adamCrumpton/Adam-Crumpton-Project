//
//  EnemyShip.h
//  SpaceShooter
//
//  Created by Adam Crumpton on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface EnemyShip : CCSprite {
    int _currentHitPoints;
    int _minMoveDuration;
    int _maxMoveDuration;
}

@property (nonatomic, assign) int hp;
@property (nonatomic, assign) int minMoveDuration;
@property (nonatomic, assign) int maxMoveDuration;

@end

@interface WeakAndFastShip : EnemyShip {
}
+(id)enemyShip;
@end

@interface StrongAndSlowShip : EnemyShip {
}
+(id)enemyShip;
@end