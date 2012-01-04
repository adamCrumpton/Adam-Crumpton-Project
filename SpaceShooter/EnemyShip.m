//
//  EnemyShip.m
//  SpaceShooter
//
//  Created by Adam Crumpton on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EnemyShip.h"

@implementation EnemyShip


@synthesize hp = _currentHitPoints;
@synthesize minMoveDuration = _minMoveDuration;
@synthesize maxMoveDuration = _maxMoveDuration;

@end

@implementation WeakAndFastShip

+ (id)enemyShip {
    
    WeakAndFastShip *enemyShip = nil;
    if ((enemyShip = [[[super alloc] initWithFile:@"enemyShip1.png"] autorelease])) {
        enemyShip.hp = 1;
        enemyShip.minMoveDuration = 3;
        enemyShip.maxMoveDuration = 5;
    }
    return enemyShip;
    
}

@end

@implementation StrongAndSlowShip

+ (id)enemyShip {
    
    StrongAndSlowShip *enemyShip = nil;
    if ((enemyShip = [[[super alloc] initWithFile:@"enemyShip1.png"] autorelease])) {
        enemyShip.hp = 3;
        enemyShip.minMoveDuration = 6;
        enemyShip.maxMoveDuration = 12;
    }
    return enemyShip;
    
}

@end
