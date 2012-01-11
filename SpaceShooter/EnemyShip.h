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


-(id)initWithHp:(int)hp  min:(int)minMoveDuration  max:(int)maxMoveDuration  imageOrNil:(NSString*)fileName;
+(id)shipWithHp:(int)hp  min:(int)minMoveDuration  max:(int)maxMoveDuration  imageOrNil:(NSString*)fileName;
@end