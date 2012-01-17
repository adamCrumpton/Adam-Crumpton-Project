//
//  Asteroid.h
//  SpaceShooter
//
//  Created by James Strong on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Enemy.h"

@interface Asteroid : Enemy {
    CCParticleSystem *fire;
}

@property(nonatomic, assign) CCParticleSystem *fire;

-(id)init;
+(id)asteroid;

@end
