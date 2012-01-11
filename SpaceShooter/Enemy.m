//
//  Enemy.m
//  SpaceShooter
//
//  Created by Adam Crumpton on 1/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Enemy.h"

@implementation Enemy


@synthesize hp = _currentHitPoints;
@synthesize minMoveDuration = _minMoveDuration;
@synthesize maxMoveDuration = _maxMoveDuration;

- (id) initWithHp:(int)hp min:(int)minMoveDuration max:(int)maxMoveDuration andImage:(NSString*)fileName {

    Enemy *enemyShip = nil;
    if ((enemyShip = [[[super alloc] initWithFile:fileName] autorelease])) {
        enemyShip.hp = hp;
        enemyShip.minMoveDuration = minMoveDuration;
        enemyShip.maxMoveDuration = maxMoveDuration;
    }
    return enemyShip;  
    
}

@end

