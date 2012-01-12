// Import the interfaces
#import "HelloWorldLayer.h"
#import "CCParallaxNode-Extras.h"
#import "SimpleAudioEngine.h"
#import "EnemyShip.h"
#import "Enemy.h"

// number of asteroid sprites allocated for reuse.
#define kNumAsteroids   15
// number of laser sprites allocated for reuse.
#define kNumLasers      5

#define kFilteringFactor 0.1
#define kRestAccelX -0.6
#define kShipMaxPointsPerSec (winSize.height*0.5)        
#define kMaxDiffX 0.2

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {        
    UIAccelerationValue rollingX, rollingY, rollingZ;
    
    rollingX = (acceleration.x * kFilteringFactor) + (rollingX * (1.0 - kFilteringFactor));    
    rollingY = (acceleration.y * kFilteringFactor) + (rollingY * (1.0 - kFilteringFactor));    
    rollingZ = (acceleration.z * kFilteringFactor) + (rollingZ * (1.0 - kFilteringFactor));
    
    float accelX = acceleration.x - rollingX;
    //float accelY = acceleration.y - rollingY;
    //float accelZ = acceleration.z - rollingZ;
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    float accelDiff = accelX - kRestAccelX;
    float accelFraction = accelDiff / kMaxDiffX;
    float pointsPerSec = kShipMaxPointsPerSec * accelFraction;
    
    _shipPointsPerSecY = pointsPerSec;
    
}

- (void)setInvisible:(CCNode *)node {
    node.visible = NO;
}

- (float)randomValueBetween:(float)low andValue:(float)high {
    return (((float) arc4random() / 0xFFFFFFFFu) * (high - low)) + low;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    CCSprite *shipLaser = [_shipLasers objectAtIndex:_nextShipLaser];
    _nextShipLaser++;
    if (_nextShipLaser >= _shipLasers.count) _nextShipLaser = 0;
    
    shipLaser.position = ccp(20, winSize.height/2);
    
    // Determine offset of location to projectile
    int offX = location.x - shipLaser.position.x;
    int offY = location.y - shipLaser.position.y;
    
    // Bail out if we are shooting down or backwards
    if (offX <= 0) return;
    
    // Ok to add now - we've double checked position
    //[self addChild:projectile];
    
    // Determine where we wish to shoot the projectile to
    int realX = winSize.width + (shipLaser.contentSize.width/2);
    float ratio = (float) offY / (float) offX;
    int realY = (realX * ratio) + shipLaser.position.x;
    int offRealX = realX - shipLaser.position.y;
    int offRealY = realY - shipLaser.position.x;
    CGPoint realDest = ccp(realX, realY);
    
    shipLaser.position = ccpAdd(_ship.position, ccp((shipLaser.contentSize.width/2), 0));
    shipLaser.visible = YES;
    [shipLaser stopAllActions];
    
    float angleRadians = atanf((float)offRealY / (float)offRealX);
    float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
    float cocosAngle = -1 * (angleDegrees);
    if (cocosAngle > 26) {
        cocosAngle = 26;
    }
    if (cocosAngle < -26) {
        cocosAngle = -26;
    }
    _ship.rotation = cocosAngle;
    shipLaser.rotation = cocosAngle;
    
    [shipLaser runAction:[CCSequence actions:
                          [CCMoveBy actionWithDuration:0.5 position:realDest],
                          [CCCallFuncN actionWithTarget:self selector:@selector(setInvisible:)],
                          nil]];
    [[SimpleAudioEngine sharedEngine] playEffect:@"laser_ship.caf"];
    
}

