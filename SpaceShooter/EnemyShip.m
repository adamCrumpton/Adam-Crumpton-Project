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

+(id)shipWithHp:(int)hp min:(int)minMoveDuration max:(int)maxMoveDuration imageOrNil:(NSString*)fileName
{
	return [[[self alloc] initWithHp:hp min:minMoveDuration max:maxMoveDuration imageOrNil:fileName] autorelease];
}

-(id)initWithHp:(int)hp min:(int)minMoveDuration max:(int)maxMoveDuration imageOrNil:(NSString*)fileName
{
    // use default image if one is not passed in.
    if(!fileName) fileName = @"enemyShip1.png";
    
    if (self = [super initWithFile: fileName])
    {
        self.hp = hp;
        self.minMoveDuration = minMoveDuration;
        self.maxMoveDuration = maxMoveDuration;
    }
    return self;
}

@end
