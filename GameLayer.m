//
//  GameLayer.m
//  FingerJoust
//
//  Created by Hunter Francis on 7/11/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import "GameLayer.h"
#import "Jouster.h"
#import "JousterA.h"
#import "JousterB.h"
#import "JousterC.h"
#import "JousterD.h"
#import "TitleLayer.h"
#import "MathHelper.h"
#import "PowerStone.h"
#import "Vortex.h"
#import "CCWarpSprite.h"
#import "UILayer.h"

#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedBase.h"
#import "ColoredCircleSprite.h"

@implementation GameLayer

@synthesize powerStone, vortexArray, redJoystick, redVictoryArray, blueVictoryArray;

-(id) initWithPlayerOne:(int) characterOne playerTwo:(int) characterTwo{
    if(self = [super initWithColor:COLOR_GAMEAREA_B4] ){
        CGSize winSize= [[CCDirector sharedDirector] winSize];
        self.vortexArray = [[NSMutableArray alloc] init];
        
        uiLayer = [[[UILayer alloc] init] autorelease];
        [self addChild:uiLayer z:10];
        
        //labels to display who is winning
/*        redWinsLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Marker Felt" fontSize:64];
        redWinsLabel.color = ccRED;
        redWinsLabel.position = ccp(winSize.width/2 - 50, 20);
        blueWinsLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Marker Felt" fontSize:64];
        blueWinsLabel.position = ccp(winSize.width/2 + 50, 20);
        blueWinsLabel.color = ccBLUE;
        
        [self addChild:redWinsLabel];
        [self addChild:blueWinsLabel];
 */
        
        //powerstones display labels
       /* redPowerStonesLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Marker Felt" fontSize:32];
        redPowerStonesLabel.color = ccRED;
        redPowerStonesLabel.position = ccp(150, 50);
        bluePowerStonesLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Marker Felt" fontSize:32];
        bluePowerStonesLabel.position = ccp(winSize.width - 150, 50);
        bluePowerStonesLabel.color = ccBLUE;
        
        [self addChild:redPowerStonesLabel];
        [self addChild:bluePowerStonesLabel];
        */
        [self scheduleUpdate];
        _touchEnabled = YES;
        currentRound = 0;
        _touchMode = NO;
        
        redJouster = [self createJouster:characterOne];
        redJouster.player = 1;
        
        blueJouster =  [self createJouster:characterTwo];
        blueJouster.player = 2;
        
        [redJouster resetJouster];
        [blueJouster resetJouster];
        
        [self addChild:redJouster z:2];
        [self addChild:blueJouster z:2];
        redJouster.visible = NO;
        blueJouster.visible = NO;
        
  //      self.powerStone = [[PowerStone alloc] init];
        //has to be called after jousters have been added
//        [self spawnPowerStone];

        centerSprite = [CCSprite spriteWithSpriteFrameName:@"BodyOuter"];
        centerSprite.visible = NO;
        centerSprite.position = ccp(winSize.width/2, winSize.height/2);
        centerSprite.color = ccYELLOW;
        [self addChild:centerSprite];

        //setup victory display
        self.redVictoryArray = [NSMutableArray array];
        self.blueVictoryArray = [NSMutableArray array];
        for(int i = 0; i < 3; i++){
            CCSprite *victorySprite = [[[CCSprite alloc] initWithFile:@"Icon-72.png"] autorelease];
            [self addChild:victorySprite];
            [self.redVictoryArray addObject:victorySprite];
        }
        for(int i = 0; i < 3; i++){
            CCSprite *victorySprite = [[[CCSprite alloc] initWithFile:@"Icon-72.png"] autorelease];
            [self addChild:victorySprite];
            [self.blueVictoryArray addObject:victorySprite];
        }
        [self refreshVictoryPoint];
        
        
        
        //motion streak test
        // create the streak object and add it to the scene
       /*streak = [CCMotionStreak streakWithFade:.5 minSeg:.2 width:128 color:ccWHITE textureFilename:@"BodyOuter.png"];
        ccBlendFunc blend = {GL_SRC_COLOR, GL_ONE_MINUS_SRC_ALPHA};
        streak.blendFunc = blend;
        streak.fastMode = YES;
        [self addChild:streak];*/
        
        redMotionStreak = [[CCParticleSystemQuad alloc] initWithFile: @"MotionStreak.plist"];
        blueMotionStreak = [[CCParticleSystemQuad alloc] initWithFile: @"MotionStreak.plist"];

        [redMotionStreak setStartColor:ccc4f(1.0, 0.5, 0, 1.0)];
        [redMotionStreak setEndColor:ccc4f(1.0, 0.5, 0, 1.0)];
        [blueMotionStreak setStartColor:ccc4f(0.0, 0.0, 1.0, 1.0)];
        [blueMotionStreak setEndColor:ccc4f(0.0, 0.0, 1.0, 1.0)];
        [redMotionStreak stopSystem];
        [blueMotionStreak stopSystem];
        [self addChild:redMotionStreak z:1];
        [self addChild:blueMotionStreak z:1];
        [self gameIntro];
    }
    return self;
}


