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
#import "CCShake.h"
#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedBase.h"
#import "ColoredCircleSprite.h"

@implementation GameLayer
@synthesize powerStone, vortexArray, lastWinner, jousterArray;

-(id) initWithPlayerOne:(int) characterOne playerTwo:(int) characterTwo{
    if(self = [super initWithColor:COLOR_GAMEAREA_B4] ){
        CGSize winSize= [[CCDirector sharedDirector] winSize];
        self.vortexArray = [[NSMutableArray alloc] init];
        
        uiLayer = [[[UILayer alloc] initWithGameLayer:self] autorelease];
        [self addChild:uiLayer z:10];
        
        //labels to display who is winning
        
        [self scheduleUpdate];
        _touchEnabled = YES;
        currentRound = 0;
        _touchMode = NO;
        
        
        self.jousterArray = [[[NSMutableArray alloc] init] autorelease];
        for(int i = 1; i < 5; i++){
            Jouster *jouster = [self createJouster:characterOne];
            jouster.player = i;
            [jouster makeTail];
            [self.jousterArray addObject:jouster];
            [jouster resetJouster];
            jouster.visible = NO;
            [self addChild:jouster z:2];
        }
        
        //      self.powerStone = [[PowerStone alloc] init];
        //has to be called after jousters have been added
        //        [self spawnPowerStone];
        
        //setup center circle thing
        centerSprite = [[[CCSprite alloc] init] autorelease];
        centerSprite.cascadeOpacityEnabled = YES;
        centerSprite.position = ccp(winSize.width/2, winSize.height/2);
        CCSprite *dashedCircle = [CCSprite spriteWithSpriteFrameName:@"timerCircle"];
        dashedCircle.scale = 1.5;
        CCSprite *centerdot = [CCSprite spriteWithSpriteFrameName:@"BodyOuter"];
        centerdot.scale = .25;
        [centerSprite addChild:dashedCircle];
        [centerSprite addChild:centerdot];
        centerSprite.opacity = 0;
        [self addChild:centerSprite];
        
        
        
        [self gameIntro];
    }
    return self;
}


-(void) dealloc{
    [vortexArray release];
    [jousterArray release];
    [super dealloc];
}

/*
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
 }*/


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
    
    for(Jouster *jouster in self.jousterArray){
        [jouster removeFromParentAndCleanup:YES];
        [self addChild:jouster];
        [jouster resetJouster];
    }
    
    uiLayer.roundTimer = ROUND_TIME;
    uiLayer.displayedTime = ROUND_TIME;
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
        [uiLayer refreshVictoryPoint];
    //    [redPowerStonesLabel setString:[NSString stringWithFormat:@"%d", redJouster.powerStones]];
    //  [bluePowerStonesLabel setString:[NSString stringWithFormat:@"%d", blueJouster.powerStones]];
}