- (void)restartTapped:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:[HelloWorldLayer scene]]];   
}
- (void)endScene:(EndReason)endReason {
    
    if (_gameOver) return;
    _gameOver = true;
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    NSString *message;
    if (endReason == kEndReasonWin) {
        message = @"You rocked!";
    } else if (endReason == kEndReasonLose) {
        message = @"You lose!";
    }
    
    CCLabelBMFont *label;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        label = [CCLabelBMFont labelWithString:message fntFile:@"Arial-hd.fnt"];
    } else {
        label = [CCLabelBMFont labelWithString:message fntFile:@"Arial.fnt"];
    }
    label.scale = 0.1;
    label.position = ccp(winSize.width/2, winSize.height * 0.6);
    [self addChild:label];
    
    CCLabelBMFont *restartLabel;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        restartLabel = [CCLabelBMFont labelWithString:@"Restart" fntFile:@"Arial-hd.fnt"];    
    } else {
        restartLabel = [CCLabelBMFont labelWithString:@"Restart" fntFile:@"Arial.fnt"];    
    }
    
    CCMenuItemLabel *restartItem = [CCMenuItemLabel itemWithLabel:restartLabel target:self selector:@selector(restartTapped:)];
    restartItem.scale = 0.1;
    restartItem.position = ccp(winSize.width/2, winSize.height * 0.4);
    
    CCMenu *menu = [CCMenu menuWithItems:restartItem, nil];
    menu.position = CGPointZero;
    [self addChild:menu];
    
    [restartItem runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
    [label runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
     
    
}

//Enemy Ship finished moving
-(void)enemyShipMoveFinished:(id)sender {
    CCSprite *sprite = (CCSprite *)sender;
    [self removeChild:sprite cleanup:YES];
}
//Add enemy ships
-(void)addEnemyShip {
    
    EnemyShip *target = nil;
    // randomize between two different types of ships.
    if ((arc4random() % 2) == 0) {
        // weak and fast
        target = [EnemyShip shipWithHp:1 min:3 max:5 imageOrNil:nil];
    } else {
        // strong and slow
        target = [EnemyShip shipWithHp:3 min:6 max:12 imageOrNil:nil];
    }
    
    // Determine where to spawn the target along the Y axis
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    int minY = target.contentSize.height/2;
    int maxY = winSize.height - target.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the target slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    target.position = ccp(winSize.width + (target.contentSize.width/2), actualY);
    [self addChild:target];
    
    // Determine speed of the target
    int minDuration = target.minMoveDuration;
    int maxDuration = target.maxMoveDuration;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    id actionMove = [CCMoveTo actionWithDuration:actualDuration 
                                        position:ccp(-target.contentSize.width/2, actualY)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self 
                                             selector:@selector(enemyShipMoveFinished:)];
    [target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
}

//Callback function at the bottom of init
- (void) gameLogic:(ccTime)dt {
    [self addEnemyShip];
}

- (void)collisionChecks {
    for (Enemy *asteroid in _asteroids) {        
        if(![asteroid isActive]) continue;
        
        // check for collisions between ship lasers and asteroids.        
        for (CCSprite *shipLaser in _shipLasers) {                        
            if (!shipLaser.visible) continue;            
            // if collision has been found, remove
            // laser and asteroid.
            if([asteroid collidesWith:shipLaser]) {
                shipLaser.visible = NO;                
                [asteroid destroy];
                [[SimpleAudioEngine sharedEngine] playEffect:@"explosion_large.caf"];
                continue;
            }
        }
        
        // check for collisions between ship and asteroids.
        if ([asteroid collidesWith:_ship]) {
            [asteroid destroy];
            [[SimpleAudioEngine sharedEngine] playEffect:@"shake.caf"];
            [_ship runAction:[CCBlink actionWithDuration:1.0 blinks:9]];            
            _lives--;
        }
    }
}

- (void) update:(ccTime)dt {
    
    CGPoint backgroundScrollVel = ccp(-1000, 0);
    _backgroundNode.position = ccpAdd(_backgroundNode.position, ccpMult(backgroundScrollVel, dt));
    NSArray *spaceDusts = [NSArray arrayWithObjects:_spacedust1, _spacedust2, nil];
    for (CCSprite *spaceDust in spaceDusts) {
        if ([_backgroundNode convertToWorldSpace:spaceDust.position].x < -spaceDust.contentSize.width) {
            [_backgroundNode incrementOffset:ccp(2*spaceDust.contentSize.width,0) forChild:spaceDust];
        }
    }

    CGSize winSize = [CCDirector sharedDirector].winSize;
    float maxY = winSize.height - _ship.contentSize.height/2;
    float minY = _ship.contentSize.height/2;    
    float newY = _ship.position.y + (_shipPointsPerSecY * dt);
    newY = MIN(MAX(newY, minY), maxY);
    _ship.position = ccp(_ship.position.x, newY);
    
    double curTime = CACurrentMediaTime();
    // spawn the next asteroid when it is time.
    if (curTime > _nextAsteroidSpawn) {
        // come up with a new random spawn time for the next asteroid.
        float randSecs = [self randomValueBetween:0.20 andValue:1.0];
        _nextAsteroidSpawn = randSecs + curTime;
        
        // activate new asteroid
        float randDuration = [self randomValueBetween:2.0 andValue: 10.0];
        Enemy *asteroid = [_asteroids objectAtIndex:_nextAsteroid];
        [asteroid activateWithDuration:randDuration];
        
        // if we've gone through all asteroids objects in the array, start over.
        _nextAsteroid++;
        if (_nextAsteroid >= _asteroids.count) _nextAsteroid = 0;        
    }
    
    [self collisionChecks];
    
    if (_lives <= 0) {
        [_ship stopAllActions];
        _ship.visible = FALSE;
        [self endScene:kEndReasonLose];
    } else if (curTime >= _gameOverTime) {
        [self endScene:kEndReasonWin];
    }
}

-(void) initAudio 
{
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"SpaceGame.caf" loop:YES];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"explosion_large.caf"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"laser_ship.caf"];
}

