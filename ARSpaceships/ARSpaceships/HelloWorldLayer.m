//
//  HelloWorldLayer.m
//  ARSpaceships
//
//  Created by Nick on 6/8/11.
//  Copyright Nick Waynik Jr. 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#include <stdlib.h>
#import "SimpleAudioEngine.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer
@synthesize motionManager;
@synthesize enemyCount;

#define kXPositionMultiplier 15
#define kTimeToLive 100

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init {
	if((self=[super init])) {
		
		// add and position the labels
        /*yawLabel = [CCLabelTTF labelWithString:@"Yaw: " fontName:@"Marker Felt" fontSize:12];
         posIn360Label = [CCLabelTTF labelWithString:@"360Pos: " fontName:@"Marker Felt" fontSize:12];
         yawLabel.position =  ccp(50, 240);
         posIn360Label.position =  ccp(50, 300);
         [self addChild: yawLabel];
         [self addChild:posIn360Label];*/
        
        self.motionManager = [[[CMMotionManager alloc] init] autorelease];
        motionManager.deviceMotionUpdateInterval = 1.0/60.0;
        if (motionManager.isDeviceMotionAvailable) {
            [motionManager startDeviceMotionUpdates];
        }
        
        [self scheduleUpdate];
        
        batchNode = [CCSpriteBatchNode batchNodeWithFile:@"Sprites.pvr.ccz"];
        [self addChild:batchNode];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Sprites.plist"];
        
        // Loop through 1 - 5 and add space ships
        enemySprites = [[NSMutableArray alloc] init];
        for(int i = 0; i < 5; ++i) {
            EnemyShip *enemyShip = [self addEnemyShip:i];
            [enemySprites addObject:enemyShip];
            enemyCount += 1;
        }
        
        CCSprite *scope = [CCSprite spriteWithFile:@"scope.png"];
        scope.position = ccp(240, 160);
        [self addChild:scope z:15];
        
        // Allow touches with the layer
        [self registerWithTouchDispatcher];
        
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"SpaceGame.caf" loop:YES];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"explosion_large.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"laser_ship.caf"];
	}
	return self;
}

-(void)update:(ccTime)delta {
    
    CMDeviceMotion *currentDeviceMotion = motionManager.deviceMotion;
    CMAttitude *currentAttitude = currentDeviceMotion.attitude;
    
    // Convert the radians yaw value to degrees then round up/down
    float yaw = roundf((float)(CC_RADIANS_TO_DEGREES(currentAttitude.yaw)));
    
    // Convert the degrees value to float and use Math function to round the value
    //[yawLabel setString:[NSString stringWithFormat:@"Yaw: %.0f", yaw]];
    
    // Convert the yaw value to a value in the range of 0 to 360
    int positionIn360 = yaw;
    if (positionIn360 < 0) {
        positionIn360 = 360 + positionIn360;
    }
    
    //[posIn360Label setString:[NSString stringWithFormat:@"360Pos: %d", positionIn360]];
    
    for (EnemyShip *enemyShip in enemySprites) {
        [self checkEnemyShipPosition:enemyShip withYaw:yaw];
    }
    
    for (EnemyShip *enemyShip in enemySprites) {
        enemyShip.timeToLive--;
        if (enemyShip.timeToLive == 0) {
            int x = arc4random() % 360;
            [enemyShip setPosition:ccp(5000, 160)];
            enemyShip.yawPosition = x;
            enemyShip.timeToLive = kTimeToLive;
        }
    }
    
}

-(EnemyShip *)addEnemyShip:(int)shipTag {
    
    EnemyShip *enemyShip = [EnemyShip spriteWithSpriteFrameName:@"enemy_spaceship.png"];
    
    // Set position of the space ship randomly
    int x = arc4random() % 360;
    enemyShip.yawPosition = x;
    
    
    // Set the position of the space ship off the screen, but in the center of the y axis
    // we will update it in another method
    [enemyShip setPosition:ccp(5000, 160)];
    
    // Set time to live on the space ship
    enemyShip.timeToLive = kTimeToLive;
    enemyShip.visible = true;
    
    [batchNode addChild:enemyShip z:3 tag:shipTag];
    
    return enemyShip;
}