-(void) update:(ccTime)dt{
    if(currentState == GAMEPLAY){
        for(Jouster *jouster in self.jousterArray){
            if(!jouster.isDead){
                [jouster update:dt];
            }
        }
        [self collisionChecks:dt];
        [self updateVortex:dt];
        [self updateTimer:dt];
        [self testForVictory];
        
    }else if(currentState == ROUND_START){
        /*timeBeforeNewRoundStarts -= dt;
         //some transitions don't allow movement
         if(timeBeforeNewRoundStarts <= 0.0) timeBeforeNewRoundStarts = .01;
         //take care of starting game round timer increase
         float timeScale = (TRANSITION_TIME - timeBeforeNewRoundStarts)/TRANSITION_TIME;
         dt = dt * timeScale;
         */
        
        for(Jouster *jouster in self.jousterArray){
            [jouster update:dt];
        }
        //slow motion, no deaths allowed
        /*redJouster.position = ccpAdd(redJouster.position, ccpMult(redJouster.velocity, dt));
         blueJouster.position = ccpAdd(blueJouster.position, ccpMult(blueJouster.velocity, dt));
         redJouster.jousterSprite.position = ccpAdd(redJouster.joustPosition,  ccpMult(redJouster.joustVelocity, dt));
         blueJouster.jousterSprite.position = ccpAdd(blueJouster.joustPosition,  ccpMult(blueJouster.joustVelocity, dt));
         [redJouster checkBoundaries];
         [blueJouster checkBoundaries];
         */
    }else if(currentState == ROUND_END){
        dt = dt/6;
        for(Jouster *jouster in self.jousterArray){
            [jouster update:dt];
        }
        //slow motion, no deaths allowed
        /*
         redJouster.position = ccpAdd(redJouster.position, ccpMult(redJouster.velocity, dt));
         blueJouster.position = ccpAdd(blueJouster.position, ccpMult(blueJouster.velocity, dt));
         redJouster.jousterSprite.position = ccpAdd(redJouster.joustPosition,  ccpMult(redJouster.joustVelocity, dt));
         blueJouster.jousterSprite.position = ccpAdd(blueJouster.joustPosition,  ccpMult(blueJouster.joustVelocity, dt));
         [redJouster checkBoundaries];
         [blueJouster checkBoundaries];
         */
    }else if(currentState == GAME_OVER){
        dt = dt/6;
        for(Jouster *jouster in self.jousterArray){
            [jouster update:dt];
        }
        /*
         //slow motion, no deaths allowed
         redJouster.position = ccpAdd(redJouster.position, ccpMult(redJouster.velocity, dt));
         blueJouster.position = ccpAdd(blueJouster.position, ccpMult(blueJouster.velocity, dt));
         redJouster.jousterSprite.position = ccpAdd(redJouster.joustPosition,  ccpMult(redJouster.joustVelocity, dt));
         blueJouster.jousterSprite.position = ccpAdd(blueJouster.joustPosition,  ccpMult(blueJouster.joustVelocity, dt));
         [redJouster checkBoundaries];
         [blueJouster checkBoundaries];
         */
    }else if(currentState == GAME_START){
        dt = dt/10;
        for(Jouster *jouster in self.jousterArray){
            [jouster update:dt];
        }
        //slow motion, no deaths allowed
        /* redJouster.position = ccpAdd(redJouster.position, ccpMult(redJouster.velocity, dt));
         blueJouster.position = ccpAdd(blueJouster.position, ccpMult(blueJouster.velocity, dt));
         redJouster.jousterSprite.position = ccpAdd(redJouster.joustPosition,  ccpMult(redJouster.joustVelocity, dt));
         blueJouster.jousterSprite.position = ccpAdd(blueJouster.joustPosition,  ccpMult(blueJouster.joustVelocity, dt));
         [redJouster checkBoundaries];
         [blueJouster checkBoundaries];
         */
    }
    
}


-(void) collisionChecks:(ccTime) dt{
    //update the position using velocity, do update in steps
    BOOL bodyHit = NO;
    BOOL joustersHit = NO;
    BOOL death = NO;
    for (int i = 0; i < COLLISION_STEPS; i++) {
        //step body position
        if(!bodyHit){
            for(Jouster *jouster in self.jousterArray){
                if(!jouster.isDead){
                    jouster.position = ccpAdd(jouster.position, ccpMult(jouster.velocity, dt/COLLISION_STEPS));
                    bodyHit = [self bodyOnBodyCheck:jouster];
                    [jouster checkBoundaries];
                }
            }
        }
        
        
        //step jouster position
        if(!joustersHit){
            
            for(Jouster *jouster in self.jousterArray){
                if(!jouster.isDead){
                    jouster.jousterSprite.position = ccpAdd(jouster.joustPosition,  ccpMult(jouster.joustVelocity, dt/COLLISION_STEPS));
                    joustersHit = [self jousterOnJousterCheck:jouster];
                }
            }
        }
        
        //prevents odd losses
        if(!joustersHit && !bodyHit & !death){
            [self jousterOnBodyCheck];
        }
    }
    
}