-(void) dealloc{
    [redJouster release];
    [blueJouster release];
    [self.vortexArray release];
    [redVictoryArray release];
    [blueVictoryArray release];
    [super dealloc];
}

-(void) spawnPowerStone{
    
    [self.powerStone removeFromParent];
    //make sure power stone
    //make sure stone doesn't spawn too close to either of the players
    BOOL validSpawnPosition = NO;
    while(!validSpawnPosition){
        validSpawnPosition = YES;
        [self.powerStone randomSpot];
        
        //check position against jousters
        if(ccpDistance(redJouster.position, powerStone.position) < 100){
            validSpawnPosition = NO;
        }else if(ccpDistance(blueJouster.position, powerStone.position) < 100){
            validSpawnPosition = NO;
        }
    }
    [self addChild:self.powerStone];
    [self refreshUI];
}


-(void) spawnVortexAtPoint:(CGPoint) point{
    Vortex *vortex = [[Vortex alloc] init];

    vortex.position = point;
    [self addChild:vortex];
    [self.vortexArray addObject:vortex];
    vortex.pEffect = [self vortexEffect:point];
}


-(Jouster*) createJouster:(int) character{
    if(character == 0 ){
        return [[JousterA alloc] init];
    }else if(character == 1){
        return [[JousterB alloc] init];
    }else if(character ==2 ){
        return [[JousterC alloc] init];
    }else if(character == 3){
        return [[JousterD alloc] init];
    }
    return [JousterB node];
}

-(void) resetJousters{
    [blueJouster removeFromParentAndCleanup:YES];
    [redJouster removeFromParentAndCleanup:YES];
    [self addChild:redJouster];
    [self addChild:blueJouster];
    [redJouster resetJouster];
    [blueJouster resetJouster];
    [blueMotionStreak resetSystem];
    [redMotionStreak resetSystem];
    
    uiLayer.roundTimer = ROUND_TIME;
    uiLayer.displayedTime = ROUND_TIME;
    centerSprite.visible = NO;
    uiLayer.timerLabel.string = [NSString stringWithFormat:@"%d", uiLayer.displayedTime];
    //remove all vortexs' from the board
    for(Vortex *vortex in self.vortexArray){
        [vortex.pEffect resetSystem];
        [vortex.pEffect stopSystem];
        [vortex removeFromParent];
    }
    [self.vortexArray removeAllObjects];
        
    
}

-(void) refreshUI{
//    [redWinsLabel setString:[NSString stringWithFormat:@"%d", redWins]];
//    [blueWinsLabel setString:[NSString stringWithFormat:@"%d", blueWins]];
    [self refreshVictoryPoint];
//    [redPowerStonesLabel setString:[NSString stringWithFormat:@"%d", redJouster.powerStones]];
  //  [bluePowerStonesLabel setString:[NSString stringWithFormat:@"%d", blueJouster.powerStones]];
}