-(void)checkEnemyShipPosition:(EnemyShip *)enemyShip withYaw:(float)yawPosition {
    // Convert the yaw value to a value in the range of 0 to 360
    int positionIn360 = yawPosition;
    if (positionIn360 < 0) {
        positionIn360 = 360 + positionIn360;
    }
    
    BOOL checkAlternateRange = false;
    
    // Determine the minimum position for enemy ship
    int rangeMin = positionIn360 - 23;
    if (rangeMin < 0) {
        rangeMin = 360 + rangeMin;
        checkAlternateRange = true;
    }
    
    // Determine the maximum position for the enemy ship
    int rangeMax = positionIn360 + 23;
    if (rangeMax > 360) {
        rangeMax = rangeMax - 360;
        checkAlternateRange = true;
    }
    
    
    if (checkAlternateRange) {
        if ((enemyShip.yawPosition < rangeMax || enemyShip.yawPosition > rangeMin ) || (enemyShip.yawPosition > rangeMin || enemyShip.yawPosition < rangeMax)) {
            [self updateEnemyShipPosition:positionIn360 withEnemy:enemyShip];
        }
        
    } else {
        if (enemyShip.yawPosition > rangeMin && enemyShip.yawPosition < rangeMax) {
            [self updateEnemyShipPosition:positionIn360 withEnemy:enemyShip];
        } 
    }
}

-(void)updateEnemyShipPosition:(int)positionIn360 withEnemy:(EnemyShip *)enemyShip {
    int difference = 0;
    if (positionIn360 < 23) {
        // Run 1
        if (enemyShip.yawPosition > 337) {
            difference = (360 - enemyShip.yawPosition) + positionIn360;
            int xPosition = 240 + (difference * kXPositionMultiplier);
            [enemyShip setPosition:ccp(xPosition, enemyShip.position.y)];
        } else {
            // Run Standard Position Check
            [self runStandardPositionCheck:positionIn360 withDiff:difference withEnemy:enemyShip];
        }
    } else if(positionIn360 > 337) {
        // Run 2
        if (enemyShip.yawPosition < 23) {
            difference = enemyShip.yawPosition + (360 - positionIn360);
            int xPosition = 240 - (difference * kXPositionMultiplier);
            [enemyShip setPosition:ccp(xPosition, enemyShip.position.y)];
        } else {
            // Run Standard Position Check
            [self runStandardPositionCheck:positionIn360 withDiff:difference withEnemy:enemyShip];
        }
    } else {
        // Run Standard Position Check
        [self runStandardPositionCheck:positionIn360 withDiff:difference withEnemy:enemyShip];
    }
}

-(void)runStandardPositionCheck:(int)positionIn360 withDiff:(int)difference withEnemy:(EnemyShip *)enemyShip {
    // This method checks if the enemyShip position is to the left or right of the
    // device's positionIn360 when the positionIn360 fall within the range of 34 to 337
    if (enemyShip.yawPosition > positionIn360) {
        difference = enemyShip.yawPosition - positionIn360;
        int xPosition = 240 - (difference * kXPositionMultiplier);
        [enemyShip setPosition:ccp(xPosition, enemyShip.position.y)];
    } else {
        difference = positionIn360 - enemyShip.yawPosition;
        int xPosition = 240 + (difference * kXPositionMultiplier);
        [enemyShip setPosition:ccp(xPosition, enemyShip.position.y)];
    }
    
}

- (BOOL) circle:(CGPoint) circlePoint withRadius:(float) radius collisionWithCircle:(CGPoint) circlePointTwo collisionCircleRadius:(float) radiusTwo {
	float xdif = circlePoint.x - circlePointTwo.x;
	float ydif = circlePoint.y - circlePointTwo.y;
	
	float distance = sqrt(xdif*xdif+ydif*ydif);
	if(distance <= radius+radiusTwo) return YES;
	
	return NO;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[SimpleAudioEngine sharedEngine] playEffect:@"laser_ship.caf"];
    
    CGPoint location = CGPointMake(240,160);
    
    // 1
    for (EnemyShip *enemyShip in enemySprites) {
        if (enemyShip.timeToLive > 0) {
            // Check to see if yaw position is in range
            BOOL wasTouched = [self circle:location withRadius:50 collisionWithCircle:enemyShip.position collisionCircleRadius:50];
            
            if (wasTouched) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"explosion_large.caf"];
                enemyShip.timeToLive = 0;
                enemyShip.visible = false;
                enemyCount -= 1;
            }
        }
    }
    
    // 2
    CCParticleSystemQuad *particle = [CCParticleSystemQuad particleWithFile:@"Explosion.plist"];
    particle.position = ccp(240,160);
    [self addChild:particle z:20];
    particle.autoRemoveOnFinish = YES;
    
    // 3
    if (enemyCount == 0) {
        // Show end game
        CGSize winSize = [CCDirector sharedDirector].winSize;
        CCLabelBMFont *label = [CCLabelBMFont labelWithString:@"You win!" fntFile:@"Arial.fnt"];
        label.scale = 2.0;
        label.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:label z:30];
    }
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	[enemySprites release];
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
