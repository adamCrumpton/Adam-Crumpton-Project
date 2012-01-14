//
//  Asteroid.h
//  SpaceShooter
//
//  Created by James Strong on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Enemy.h"

@interface Asteroid : Enemy

-(id)init: (CCScene *) stage;
+(id)asteroid: (CCScene *) stage;

@end