-(void) update:(ccTime)dt{
    if(currentState == GAMEPLAY){
        [redJouster update:dt];
        [blueJouster update:dt];
        [self collisionChecks:dt];
        [self updateVortex:dt];
        [self updateTimer:dt];

    }else if(currentState == ROUND_START){
        timeBeforeNewRoundStarts -= dt;
        //some transitions don't allow movement
        if(timeBeforeNewRoundStarts <= 0.0) timeBeforeNewRoundStarts = .01;
        //take care of starting game round timer increase
        float timeScale = (TRANSITION_TIME - timeBeforeNewRoundStarts)/TRANSITION_TIME;
        dt = dt * timeScale;
        [redJouster update:dt];
        [blueJouster update:dt];
        //slow motion, no deaths allowed
        redJouster.position = ccpAdd(redJouster.position, ccpMult(redJouster.velocity, dt));
        blueJouster.position = ccpAdd(blueJouster.position, ccpMult(blueJouster.velocity, dt));
        redJouster.jousterSprite.position = ccpAdd(redJouster.joustPosition,  ccpMult(redJouster.joustVelocity, dt));
        blueJouster.jousterSprite.position = ccpAdd(blueJouster.joustPosition,  ccpMult(blueJouster.joustVelocity, dt));
        [redJouster checkBoundaries];
        [blueJouster checkBoundaries];
    }else if(currentState == ROUND_END){
        [redJouster update:dt];
        [blueJouster update:dt];
        //slow motion, no deaths allowed
        redJouster.position = ccpAdd(redJouster.position, ccpMult(redJouster.velocity, dt));
        blueJouster.position = ccpAdd(blueJouster.position, ccpMult(blueJouster.velocity, dt));
        redJouster.jousterSprite.position = ccpAdd(redJouster.joustPosition,  ccpMult(redJouster.joustVelocity, dt));
        blueJouster.jousterSprite.position = ccpAdd(blueJouster.joustPosition,  ccpMult(blueJouster.joustVelocity, dt));
        [redJouster checkBoundaries];
        [blueJouster checkBoundaries];
    }else if(currentState == GAME_OVER){
        [redJouster update:dt];
        [blueJouster update:dt];
        //slow motion, no deaths allowed
        redJouster.position = ccpAdd(redJouster.position, ccpMult(redJouster.velocity, dt));
        blueJouster.position = ccpAdd(blueJouster.position, ccpMult(blueJouster.velocity, dt));
        redJouster.jousterSprite.position = ccpAdd(redJouster.joustPosition,  ccpMult(redJouster.joustVelocity, dt));
        blueJouster.jousterSprite.position = ccpAdd(blueJouster.joustPosition,  ccpMult(blueJouster.joustVelocity, dt));
        [redJouster checkBoundaries];
        [blueJouster checkBoundaries];
    }else if(currentState == GAME_START){
        dt = dt/10;
        [redJouster update:dt];
        [blueJouster update:dt];
        //slow motion, no deaths allowed
        redJouster.position = ccpAdd(redJouster.position, ccpMult(redJouster.velocity, dt));
        blueJouster.position = ccpAdd(blueJouster.position, ccpMult(blueJouster.velocity, dt));
        redJouster.jousterSprite.position = ccpAdd(redJouster.joustPosition,  ccpMult(redJouster.joustVelocity, dt));
        blueJouster.jousterSprite.position = ccpAdd(blueJouster.joustPosition,  ccpMult(blueJouster.joustVelocity, dt));
        [redJouster checkBoundaries];
        [blueJouster checkBoundaries];
    }
    redMotionStreak.position = redJouster.position;
    blueMotionStreak.position = blueJouster.position;
}


