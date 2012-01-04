//
//  EnemyShip.m
//  ARSpaceships
//
//  Created by Nick on 6/14/11.
//  Copyright 2011 Nick Waynik Jr. All rights reserved.
//

#import "EnemyShip.h"


@implementation EnemyShip

@synthesize yawPosition, timeToLive;

-(id)init {
    self = [super init];
    if (self){ 
        yawPosition = 0;
        timeToLive = 0;
	}
    return self;
}


@end