-(void) updateTimer:(ccTime) dt{
    uiLayer.roundTimer -= dt;
    if((int)uiLayer.roundTimer < uiLayer.displayedTime){
        uiLayer.displayedTime = (int)uiLayer.roundTimer;
        uiLayer.timerLabel.string = [NSString stringWithFormat:@"%d", uiLayer.displayedTime];
        
        if(uiLayer.displayedTime < 6 && !centerVisible){
            centerVisible = YES;
            
            CCFadeIn *fadeIn = [CCFadeIn actionWithDuration:2];
            CCRotateBy *rotate = [CCRotateBy actionWithDuration:20 angle:1000];
            CCScaleTo *scale = [CCScaleTo actionWithDuration:5.0 scale:0];

            CCSpawn *spawn = [CCSpawn actions:rotate, fadeIn, scale, nil];
            [centerSprite runAction:spawn];
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
        for(Jouster *jouster in self.jousterArray){
            if(!jouster.isDead){
                //distance
                float redDistance = ccpDistance(vortex.position, jouster.position);
                
                //normalized direction to vortex
                CGPoint redToVortex = ccpNormalize(ccpSub(vortex.position, jouster.position));
                
                float maxDistance = VORTEX_DISTANCE;
                float redPullPower = maxDistance - redDistance;
                redPullPower = redPullPower * redPullPower;
                // adjust the strength of the vortex
                redPullPower = redPullPower/70;
                CGPoint redVortexVel = ccpMult(redToVortex, redPullPower);
                
                //add vortex velocity to jouster's velocity
                jouster.velocity = ccpAdd(jouster.velocity,ccpMult(redVortexVel, dt));
                
            }
            [vortex update:dt];
            
        }
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
    
    float shortestDistance = 999999;
    int playerWithShortestDistance = 0;
    for(Jouster *jouster in self.jousterArray){
        if(!jouster.isDead){
            float distance = ccpDistance(jouster.position, centerPoint);
            if(distance < shortestDistance){
                shortestDistance = distance;
                playerWithShortestDistance = jouster.player;
            }
        }
    }
    
    //kill all players that are not closest to the center
    for(Jouster *jouster in self.jousterArray){
        if(jouster.player != playerWithShortestDistance){
            jouster.isDead = YES;
            [self deathEffect:jouster];
            [jouster removeFromParentAndCleanup:YES];
        }
    }
    
    /*
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
    */
}


-(void) checkBodyOnBodyStun:(Jouster *) jousterA otherJouster:(Jouster *)jousterB{
    //get normalized vector pointing at enemy
    CGPoint redToBlue = ccpNormalize(ccpSub(jousterA.position, jousterB.position));
    CGPoint blueToRed = ccpMult(redToBlue, -1);
    
    //multiply normalized vector by bodies velocity
    CGPoint redRelativeVelocity = ccp(redToBlue.x * jousterA.velocity.x, redToBlue.y * jousterA.velocity.y);
    CGPoint blueRelativeVelocity = ccp(blueToRed.x * jousterB.velocity.x, blueToRed.y * jousterB.velocity.y);
    
    //check if magnitude of that number is high enough to cause stun damage
    float redMagnitude = ccpLength(redRelativeVelocity);
    float blueMagnitude = ccpLength(blueRelativeVelocity);
    BOOL isStun = NO;
    if(redMagnitude > STUN_CONTRAINT){
        // stun blue
        [jousterB stunBody];
        isStun = YES;
    }
    if(blueMagnitude > STUN_CONTRAINT){
        // stun red
        [jousterA stunBody];
        isStun = YES;
    }
    
    //bounce off eachother
    //get direction
    CGPoint offset = ccpSub(jousterA.position, jousterB.position);
    offset = [MathHelper normalize:offset];
    CGPoint redKnock = ccpMult(offset, blueMagnitude + 350);
    jousterA.velocity = redKnock;
    offset = ccpMult(offset, -1);
    CGPoint blueKnock = ccpMult(offset, redMagnitude + 350);
    jousterB.velocity = blueKnock;
    
    [self clashEffect:jousterA.position otherPoint:jousterB.position withMagnitude:blueMagnitude + redMagnitude + 500 withStun:isStun];
    
    
    //    NSLog(@"redMag :%f", redMagnitude);
    //    NSLog(@"blueMag :%f", blueMagnitude);
}

#pragma mark - collision functions
/*-(void) powerStoneCollisionCheck{
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
 }*/

-(BOOL) bodyOnBodyCheck:(Jouster *) jouster{
    //bodies hit
    
    for(Jouster *jousterB in self.jousterArray){
        if(jousterB.player != jouster.player && !jousterB.isDead){
            if( [MathHelper circleCollisionPositionA:jouster.position raidusA:jouster.bodyRadius positionB:jousterB.position radiusB:jousterB.bodyRadius]){
                [self checkBodyOnBodyStun:jouster otherJouster:jousterB];
                return YES;
            }
        }
    }
    
    return NO;
}

-(void) jousterOnBodyCheck{
    
    for(Jouster *jousterA in self.jousterArray){
        if(!jousterA.isDead){
            for(Jouster *jousterB in self.jousterArray){
                if(jousterA.player != jousterB.player && !jousterB.isDead){
                    if([MathHelper circleCollisionPositionA:[jousterA getWorldPositionOfJoust]  raidusA:[jousterA joustRadius] positionB:jousterB.position radiusB:jousterB.bodyRadius] ){
                        
                        //jousterA got a kill
                        
                        //kill jousterB
                        jousterB.isDead = YES;
                        [self deathEffect:jousterB];
                        [jousterB removeFromParentAndCleanup:YES];
                    }
                    
                }
            }
        }
    }
    //blue joust hitting red dude
    /*if([MathHelper circleCollisionPositionA:[blueJouster getWorldPositionOfJoust]  raidusA:[blueJouster joustRadius] positionB:redJouster.position radiusB:redJouster.bodyRadius] ){
     winner = @"Blue Wins";
     blueWins++;
     didRedWinRound = NO;
     if(blueWins > 2){
     [self transitionToGameOver];
     }else{
     [self transitionToEndRound];
     }
     [self deathEffect:redJouster];
     [redJouster removeFromParentAndCleanup:YES];
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
     [self deathEffect:blueJouster];
     [self refreshUI];
     return YES;
     }
     return NO;*/
}

-(BOOL) jousterOnJousterCheck:(Jouster*) jouster{
    
    for(Jouster *jousterB in self.jousterArray){
        if(jousterB.player != jouster.player && !jousterB.isDead){
            //jousters hitting
            if( [MathHelper circleCollisionPositionA:[jouster getWorldPositionOfJoust]  raidusA:[jouster joustRadius] positionB:[jousterB getWorldPositionOfJoust] radiusB: [jousterB joustRadius]]){
                //bounce off eachother
                [jouster joustCollision: [jousterB getWorldPositionOfJoust] withRadius: jousterB.joustRadius];
                [jousterB joustCollision: [jouster getWorldPositionOfJoust] withRadius: jouster.joustRadius];
                [self spawnVortexAtPoint:ccpMidpoint([jouster getWorldPositionOfJoust] , [jousterB getWorldPositionOfJoust])];
                [self clashEffect:[jouster getWorldPositionOfJoust] otherPoint:[jousterB getWorldPositionOfJoust] withMagnitude:500 withStun:NO];
                return YES;
            }
        }
    }
    return NO;
}

-(void) testForVictory{
    for(Jouster *jousterA in self.jousterArray){
        if(!jousterA.isDead){
            BOOL didWin= YES;
            for(Jouster *jousterB in self.jousterArray){
                if(jousterA.player != jousterB.player){
                    if(!jousterB.isDead){
                        //if another player is alive, then the game goes on
                        didWin = NO;
                    }
                }
            }
            if(didWin){
                //the game is over jousterA won
                winner = [NSString stringWithFormat:@"player %i won", jousterA.player];
                jousterA.wins++;
                //TODO, figure out wtf this does
                lastWinner = jousterA.player;
                if(jousterA.wins > 2){
                    [self transitionToGameOver];
                }else{
                    [self transitionToEndRound];
                }
                [self refreshUI];
            }
        }
    }
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
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    for(Jouster *jouster in self.jousterArray){
        
        BOOL alreadyChosen = NO;
        
        CGRect touchArea;
        if(jouster.player == 1){
            touchArea = CGRectMake(0, winSize.height/2, EXTRA_CONTROL_OFFSET, winSize.height/2);
        }else if(jouster.player == 2){
            touchArea = CGRectMake(winSize.width - EXTRA_CONTROL_OFFSET, winSize.height/2, EXTRA_CONTROL_OFFSET, winSize.height/2);
        }else if(jouster.player == 3){
            touchArea = CGRectMake(winSize.width - EXTRA_CONTROL_OFFSET, 0, EXTRA_CONTROL_OFFSET, winSize.height/2);
        }else if(jouster.player == 4){
            touchArea = CGRectMake(0, 0, EXTRA_CONTROL_OFFSET, winSize.height/2);
        }
        
        for(UITouch* touch in touches){
            CGPoint location = [touch locationInView: [touch view]];
            location = [[CCDirector sharedDirector] convertToGL:location];
            
            if(CGRectContainsPoint(touchArea, location) && !alreadyChosen){
                [jouster touch:location];
                alreadyChosen = YES;
            }
        }
        if(!alreadyChosen){
            [jouster resetTouch];
        }
    }
    /*
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
     */
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    /*if(currentState != GAMEPLAY){
     return;
     }*/
    
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    for(Jouster *jouster in self.jousterArray){
        
        BOOL alreadyChosen = NO;
        
        CGRect touchArea;
        if(jouster.player == 1){
            touchArea = CGRectMake(0, winSize.height/2, EXTRA_CONTROL_OFFSET, winSize.height/2);
        }else if(jouster.player == 2){
            touchArea = CGRectMake(winSize.width - EXTRA_CONTROL_OFFSET, 0, EXTRA_CONTROL_OFFSET, winSize.height/2);
        }else if(jouster.player == 3){
            touchArea = CGRectMake(winSize.width - EXTRA_CONTROL_OFFSET, winSize.height/2, EXTRA_CONTROL_OFFSET, winSize.height/2);
        }else if(jouster.player == 4){
            touchArea = CGRectMake(0, winSize.height/2, EXTRA_CONTROL_OFFSET, winSize.height/2);
        }
                [jouster resetTouch];
        for(UITouch* touch in touches){
            CGPoint location = [touch locationInView: [touch view]];
            location = [[CCDirector sharedDirector] convertToGL:location];
            
            if(CGRectContainsPoint(touchArea, location) && !alreadyChosen){
                [jouster resetTouch];
                alreadyChosen = YES;
            }
        }
    }
    
    
    
    /*BOOL redAlreadyChosen = NO;
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
     */
}

- (void) ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    /*if(currentState != GAMEPLAY){
     return;
     }*/
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    for(Jouster *jouster in self.jousterArray){
        
        BOOL alreadyChosen = NO;
        
        CGRect touchArea;
        if(jouster.player == 1){
            touchArea = CGRectMake(0, winSize.height/2, EXTRA_CONTROL_OFFSET, winSize.height/2);
        }else if(jouster.player == 2){
            touchArea = CGRectMake(winSize.width - EXTRA_CONTROL_OFFSET, 0, EXTRA_CONTROL_OFFSET, winSize.height/2);
        }else if(jouster.player == 3){
            touchArea = CGRectMake(winSize.width - EXTRA_CONTROL_OFFSET, winSize.height/2, EXTRA_CONTROL_OFFSET, winSize.height/2);
        }else if(jouster.player == 4){
            touchArea = CGRectMake(0, winSize.height/2, EXTRA_CONTROL_OFFSET, winSize.height/2);
        }
        
                [jouster resetTouch];
        for(UITouch* touch in touches){
            CGPoint location = [touch locationInView: [touch view]];
            location = [[CCDirector sharedDirector] convertToGL:location];
            
            if(CGRectContainsPoint(touchArea, location) && !alreadyChosen){
                [jouster resetTouch];
                alreadyChosen = YES;
            }
        }
    }
    
    /*
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
     */
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
    //simulates the two centers smashing each other
    [self runAction:[CCShake actionWithDuration:.2f amplitude:ccp(20, 20) dampening:true shakes:0]];
    //reset the center sprite
    [centerSprite stopAllActions];
    centerSprite.opacity = 0;
    centerVisible = NO;
    if(currentState == GAME_START){
        for(Jouster *jouster in self.jousterArray){
            [jouster resetJouster];
        }
    }
    
    currentState = ROUND_START;
    //show names of fighters
    //CGSize winSize= [[CCDirector sharedDirector] winSize];
    //   CCLabelTTF *gameStartLabel = [[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"Round %d", currentRound] fontName:@"Marker Felt" fontSize:32] autorelease];
    //   gameStartLabel.position = ccp(winSize.width/2, winSize.height/2);
    //    [self addChild:gameStartLabel];
    //timeBeforeNewRoundStarts = TRANSITION_TIME;
    CCDelayTime *delay = [CCDelayTime actionWithDuration:.1];
    CCCallBlock *block = [CCCallBlock actionWithBlock:^{
        //      [self removeChild:gameStartLabel];
        [self transitionToGamePlay];
    }];
    CCSequence *seq = [CCSequence actionOne:delay two:block];
    [self runAction:seq];
    
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
    [self runAction:[CCShake actionWithDuration:.17f amplitude:ccp(10, 10) dampening:true shakes:0]];
}

-(void) deathEffect:(Jouster*) deadJouster{
    CCParticleSystemQuad *deathEffectJ = [[CCParticleSystemQuad alloc] initWithFile: @"jousterDeathParticle.plist"];
    deathEffectJ.position = [deadJouster getWorldPositionOfJoust];
    deathEffectJ.autoRemoveOnFinish = YES;
    [self addChild:deathEffectJ];
    CCParticleSystemQuad *deathEffect = [[CCParticleSystemQuad alloc] initWithFile: @"jousterDeathParticle.plist"];
    deathEffect.position = deadJouster.position;
    deathEffect.autoRemoveOnFinish = YES;
    [self addChild:deathEffect];
    [self runAction:[CCShake actionWithDuration:.35f amplitude:ccp(30, 30) dampening:true shakes:0]];
}

-(CCParticleSystemQuad*) vortexEffect:(CGPoint) pt{
    CCParticleSystemQuad *collisionEffect = [[CCParticleSystemQuad alloc] initWithFile: @"VortexEffect.plist"];
    collisionEffect.autoRemoveOnFinish = YES;
    collisionEffect.position = pt;
    [self addChild:collisionEffect];
    return collisionEffect;
}


@end