-(void) collisionChecks:(ccTime) dt{
    //update the position using velocity, do update in steps
    BOOL bodyHit = NO;
    BOOL joustersHit = NO;
    BOOL death = NO;
    for (int i = 0; i < COLLISION_STEPS; i++) {
        //step body position
        if(!bodyHit){
            redJouster.position = ccpAdd(redJouster.position, ccpMult(redJouster.velocity, dt/COLLISION_STEPS));
            blueJouster.position = ccpAdd(blueJouster.position, ccpMult(blueJouster.velocity, dt/COLLISION_STEPS));
            bodyHit = [self bodyOnBodyCheck];
            [redJouster checkBoundaries];
            [blueJouster checkBoundaries];
        }
        
        //step jouster position
        if(!joustersHit){
            redJouster.jousterSprite.position = ccpAdd(redJouster.joustPosition,  ccpMult(redJouster.joustVelocity, dt/COLLISION_STEPS));
            blueJouster.jousterSprite.position = ccpAdd(blueJouster.joustPosition,  ccpMult(blueJouster.joustVelocity, dt/COLLISION_STEPS));
            joustersHit = [self jousterOnJousterCheck];
        }

        //prevents odd losses
        if(!joustersHit && !bodyHit & !death){
            death = [self jousterOnBodyCheck];
        }
    }
}

-(void) updateTimer:(ccTime) dt{
    uiLayer.roundTimer -= dt;
    if((int)uiLayer.roundTimer < uiLayer.displayedTime){
        uiLayer.displayedTime = (int)uiLayer.roundTimer;
        uiLayer.timerLabel.string = [NSString stringWithFormat:@"%d", uiLayer.displayedTime];
        
        if(uiLayer.displayedTime < 6){
            centerSprite.visible = YES;
        }
        
        //endGame based on distance to center
        if(uiLayer.displayedTime < 1){
            //check distance to center point, closest player wins
            [self checkClosestJousterToCenter];
            
        }
    }
}

-(void) updateVortex:(ccTime)dt{
    //take care of vortex affecting the jousters body
    for(Vortex *vortex in self.vortexArray){
        //distance
        float redDistance = ccpDistance(vortex.position, redJouster.position);
        float blueDistance = ccpDistance(vortex.position, blueJouster.position);
        
        //normalized direction to vortex
        CGPoint redToVortex = ccpNormalize(ccpSub(vortex.position, redJouster.position));
        CGPoint blueToVortex = ccpNormalize(ccpSub(vortex.position, blueJouster.position));
        
        float maxDistance = VORTEX_DISTANCE;
        float redPullPower = maxDistance - redDistance;
        redPullPower = redPullPower * redPullPower;
        float bluePullPower = maxDistance - blueDistance;
        bluePullPower = bluePullPower * bluePullPower;
        // adjust the strength of the vortex
        redPullPower = redPullPower/70;
        bluePullPower = bluePullPower/70;
        
        CGPoint redVortexVel = ccpMult(redToVortex, redPullPower);
        CGPoint blueVortexVel = ccpMult(blueToVortex, bluePullPower);
        
        //add vortex velocity to jouster's velocity
        redJouster.velocity = ccpAdd(redJouster.velocity,ccpMult(redVortexVel, dt));
        blueJouster.velocity = ccpAdd(blueJouster.velocity,ccpMult(blueVortexVel, dt));
        
        [vortex update:dt];
    }

    //delete old vortex
    for(int i = [self.vortexArray count] - 1; i >= 0; i-- ){
        Vortex *vortex = [self.vortexArray objectAtIndex:i];
        if(vortex.timeAlive > 4.0){
            [vortex.pEffect stopSystem];
            [vortex removeFromParent];
            [self.vortexArray removeObject:vortex];
        }
    }
}

-(void) checkClosestJousterToCenter{
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    CGPoint centerPoint = ccp(winSize.width/2, winSize.height/2);
    float redDistance = ccpDistance(redJouster.position, centerPoint);
    float blueDistance = ccpDistance(blueJouster.position, centerPoint);
    if(redDistance < blueDistance){
        didRedWinRound = YES;
        redWins++;
        winner = @"RED WINS";
        if(redWins > 2){
            [self transitionToGameOver];
        }else{
            [self transitionToEndRound];
        }
    }else{
        didRedWinRound = NO;
        blueWins++;
        winner = @"BLUE WINS";
        if(blueWins > 2){
            [self transitionToGameOver];
        }else{
            [self transitionToEndRound];
        }
    }
    [self refreshUI];
    
}

