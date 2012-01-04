//
//  EnemyShip.h
//  ARSpaceships
//
//  Created by Nick on 6/14/11.
//  Copyright 2011 Nick Waynik Jr. All rights reserved.
//

#import "cocos2d.h"


@interface EnemyShip : CCSprite {
    int yawPosition;
    int timeToLive;
}

@property (readwrite) int yawPosition;
@property (readwrite) int timeToLive;


@end