-(void) initBackground 
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    // planet background.
    // Set higher bit-depth for background image to avoid banding on the background.
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    _mainbg = [CCSprite spriteWithFile:@"bg_background.png"];
    _mainbg.position = ccp(0, winSize.width/2);
    [self addChild: _mainbg z:-1];
    // reset back to lower bit-depth.
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    
    // background star parallaxing.
    _backgroundNode = [CCParallaxNode node];
    CGPoint dustSpeed = ccp(0.05, 0.05);    
    _spacedust1 = [CCSprite spriteWithFile:@"bg_front_spacedust.png"];
    _spacedust2 = [CCSprite spriteWithFile:@"bg_front_spacedust.png"];    
    [_backgroundNode addChild:_spacedust1 z:0 parallaxRatio:dustSpeed positionOffset:ccp(0,winSize.width/2)];
    [_backgroundNode addChild:_spacedust2 z:0 parallaxRatio:dustSpeed positionOffset:ccp(_spacedust1.contentSize.width,winSize.width/2)];            
    [self addChild:_backgroundNode z:-1];
    
    // fast flying spacedust.
    NSArray *starsArray = [NSArray arrayWithObjects:@"Stars1.plist", @"Stars2.plist", @"Stars3.plist", nil];
    for(NSString *stars in starsArray) {        
        CCParticleSystemQuad *starsEffect = [CCParticleSystemQuad particleWithFile:stars];        
        [self addChild:starsEffect z:1];
    }   
}


/*
 * Pre-allocates all sprites used and stores them in 
 * their corresponding arrays.
*/
-(void) initGameAssets 
{
    // Allocate asteroids.
    _asteroids = [[CCArray alloc] initWithCapacity:kNumAsteroids];
    for(int i = 0; i < kNumAsteroids; ++i) { 
        Enemy *asteroid = [Enemy enemyWithSpriteName:@"asteroid.png"];
        /*
        CCSprite *asteroid = [CCSprite spriteWithSpriteFrameName:@"asteroid.png"];
        asteroid.visible = NO;
        */
        [_batchNode addChild:asteroid];
        [_asteroids addObject:asteroid];
    }
    
    // Allocate lasers.
    _shipLasers = [[CCArray alloc] initWithCapacity:kNumLasers];
    for(int i = 0; i < kNumLasers; ++i) {
        CCSprite *shipLaser = [CCSprite spriteWithSpriteFrameName:@"laserbeam_blue.png"];
        shipLaser.visible = NO;
        [_batchNode addChild:shipLaser];
        [_shipLasers addObject:shipLaser];
    }        
}

// on "init" you need to initialize your instance
-(id) init {
    if((self=[super init])) {                                
        // load up spritesheet.
        _batchNode = [CCSpriteBatchNode batchNodeWithFile:@"Sprites.pvr.ccz"];
        [self addChild:_batchNode];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Sprites.plist"];
        
        // initialize planet background.
        [self initBackground];
        
        // add ship to middle of screen.        
        _ship = [CCSprite spriteWithSpriteFrameName:@"SpaceFlier_sm_1.png"];
        CGSize winSize = [CCDirector sharedDirector].winSize;
        _ship.position = ccp(winSize.height * 0.1, winSize.width * 0.5);
        [_batchNode addChild:_ship z:1];        
    }
    
    [self initGameAssets];
    [self initAudio];

    double curTime = CACurrentMediaTime();
    _lives = 3;
    _gameOverTime = curTime + 30.0;    
    self.isTouchEnabled = YES;
    self.isAccelerometerEnabled = YES;
    
    [self scheduleUpdate];
    [self schedule:@selector(gameLogic:) interval:1.0];    
    return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc {
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