-(void) checkBodyOnBodyStun{
    //get normalized vector pointing at enemy
    CGPoint redToBlue = ccpNormalize(ccpSub(redJouster.position, blueJouster.position));
    CGPoint blueToRed = ccpMult(redToBlue, -1);
    
    //multiply normalized vector by bodies velocity
    CGPoint redRelativeVelocity = ccp(redToBlue.x * redJouster.velocity.x, redToBlue.y * redJouster.velocity.y);
    CGPoint blueRelativeVelocity = ccp(blueToRed.x * blueJouster.velocity.x, blueToRed.y * blueJouster.velocity.y);
    
    //check if magnitude of that number is high enough to cause stun damage
    float redMagnitude = ccpLength(redRelativeVelocity);
    float blueMagnitude = ccpLength(blueRelativeVelocity);
    BOOL isStun = NO;
    if(redMagnitude > STUN_CONTRAINT){
        // stun blue
        [blueJouster stunBody];
        isStun = YES;
    }
    if(blueMagnitude > STUN_CONTRAINT){
        // stun red
        [redJouster stunBody];
        isStun = YES;
    }
    
    //bounce off eachother
    //get direction
    CGPoint offset = ccpSub(redJouster.position, blueJouster.position);
    offset = [MathHelper normalize:offset];
    CGPoint redKnock = ccpMult(offset, blueMagnitude + 350);
    redJouster.velocity = redKnock;
    offset = ccpMult(offset, -1);
    CGPoint blueKnock = ccpMult(offset, redMagnitude + 350);
    blueJouster.velocity = blueKnock;
    
    [self clashEffect:redJouster.position otherPoint:blueJouster.position withMagnitude:blueMagnitude + redMagnitude + 500 withStun:isStun];
    
    
//    NSLog(@"redMag :%f", redMagnitude);
//    NSLog(@"blueMag :%f", blueMagnitude);
}

#pragma mark - collision functions
-(void) powerStoneCollisionCheck{
    //blue joust hitting red dude
    if([MathHelper circleCollisionPositionA:powerStone.position  raidusA:powerStone.bodyRadius positionB:redJouster.position radiusB:redJouster.bodyRadius] ){
//        redJouster.powerStones++;
        //[self spawnPowerStone];
        [self refreshUI];
    }
    if([MathHelper circleCollisionPositionA:powerStone.position  raidusA:powerStone.bodyRadius positionB:blueJouster.position radiusB:blueJouster.bodyRadius]){
//        blueJouster.powerStones++;
//        [self spawnPowerStone];
        [self refreshUI];
    }
}

-(BOOL) bodyOnBodyCheck{
    //bodies hit
    if( [MathHelper circleCollisionPositionA:redJouster.position raidusA:redJouster.bodyRadius positionB:blueJouster.position radiusB:blueJouster.bodyRadius]){
        [self checkBodyOnBodyStun];
        return YES;
        
    }
    return NO;
}

-(BOOL) jousterOnBodyCheck{
    //blue joust hitting red dude
    if([MathHelper circleCollisionPositionA:[blueJouster getWorldPositionOfJoust]  raidusA:[blueJouster joustRadius] positionB:redJouster.position radiusB:redJouster.bodyRadius] ){
        winner = @"Blue Wins";
        blueWins++;
        didRedWinRound = NO;
        if(blueWins > 2){
            [self transitionToGameOver];
        }else{
            [self transitionToEndRound];
        }
        [redJouster removeFromParentAndCleanup:YES];
        [redMotionStreak resetSystem];
        [redMotionStreak stopSystem];
        [self refreshUI];
        return YES;
    }
    if([MathHelper circleCollisionPositionA:[redJouster getWorldPositionOfJoust]  raidusA:[redJouster joustRadius] positionB:blueJouster.position radiusB:blueJouster.bodyRadius]){
        winner = @"Red Wins";
        redWins++;
        didRedWinRound = YES;
        if(redWins > 2){
            [self transitionToGameOver];
        }else{
            [self transitionToEndRound];
        }
        [blueJouster removeFromParentAndCleanup:YES];
        [blueMotionStreak resetSystem];
        [blueMotionStreak stopSystem];
        [self refreshUI];
        return YES;
    }
    return NO;
}

-(BOOL) jousterOnJousterCheck{
    //jousters hitting
    if( [MathHelper circleCollisionPositionA:[redJouster getWorldPositionOfJoust]  raidusA:[redJouster joustRadius] positionB:[blueJouster getWorldPositionOfJoust] radiusB: [blueJouster joustRadius]]){
        //bounce off eachother
        //TODO: make class specific collision code
        
        [redJouster joustCollision: [blueJouster getWorldPositionOfJoust] withRadius: blueJouster.joustRadius];
        [blueJouster joustCollision: [redJouster getWorldPositionOfJoust] withRadius: redJouster.joustRadius];
        [self spawnVortexAtPoint:ccpMidpoint([redJouster getWorldPositionOfJoust] , [blueJouster getWorldPositionOfJoust])];
//        [self clashEffect:[redJouster getWorldPositionOfJoust] otherPoint:[blueJouster getWorldPositionOfJoust]];
        return YES;
    }
    return NO;
}

#pragma mark - touch code
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    /*if(currentState != GAMEPLAY){
        return NO;
    }*/
    return YES;
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
   /*if(currentState != GAMEPLAY){
        return;
    }*/
    
    BOOL redAlreadyChosen = NO;
    BOOL blueAlreadyChosen = NO;
    for(UITouch* touch in touches){
        CGPoint location = [touch locationInView: [touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        CGSize winSize= [[CCDirector sharedDirector] winSize];
        CGRect redSide = CGRectMake(0, 0, EXTRA_CONTROL_OFFSET, winSize.height);
        CGRect blueSide = CGRectMake(winSize.width - EXTRA_CONTROL_OFFSET, 0, EXTRA_CONTROL_OFFSET, winSize.height);
        if(CGRectContainsPoint(redSide, location) && !redAlreadyChosen){
            [redJouster touch:location];
            redAlreadyChosen = YES;
        }
        if(CGRectContainsPoint(blueSide, location) && !blueAlreadyChosen){
            [blueJouster touch:location];
            blueAlreadyChosen = YES;
        }
    }
    if(!redAlreadyChosen){
        [redJouster resetTouch];
    }
    if(!blueAlreadyChosen){
        [blueJouster resetTouch];
    }
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    /*if(currentState != GAMEPLAY){
        return;
    }*/
    BOOL redAlreadyChosen = NO;
    BOOL blueAlreadyChosen = NO;
    for(UITouch* touch in touches){
        CGPoint location = [touch locationInView: [touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        CGSize winSize= [[CCDirector sharedDirector] winSize];
        CGRect redSide = CGRectMake(0, 0, EXTRA_CONTROL_OFFSET, winSize.height);
        CGRect blueSide = CGRectMake(winSize.width - EXTRA_CONTROL_OFFSET, 0, EXTRA_CONTROL_OFFSET, winSize.height);
        if(CGRectContainsPoint(redSide, location) && !redAlreadyChosen){
            [redJouster resetTouch];
            redAlreadyChosen = YES;
        }
        if(CGRectContainsPoint(blueSide, location) && !blueAlreadyChosen){
            [blueJouster resetTouch];
            blueAlreadyChosen = YES;
        }
    }
}

- (void) ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    /*if(currentState != GAMEPLAY){
        return;
    }*/
    BOOL redAlreadyChosen = NO;
    BOOL blueAlreadyChosen = NO;
    for(UITouch* touch in touches){
        CGPoint location = [touch locationInView: [touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        
        CGSize winSize= [[CCDirector sharedDirector] winSize];
        CGRect redSide = CGRectMake(0, 0, CONTROL_OFFSET, winSize.height);
        CGRect blueSide = CGRectMake(winSize.width - CONTROL_OFFSET, 0, CONTROL_OFFSET, winSize.height);
        
        if(CGRectContainsPoint(redSide, location) && !redAlreadyChosen){
            [redJouster resetTouch];
            redAlreadyChosen = YES;
        }
        
        if(CGRectContainsPoint(blueSide, location) && !blueAlreadyChosen){
            [blueJouster resetTouch];
            blueAlreadyChosen = YES;
        }
    }
}

-(void) registerWithTouchDispatcher
{
    [[CCDirector sharedDirector].touchDispatcher addStandardDelegate:self priority:0];
}

#pragma mark -  gamestate transitions

-(void) gameIntro{
    currentState = GAME_START;
    //show names of fighters
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    CCLabelTTF *gameStartLabel = [[[CCLabelTTF alloc] initWithString:@"Blue vs Red" fontName:@"Marker Felt" fontSize:32] autorelease];
    gameStartLabel.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:gameStartLabel];
    //run actions
    [uiLayer animateTouchAreasIn];
    CCDelayTime *delayAnim = [CCDelayTime actionWithDuration:1];
    CCCallBlock *blockAnim = [CCCallBlock actionWithBlock:^{
        [uiLayer smashTopBottomAlreadyInPlace:NO];
    }];
    CCSequence *seqAnim = [CCSequence actionOne:delayAnim two:blockAnim];
    [gameStartLabel runAction:seqAnim];
    
    
    
    CCDelayTime *delay = [CCDelayTime actionWithDuration:TRANSITION_TIME];
    CCCallBlock *block = [CCCallBlock actionWithBlock:^{
        [self removeChild:gameStartLabel];
        //transition to round Start
        [self transitionToStartRound];
    }];
    CCSequence *seq = [CCSequence actionOne:delay two:block];
    [gameStartLabel runAction:seq];
    
}


-(void) transitionToStartRound{
    currentRound++;
    
    if(currentState == GAME_START){
        [redJouster resetJouster];
        [blueJouster resetJouster];
        [blueMotionStreak resetSystem];
        [redMotionStreak resetSystem];
    }
    
    currentState = ROUND_START;
    //show names of fighters
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    CCLabelTTF *gameStartLabel = [[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"Round %d", currentRound] fontName:@"Marker Felt" fontSize:32] autorelease];
    gameStartLabel.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:gameStartLabel];
    timeBeforeNewRoundStarts = TRANSITION_TIME;
    CCDelayTime *delay = [CCDelayTime actionWithDuration:TRANSITION_TIME];
    CCCallBlock *block = [CCCallBlock actionWithBlock:^{
        [self removeChild:gameStartLabel];
        [self transitionToGamePlay];
    }];
    CCSequence *seq = [CCSequence actionOne:delay two:block];
    [gameStartLabel runAction:seq];
    
}

-(void) transitionToGamePlay{
    currentState = GAMEPLAY;
}

-(void) transitionToEndRound{
    currentState = ROUND_END;
    //show names of fighters
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    CCLabelTTF *gameStartLabel = [[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%@ Round", winner] fontName:@"Marker Felt" fontSize:32] autorelease];
    gameStartLabel.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:gameStartLabel];
    
    //animation
    CCDelayTime *delayAnim = [CCDelayTime actionWithDuration:1];
    CCCallBlock *blockAnim = [CCCallBlock actionWithBlock:^{
        [uiLayer smashTopBottomAlreadyInPlace:YES];
    }];
    CCSequence *seqAnim = [CCSequence actionOne:delayAnim two:blockAnim];
    [gameStartLabel runAction:seqAnim];
    
    CCDelayTime *delay = [CCDelayTime actionWithDuration:TRANSITION_TIME];
    CCCallBlock *block = [CCCallBlock actionWithBlock:^{
        [self removeChild:gameStartLabel];
        [self resetJousters];
        [self transitionToStartRound];
    }];
    CCSequence *seq = [CCSequence actionOne:delay two:block];
    [self runAction:seq];
}

-(void) transitionToGameOver{
    currentState = GAME_OVER;
    //say who won
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    CCLabelTTF *gameStartLabel = [[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%@ Game", winner] fontName:@"Marker Felt" fontSize:32] autorelease];
    gameStartLabel.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:gameStartLabel];
    
    CCDelayTime *delay = [CCDelayTime actionWithDuration:TRANSITION_TIME + 1];
    CCCallBlock *block = [CCCallBlock actionWithBlock:^{
        //transition to titleLayer
        TitleLayer *title = [TitleLayer node];
        [[CCDirector sharedDirector] replaceScene:title];
        [title setWinner:winner];
    }];
    CCSequence *seq = [CCSequence actionOne:delay two:block];
    [self runAction:seq];
    
}


#pragma mark - special effects

-(void) clashEffect:(CGPoint) p1 otherPoint:(CGPoint) p2 withMagnitude:(float) magnitude withStun:(BOOL) stun{
    
    ccColor4F effectColor = ccc4f(1, 1, 1, 1);
    if(stun){
        effectColor = ccc4f(1.0, 1.0, 0, 1);
    }
    //how fast the particles move
    float particleSpeed = magnitude/2;
    
    //collision effect
    CCParticleSystemQuad *collisionEffect = [[CCParticleSystemQuad alloc] initWithFile: @"CollisionEffect.plist"];
    collisionEffect.startColor = effectColor;
    collisionEffect.endColor = effectColor;
    collisionEffect.speed = particleSpeed;
    collisionEffect.autoRemoveOnFinish = YES;
    CGPoint midPoint = ccpMidpoint(p1, p2);
    float rotation = [MathHelper degreeAngleBetween:p1 and:p2];
    
    collisionEffect.rotation = -rotation - 90;
    collisionEffect.position = midPoint;
    [self addChild:collisionEffect];
    
    collisionEffect = [[CCParticleSystemQuad alloc] initWithFile: @"CollisionEffect.plist"];
    collisionEffect.autoRemoveOnFinish = YES;
    collisionEffect.startColor = effectColor;
    collisionEffect.endColor = effectColor;
    collisionEffect.speed = particleSpeed;
    midPoint = ccpMidpoint(p1, p2);
    rotation = [MathHelper degreeAngleBetween:p1 and:p2];
    
    collisionEffect.rotation = -rotation + 90;
    collisionEffect.position = midPoint;
    [self addChild:collisionEffect];
}

-(CCParticleSystemQuad*) vortexEffect:(CGPoint) pt{
    CCParticleSystemQuad *collisionEffect = [[CCParticleSystemQuad alloc] initWithFile: @"VortexEffect.plist"];
    collisionEffect.autoRemoveOnFinish = YES;
    collisionEffect.position = pt;
    [self addChild:collisionEffect];
    return collisionEffect;
    
}

#pragma mark - victory point stuff

-(void) refreshVictoryPoint{
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    //red victory
    for(int i = 0; i < self.redVictoryArray.count; ++i){
        CCSprite *victorySprite = [self.redVictoryArray objectAtIndex:i];
        victorySprite.position = ccp(CONTROL_OFFSET + 50 + i*60, 20);
        if(i < redWins){
            victorySprite.visible = YES;
        }else{
            victorySprite.visible = NO;
       }
    }
    
    //red victory
    for(int i = 0; i < self.blueVictoryArray.count; ++i){
        CCSprite *victorySprite = [self.blueVictoryArray objectAtIndex:i];
        victorySprite.position = ccp((winSize.width - CONTROL_OFFSET) - 50 - i*60, 20);
        if(i < blueWins){
            victorySprite.visible = YES;
        }else{
            victorySprite.visible = NO;
        }
    }
}

@end
