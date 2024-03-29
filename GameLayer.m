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
#import "JousterE.h"
#import "JousterF.h"
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
#import "Player.h"
#import "HazardLayer.h"
#import "PlayerManager.h"
#import "JousterParticle.h"
#import "SimpleAudioEngine.h"

@implementation GameLayer


NSString *const MAIN_FONT = @"SourceSansPro-Light";
NSString *const SECOND_FONT = @"SourceSansPro-Regular";

@synthesize powerStone, vortexArray, lastWinner, jousterArray, touchParticleArray, hazardLayer, uiLayer;

-(id) init{
    if(self = [super initWithColor:COLOR_GAMEAREA_B4] ){
        CGSize winSize= [[CCDirector sharedDirector] winSize];
        //background particles
//        ccc3(195,185,170)
       /* CCParticleSystemQuad *bgParticles = [[CCParticleSystemQuad alloc] initWithFile: @"BackGroundParticles.plist"];
        bgParticles.position = ccp(winSize.width/2, winSize.height/2);
        bgParticles.posVar = ccp(winSize.width/2, winSize.height/2);
        bgParticles.startColor = ccc4f(230, 220, 210, 20);
        bgParticles.endColor = ccc4f(230, 220, 210, 20);
        [self addChild:bgParticles];
       */
        

        self.vortexArray = [[[NSMutableArray alloc] init] autorelease];
        self.touchParticleArray = [[[NSMutableArray alloc] init] autorelease];
        
        self.uiLayer = [[[UILayer alloc] initWithGameLayer:self] autorelease];
        [self addChild:uiLayer z:10];
        self.hazardLayer = [[[HazardLayer alloc] initWithGameLayer:self] autorelease];
        [self addChild:hazardLayer z:5];
        SimpleAudioEngine* SAE = [SimpleAudioEngine sharedEngine];
        [SAE setBackgroundMusicVolume:0.3];
        [SAE playBackgroundMusic:@"funky_drum_and_bass.mp3" loop:YES];
        //labels to display who is winning
        
        [self scheduleUpdate];
        _touchEnabled = YES;
        currentRound = 0;
        _touchMode = NO;
        

        
        centerLabel = [[[CCLabelTTF alloc] initWithString:@"closest to center wins" fontName:MAIN_FONT fontSize:36] autorelease];
        centerLabel.color = COLOR_GAMEBORDER;
        centerLabel.position = ccp(winSize.width/2, 100);
        centerLabel.visible = NO;
        [self addChild:centerLabel z:1];
        
        self.jousterArray = [[[NSMutableArray alloc] init] autorelease];
        PlayerManager *PM = [PlayerManager sharedInstance];
        for(Player *player in PM.playerArray){
            if(player.isActive){
                Jouster *jouster = [self createJouster:player.jousterType WithPlayer:player];
                jouster.gameLayer = self;
                jouster.player = player;
                [jouster makeTail];
                [self.jousterArray addObject:jouster];
                [jouster resetJouster];
                jouster.visible = NO;
                [self addChild:jouster z:2];
            }
        }
        
        victorySprite = [CCSprite spriteWithSpriteFrameName:@"victoryRay"];
        victorySprite.visible = NO;
        victorySprite.opacity = 255;
        [self addChild:victorySprite z:0];
        
        whiteOverlay = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255)];
        whiteOverlay.opacity = 0;
        [self addChild:whiteOverlay z:1000];
        
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
        
        for(int i = 0; i < 4; i++){
            JousterParticle *touchParticle = [[JousterParticle alloc] initWithFile: @"touchStreak.plist"];
            touchParticle.startSize = 70;
            [touchParticle stopSystem];
            [uiLayer addChild:touchParticle];
            [self.touchParticleArray addObject:touchParticle];
        }
        
        gameSpeed = [PM getGameSpeedScaler];
        
        
        [self gameIntro];
        
    }
    return self;
}


-(void) dealloc{
    [vortexArray release];
    [jousterArray release];
    [touchParticleArray release];
    [super dealloc];
}


-(void) addMoveLabels{
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    for(Jouster *jouster in self.jousterArray){
        int player = jouster.player.playerNumber;
        CCLabelTTF *moveLabel = [[[CCLabelTTF alloc] initWithString:@"slide finger here\nto move" fontName:MAIN_FONT fontSize:24] autorelease];
        moveLabel.color = COLOR_GAMEBORDER;
        CGPoint pos;
        if(player == 0){
            moveLabelOne = moveLabel;
            pos = ccp(CONTROL_OFFSET/2, winSize.height - 220);
        }else if(player == 1){
            moveLabelTwo = moveLabel;
            pos = ccp(winSize.width - CONTROL_OFFSET/2, winSize.height - 220);
        }else if(player == 2){
            moveLabelThree = moveLabel;
            pos = ccp(winSize.width - CONTROL_OFFSET/2, 220);
        }else if( player == 3){
            moveLabelFour = moveLabel;
            pos = ccp(CONTROL_OFFSET/2, 220);
        }
        moveLabel.position = pos;
        [self.uiLayer addChild:moveLabel z:3000];
    }
}

-(Jouster*) getJousterWithPlayerNumber:(int) playerNumber{
    for(Jouster *jouster in self.jousterArray){
        if(jouster.player.playerNumber == playerNumber){
            return jouster;
        }
    }
    return nil;
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
    Vortex *vortex = [[[Vortex alloc] init] autorelease];
    
    vortex.position = point;
    [self addChild:vortex];
    [self.vortexArray addObject:vortex];
    vortex.pEffect = [self vortexEffect:point];
}


-(Jouster*) createJouster:(int) character WithPlayer:(Player*) player{
    if(character == 0 ){
        return [[[JousterB alloc] initWithPlayer:player] autorelease];
    }else if(character == 1){
        return [[[JousterA alloc] initWithPlayer:player] autorelease];
    }else if(character ==2 ){
        return [[[JousterC alloc] initWithPlayer:player] autorelease];
    }else if(character == 3){
        return [[[JousterE alloc] initWithPlayer:player] autorelease];
    }else if(character == 4){
        return [[[JousterF alloc] initWithPlayer:player] autorelease];
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
    [uiLayer refreshUI];
    
    
}

-(void) refreshUI{
    [uiLayer refreshVictoryPoint];
    [uiLayer refreshUI];
    centerSprite.scale = 1;
    [hazardLayer resetLayer];
    centerLabel.visible = NO;
    [self deactiveSlow];
}

-(void) activateSlow{
    tempSlowTimer = .15;
    isSlowedDown = YES;
    ///    self.color = ccBLACK;
}

-(void) deactiveSlow{
    isSlowedDown = NO;
    tempSlowTimer = -0.2;
    self.color = COLOR_GAMEAREA;
}

-(void) update:(ccTime)dt{
    if(currentState == GAMEPLAY){
        dt *= gameSpeed;
        if(tempSlowTimer > 0){
            tempSlowTimer -= dt;
            
            //            dt *= .1;
            if(tempSlowTimer <= 0){
                //undo slow stuff
                [self deactiveSlow];
            }
            return;
        }
        
        [hazardLayer update: dt];
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
        
        /*        for(Jouster *jouster in self.jousterArray){
         [jouster update:dt];
         jouster.position = ccpAdd(jouster.position, ccpMult(jouster.velocity, dt));
         jouster.jousterSprite.position = ccpAdd(jouster.joustPosition,  ccpMult(jouster.joustVelocity, dt));
         [jouster checkBoundaries];
         }
         */
        
    }else if(currentState == ROUND_END){
        dt = dt/3;
        for(Jouster *jouster in self.jousterArray){
            [jouster update:dt];
            jouster.position = ccpAdd(jouster.position, ccpMult(jouster.velocity, dt));
            jouster.jousterSprite.position = ccpAdd(jouster.joustPosition,  ccpMult(jouster.joustVelocity, dt));
            [jouster checkBoundaries];
        }
        if(winningJouster){
            victorySprite.position =  winningJouster.position;
        }
    }else if(currentState == GAME_OVER){
        dt = dt/3;
        for(Jouster *jouster in self.jousterArray){
            [jouster update:dt];
            jouster.position = ccpAdd(jouster.position, ccpMult(jouster.velocity, dt));
            jouster.jousterSprite.position = ccpAdd(jouster.joustPosition,  ccpMult(jouster.joustVelocity, dt));
            //            [jouster checkBoundaries];
        }
        if(winningJouster){
            victorySprite.position =  winningJouster.position;
        }
    }else if(currentState == GAME_START){
        dt = dt/3;
        for(Jouster *jouster in self.jousterArray){
            [jouster update:dt];
            jouster.position = ccpAdd(jouster.position, ccpMult(jouster.velocity, dt));
            jouster.jousterSprite.position = ccpAdd(jouster.joustPosition,  ccpMult(jouster.joustVelocity, dt));
            [jouster checkBoundaries];
        }
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
                    jouster.position = ccpAdd(jouster.position, ccpMult(ccpAdd(jouster.velocity, jouster.outsideVelocity), dt/COLLISION_STEPS));
                    bodyHit = [self bodyOnBodyCheck:jouster];
                    [jouster checkBoundaries];
                }
            }
        }
        
        //step jouster position
        if(!joustersHit){
            
            for(Jouster *jouster in self.jousterArray){
                if(!jouster.isDead){
                    jouster.jousterSprite.position = ccpAdd(jouster.joustPosition,  ccpMult(ccpAdd(jouster.joustVelocity, jouster.joustOutsideVelocity), dt/COLLISION_STEPS));
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
            centerLabel.visible = YES;
            CCFadeIn *fadeIn = [CCFadeIn actionWithDuration:2 * 1/gameSpeed];
            CCRotateBy *rotate = [CCRotateBy actionWithDuration:20 * 1/gameSpeed angle:1000];
            CCScaleTo *scale = [CCScaleTo actionWithDuration:5.0 * 1/gameSpeed scale:0];
            
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
                if(redDistance < VORTEX_DISTANCE){
                    //normalized direction to vortex
                    CGPoint redToVortex = ccpNormalize(ccpSub(vortex.position, jouster.position));
                    
                    float maxDistance = VORTEX_DISTANCE;
                    float redPullPower = maxDistance - redDistance;
                    //                redPullPower = redPullPower * redPullPower;
                    // adjust the strength of the vortex
                    //              redPullPower = redPullPower/77;
                    redPullPower = 600;
                    
                    CGPoint redVortexVel = ccpMult(redToVortex, redPullPower);
                    
                    //add vortex velocity to jouster's velocity
                    jouster.outsideVelocity = ccpAdd(jouster.outsideVelocity,ccpMult(redVortexVel, dt));
                }
            }
        }
        [vortex update:dt];
    }
    
    //delete old vortex
    for(int i = [self.vortexArray count] - 1; i >= 0; i-- ){
        Vortex *vortex = [self.vortexArray objectAtIndex:i];
        if(vortex.timeAlive > VORTEX_LIFE){
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
                playerWithShortestDistance = jouster.player.playerNumber;
            }
        }
    }
    
    //kill all players that are not closest to the center
    for(Jouster *jouster in self.jousterArray){
        if(jouster.player.playerNumber != playerWithShortestDistance){
            jouster.isDead = YES;
            [self deathEffect:jouster];
            [jouster removeFromParentAndCleanup:YES];
            [uiLayer refreshUI];
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

-(void) incrementWinsForTeam:(int) team{
    for(Jouster *jouster in self.jousterArray){
        if(jouster.player.team == team){
            jouster.wins++;
        }
    }
}

-(int) getWinsForTeam:(int) team{
    for(Jouster *jouster in self.jousterArray){
        if(jouster.player.team == team){
            return jouster.wins;
        }
    }
    NSLog(@"super bug here");
    return 0;
}

-(void) testForVictory{
    //test for Tie
    int aliveCount = 0;
    for(Jouster *jousterA in self.jousterArray){
        if(!jousterA.isDead){
            aliveCount++;
        }
    }
    
    //we have a tie
    if(aliveCount < 1){
        //the game is over jousterA won
        winner = [NSString stringWithFormat:@"TIE"];
        [self transitionToEndRound];
        [self refreshUI];
        return;
        
    }
    for(Jouster *jousterA in self.jousterArray){
        if(!jousterA.isDead){
            BOOL didWin= YES;
            for(Jouster *jousterB in self.jousterArray){
                //test for team
                BOOL isTeammate = NO;
                if([PlayerManager sharedInstance].isTeamPlay){
                    if(jousterA.player.team == jousterB.player.team){
                        isTeammate = YES;
                    }
                }
                if(jousterA.player.playerNumber != jousterB.player.playerNumber && !isTeammate){
                    if(!jousterB.isDead){
                        //if another player is alive, then the game goes on
                        didWin = NO;
                    }
                }
            }
            if(didWin){
                //the game is over jousterA won
                
                if([PlayerManager sharedInstance].isTeamPlay){
                    [self incrementWinsForTeam:jousterA.player.team];
                    lastWinner = jousterA.player.team;
                }else{
                    jousterA.wins++;
                    lastWinner = jousterA.player.playerNumber;
                }
                winner = [NSString stringWithFormat:@"player %i won", lastWinner];
                
                if(jousterA.wins > 2){
                    [self transitionToGameOver];
                }else{
                    [self transitionToEndRound];
                }
                [self refreshUI];
                //stop doing stuff here
                return;
            }
        }
    }
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
        if(jousterB.player.playerNumber != jouster.player.playerNumber && !jousterB.isDead){
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
                if(jousterA.player.playerNumber != jousterB.player.playerNumber && !jousterB.isDead){
                    if([MathHelper circleCollisionPositionA:[jousterA getWorldPositionOfJoust]  raidusA:[jousterA joustRadius] positionB:jousterB.position radiusB:jousterB.bodyRadius] ){
                        //jousterA got a kill
                        //kill jousterB
                        [jousterA joustCollision: jousterB.position withRadius: jousterB.bodyRadius];
                        jousterB.isDead = YES;
                        [self clashEffect:[jousterA getWorldPositionOfJoust] otherPoint:jousterB.position withMagnitude:1000 withStun:NO];
                        [self deathEffect:jousterB];
                        [jousterB removeFromParentAndCleanup:YES];
                        [jousterB update:0.001];
                        [self activateSlow];
                        [uiLayer refreshUI];
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
        if(jousterB.player.playerNumber != jouster.player.playerNumber && !jousterB.isDead){
            //jousters hitting
            if(!jousterB.isJousterInactive && !jouster.isJousterInactive){
                if( [MathHelper circleCollisionPositionA:[jouster getWorldPositionOfJoust]  raidusA:[jouster joustRadius] positionB:[jousterB getWorldPositionOfJoust] radiusB: [jousterB joustRadius]]){
                    //bounce off eachother
                    [jouster joustCollision: [jousterB getWorldPositionOfJoust] withRadius: jousterB.joustRadius];
                    [jousterB joustCollision: [jouster getWorldPositionOfJoust] withRadius: jouster.joustRadius];
                    [self spawnVortexAtPoint:ccpMidpoint([jouster getWorldPositionOfJoust] , [jousterB getWorldPositionOfJoust])];
                    [self clashEffect:[jouster getWorldPositionOfJoust] otherPoint:[jousterB getWorldPositionOfJoust] withMagnitude:500 withStun:NO];
                    [self activateSlow];
                    return YES;
                }
            }
        }
    }
    return NO;
}



-(void) checkBodyOnBodyStun:(Jouster *) jousterA otherJouster:(Jouster *)jousterB{
    //get normalized vector pointing at enemy
    CGPoint redToBlue = ccpNormalize(ccpSub(jousterA.position, jousterB.position));
    CGPoint blueToRed = ccpMult(redToBlue, -1);
    
    //    NSLog(@"redToBLUE %f, %f",redToBlue.x, redToBlue.y);
    
    //multiply normalized vector by bodies velocity
    CGPoint redRelativeVelocity = ccp(redToBlue.x * (jousterA.velocity.x + jousterA.outsideVelocity.x), redToBlue.y * (jousterA.velocity.y + jousterA.outsideVelocity.y));
    CGPoint blueRelativeVelocity = ccp(blueToRed.x * (jousterB.velocity.x + jousterB.outsideVelocity.x), blueToRed.y * (jousterB.velocity.y  + jousterB.outsideVelocity.y));
    
    //check if magnitude of that number is high enough to cause stun damage
    float redMagnitude = ccpLength(redRelativeVelocity);
    float blueMagnitude = ccpLength(blueRelativeVelocity);
    BOOL isStun = NO;
    //  NSLog(@"redMag   %f", redMagnitude);
    //  NSLog(@"blueMag %f", blueMagnitude);
    
    //ensures only 1 player gets stunned on collision
//        ccBlendFunc blend = {GL_DST_COLOR, GL_ONE};
    
    CCSprite * stunEffect = [CCSprite spriteWithSpriteFrameName:@"spikeWall"];;
//    stunEffect.anchorPoint = ccp(0.0, 0.0);
    if(redMagnitude > blueMagnitude){
        
        //hit effect

//        float rotation = [MathHelper degreeAngleBetween:jousterA.position and:jousterB.position];
//        CGPoint norm = ccpNormalize(jousterB.velocity);
//        float rotation = CC_RADIANS_TO_DEGREES(atan2(norm.y, norm.x));
//
//        NSLog(@"rotation %f", rotation);
//        /*if(rotation < 0){
//            rotation = -rotation - 90;
//        }*/
//        stunEffect.rotation = -rotation - 90;
//        CGPoint midPoint = ccpMidpoint(jousterA.position, jousterB.position);
//        CGPoint newPos = ccp(midPoint.x - jousterB.position.x, midPoint.y - jousterB.position.y);
//        stunEffect.position = newPos;
//    
////        [jousterB setBlendFunc:blend];
//        [jousterB addChild:stunEffect];
        //set timer
        
        
        if(redMagnitude > STUN_CONTRAINT){
            // stun blue
            [jousterB stunBody];
            isStun = YES;
            [self activateSlow];
        }
        
    }else{
//        float rotation = [MathHelper degreeAngleBetween:jousterB.position and:jousterA.position];
//        CGPoint norm = ccpNormalize(jousterA.velocity);
//        float rotation = CC_RADIANS_TO_DEGREES(atan2(norm.y, norm.x));
//
//        NSLog(@"rotation %f", rotation);
//        stunEffect.rotation = -rotation - 90;
//        CGPoint midPoint = ccpMidpoint(jousterA.position, jousterB.position);
//        CGPoint newPos = ccp(midPoint.x - jousterA.position.x, midPoint.y - jousterA.position.y);
//        stunEffect.position = newPos;
//
////        [jousterA setBlendFunc:blend];
//        [jousterA addChild:stunEffect];
        
        if(blueMagnitude > STUN_CONTRAINT){
            // stun red
            [jousterA stunBody];
            isStun = YES;
            [self activateSlow];
        }
    }
    
//    CCDelayTime *delayAnim = [CCDelayTime actionWithDuration:.5];
//    CCCallBlock *blockAnim = [CCCallBlock actionWithBlock:^{
//        [stunEffect removeFromParentAndCleanup:YES];
//    }];
//    CCSequence *seqAnim = [CCSequence actionOne:delayAnim two:blockAnim];
//    [stunEffect runAction:seqAnim];
    
    
    
    //bounce off eachother
    //get direction
    CGPoint offset = ccpSub(jousterA.position, jousterB.position);
    offset = [MathHelper normalize:offset];
    offset = ccpMult(offset, 1.2);
    CGPoint redKnock = ccpMult(offset, blueMagnitude + 30);
    jousterA.velocity = redKnock;
    jousterA.outsideVelocity = redKnock;
    offset = ccpMult(offset, -1);
    CGPoint blueKnock = ccpMult(offset, redMagnitude + 30);
    jousterB.velocity = blueKnock;
    jousterB.outsideVelocity = blueKnock;
    
    [self clashEffect:jousterA.position otherPoint:jousterB.position withMagnitude:blueMagnitude + redMagnitude + 500 withStun:isStun];
    
}


#pragma mark - touch code
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    if(currentState == GAME_OVER || currentState == GAME_START){
        return NO;
    }
    return YES;
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    for(Jouster *jouster in self.jousterArray){
        BOOL alreadyChosen = NO;
        float reducedSpace = 30;
        CGRect touchArea;
        JousterParticle *touchParticle = [self.touchParticleArray objectAtIndex:jouster.player.playerNumber];
        if(jouster.player.playerNumber == 0){
            touchArea = CGRectMake(0, winSize.height/2 + reducedSpace, EXTRA_CONTROL_OFFSET, winSize.height/2);
        }else if(jouster.player.playerNumber == 1){
            touchArea = CGRectMake(winSize.width - EXTRA_CONTROL_OFFSET, winSize.height/2 + reducedSpace, EXTRA_CONTROL_OFFSET, winSize.height/2);
        }else if(jouster.player.playerNumber == 2){
            touchArea = CGRectMake(winSize.width - EXTRA_CONTROL_OFFSET, 0, EXTRA_CONTROL_OFFSET, winSize.height/2 - reducedSpace);
        }else if(jouster.player.playerNumber == 3){
            touchArea = CGRectMake(0, 0, EXTRA_CONTROL_OFFSET, winSize.height/2 - reducedSpace);
        }
        if(uiLayer.isLeftSingle){
            if(jouster.player.playerNumber == uiLayer.leftPlayer){
                touchArea =CGRectMake(0, 0, EXTRA_CONTROL_OFFSET, winSize.height);
            }
        }
        
        if(uiLayer.isRightSingle){
            if(jouster.player.playerNumber == uiLayer.rightPlayer){
                touchArea =CGRectMake(winSize.width - EXTRA_CONTROL_OFFSET, 0, EXTRA_CONTROL_OFFSET, winSize.height);
            }
        }
        
        for(UITouch* touch in touches){
            CGPoint location = [touch locationInView: [touch view]];
            location = [[CCDirector sharedDirector] convertToGL:location];
            
            if(CGRectContainsPoint(touchArea, location) && !alreadyChosen){
                if([jouster doesTouchDeltaMakeSense:location]){
                    //remove touch instuctions
                    if(jouster.player.playerNumber == 0){
                        if(moveLabelOne){
                            [moveLabelOne removeFromParentAndCleanup:YES];
                            moveLabelOne = nil;
                        }
                    }else if(jouster.player.playerNumber == 1){
                        if(moveLabelTwo){
                            [moveLabelTwo removeFromParentAndCleanup:YES];
                            moveLabelTwo = nil;
                        }
                    }else if(jouster.player.playerNumber == 2){
                        if(moveLabelThree){
                            [moveLabelThree removeFromParentAndCleanup:YES];
                            moveLabelThree = nil;
                        }
                    }else if(jouster.player.playerNumber == 3){
                        if(moveLabelFour){
                            [moveLabelFour removeFromParentAndCleanup:YES];
                            moveLabelFour = nil;
                        }
                    }
                    
                    
                    [jouster touch:location];
                    touchParticle.position = location;
                    if(!touchParticle.active){
                        [touchParticle resetSystem];
                    }
                    alreadyChosen = YES;
                }
            }
        }
        if(!alreadyChosen){
            [jouster resetTouch];
        }
    }
    
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    for(Jouster *jouster in self.jousterArray){
        
        BOOL alreadyChosen = NO;
        
        float reducedSpace = 30;
        CGRect touchArea;
        //        CGRect strictFirstTouchArea;
        if(jouster.player.playerNumber == 0){
            touchArea = CGRectMake(0, winSize.height/2 + reducedSpace, EXTRA_CONTROL_OFFSET, winSize.height/2);
        }else if(jouster.player.playerNumber == 1){
            touchArea = CGRectMake(winSize.width - EXTRA_CONTROL_OFFSET, winSize.height/2 + reducedSpace, EXTRA_CONTROL_OFFSET, winSize.height/2);
        }else if(jouster.player.playerNumber == 2){
            touchArea = CGRectMake(winSize.width - EXTRA_CONTROL_OFFSET, 0, EXTRA_CONTROL_OFFSET, winSize.height/2 - reducedSpace);
        }else if(jouster.player.playerNumber == 3){
            touchArea = CGRectMake(0, 0, EXTRA_CONTROL_OFFSET, winSize.height/2 - reducedSpace);
        }
        if(uiLayer.isLeftSingle){
            if(jouster.player.playerNumber == uiLayer.leftPlayer){
                touchArea =CGRectMake(0, 0, EXTRA_CONTROL_OFFSET, winSize.height);
            }
        }
        
        if(uiLayer.isRightSingle){
            if(jouster.player.playerNumber == uiLayer.rightPlayer){
                touchArea =CGRectMake(winSize.width - EXTRA_CONTROL_OFFSET, 0, EXTRA_CONTROL_OFFSET, winSize.height);
            }
        }
        
        [jouster resetTouch];
        for(UITouch* touch in touches){
            CGPoint location = [touch locationInView: [touch view]];
            location = [[CCDirector sharedDirector] convertToGL:location];
            
            if(CGRectContainsPoint(touchArea, location) && !alreadyChosen){
                alreadyChosen = YES;
            }
        }
    }
}

- (void) ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    for(Jouster *jouster in self.jousterArray){
        BOOL alreadyChosen = NO;
        float reducedSpace = 30;
        CGRect touchArea;
        //        CGRect strictFirstTouchArea;
        if(jouster.player.playerNumber == 0){
            touchArea = CGRectMake(0, winSize.height/2 + reducedSpace, EXTRA_CONTROL_OFFSET, winSize.height/2);
        }else if(jouster.player.playerNumber == 1){
            touchArea = CGRectMake(winSize.width - EXTRA_CONTROL_OFFSET, winSize.height/2 + reducedSpace, EXTRA_CONTROL_OFFSET, winSize.height/2);
        }else if(jouster.player.playerNumber == 2){
            touchArea = CGRectMake(winSize.width - EXTRA_CONTROL_OFFSET, 0, EXTRA_CONTROL_OFFSET, winSize.height/2 - reducedSpace);
        }else if(jouster.player.playerNumber == 3){
            touchArea = CGRectMake(0, 0, EXTRA_CONTROL_OFFSET, winSize.height/2 - reducedSpace);
        }
        if(uiLayer.isLeftSingle){
            if(jouster.player.playerNumber == uiLayer.leftPlayer){
                touchArea =CGRectMake(0, 0, EXTRA_CONTROL_OFFSET, winSize.height);
            }
        }
        
        if(uiLayer.isRightSingle){
            if(jouster.player.playerNumber == uiLayer.rightPlayer){
                touchArea =CGRectMake(winSize.width - EXTRA_CONTROL_OFFSET, 0, EXTRA_CONTROL_OFFSET, winSize.height);
            }
        }
        
        [jouster resetTouch];
        for(UITouch* touch in touches){
            CGPoint location = [touch locationInView: [touch view]];
            location = [[CCDirector sharedDirector] convertToGL:location];
            
            if(CGRectContainsPoint(touchArea, location) && !alreadyChosen){
                alreadyChosen = YES;
            }
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
    CCLabelTTF *gameStartLabel = [[[CCLabelTTF alloc] initWithString:@"" fontName:MAIN_FONT fontSize:32] autorelease];
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
        [self addMoveLabels];
    }];
    CCSequence *seq = [CCSequence actionOne:delay two:block];
    [gameStartLabel runAction:seq];
}


-(void) transitionToStartRound{
    currentRound++;
    victorySprite.visible = NO;
    //simulates the two centers smashing each other
    [self runAction:[CCShake actionWithDuration:.2f amplitude:ccp(20, 20) dampening:true shakes:0]];
    //reset the center sprite
    [centerSprite stopAllActions];
    centerSprite.opacity = 0;
    centerSprite.scale = 1;
    centerVisible = NO;
    if(currentState == GAME_START){
        for(Jouster *jouster in self.jousterArray){
            [jouster resetJouster];
        }
    }
    [uiLayer refreshUI];
    //hack to reset jousters visually
    currentState = GAMEPLAY;
    [self update:0.00];
    
    currentState = ROUND_START;
    //show names of fighters
    //CGSize winSize= [[CCDirector sharedDirector] winSize];
    //   CCLabelTTF *gameStartLabel = [[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"Round %d", currentRound] fontName:@"Marker Felt" fontSize:32] autorelease];
    //   gameStartLabel.position = ccp(winSize.width/2, winSize.height/2);
    //    [self addChild:gameStartLabel];
    //timeBeforeNewRoundStarts = TRANSITION_TIME;
    CCDelayTime *delay = [CCDelayTime actionWithDuration:0.8];
    CCCallBlock *block = [CCCallBlock actionWithBlock:^{
        //      [self removeChild:gameStartLabel];
        [self transitionToGamePlay];
    }];
    CCSequence *seq = [CCSequence actionOne:delay two:block];
    [self runAction:seq];
    
}

-(void) transitionToGamePlay{
    [self refreshUI];
    SimpleAudioEngine* SAE = [SimpleAudioEngine sharedEngine];
    [SAE setBackgroundMusicVolume:0.3];
    currentState = GAMEPLAY;
}

-(void) transitionToEndRound{
    
    SimpleAudioEngine* SAE = [SimpleAudioEngine sharedEngine];
    [SAE setBackgroundMusicVolume:0.1];
    [SAE playEffect:@"jack_1.mp3" pitch:1.0 pan:0.0 gain:1.0];

    currentState = ROUND_END;
    centerLabel.visible = NO;
    //show names of fighters
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    CCLabelTTF *gameStartLabel = [[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%@ Round", winner] fontName:@"MAIN_FONT" fontSize:32] autorelease];
    gameStartLabel.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:gameStartLabel];
    
    //animation
    CCDelayTime *delayAnim = [CCDelayTime actionWithDuration:2];
    CCCallBlock *blockAnim = [CCCallBlock actionWithBlock:^{
        [uiLayer smashTopBottomAlreadyInPlace:YES];
    }];
    CCSequence *seqAnim = [CCSequence actionOne:delayAnim two:blockAnim];
    [gameStartLabel runAction:seqAnim];
    
    
    //victory effect
    Jouster *winnerJouster = nil;
    for(Jouster *jouster in self.jousterArray){
        if(!jouster.isDead){
            winnerJouster = jouster;
        }
    }
    winningJouster = nil;
    if(winnerJouster){
        [victorySprite stopAllActions];
        CCRotateBy *rotate = [CCRotateBy actionWithDuration:20 * 1/gameSpeed angle:1500];
        [victorySprite runAction:rotate];
        victorySprite.color = winnerJouster.bodyInnerSprite.color;
        victorySprite.position = winnerJouster.position;
        victorySprite.visible = YES;
        winningJouster = winnerJouster;
        //white flash
        CCFadeOut *fadeout = [CCFadeOut actionWithDuration:.4];
        [whiteOverlay runAction:fadeout];;
    }
    
    CCDelayTime *delay = [CCDelayTime actionWithDuration:3];
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
    centerLabel.visible = NO;
    victorySprite.visible = NO;
    SimpleAudioEngine* SAE = [SimpleAudioEngine sharedEngine];
    [SAE setBackgroundMusicVolume:0.1];
    [SAE playEffect:@"jack_1.mp3" pitch:1.0 pan:0.0 gain:1.0];
    //say who won
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    //victory effect
    Jouster *winnerJouster = nil;
    for(Jouster *jouster in self.jousterArray){
        if(!jouster.isDead){
            winnerJouster = jouster;
        }
    }
    winningJouster = nil;
    if(winnerJouster){
        [victorySprite stopAllActions];
        CCRotateBy *rotate = [CCRotateBy actionWithDuration:20 * 1/gameSpeed angle:1500];
        [victorySprite runAction:rotate];
        victorySprite.color = winnerJouster.bodyInnerSprite.color;
        victorySprite.position = winnerJouster.position;
        victorySprite.visible = YES;
        winningJouster = winnerJouster;
        //white flash
        CCFadeOut *fadeout = [CCFadeOut actionWithDuration:.4];
        [whiteOverlay runAction:fadeout];;
    }
    
    
    
    [uiLayer animateTouchAreasOut];
    CCDelayTime *delay = [CCDelayTime actionWithDuration:TRANSITION_TIME + 3];
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
    
    //play sound
    SimpleAudioEngine* SAE = [SimpleAudioEngine sharedEngine];

    ccColor4F effectColor = ccc4f(1, 1, 1, 1);
    if(stun){
        effectColor = ccc4f(0.0, 0.0, 0, 1);
        [SAE playEffect:@"wood_hit_aluminium_heavy_1.mp3" pitch:0.8 pan:0.0 gain:.3];
    }else{
        [SAE playEffect:@"wood_hit_metal_heavy_1.mp3" pitch:0.8 pan:0.0 gain:.2];
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

-(void) clashWeakEffect:(CGPoint) p1 otherPoint:(CGPoint) p2 withMagnitude:(float) magnitude withStun:(BOOL) stun{
    
    SimpleAudioEngine* SAE = [SimpleAudioEngine sharedEngine];
    float soundVariety = .5 + .4/(3+arc4random()%4);
    [SAE playEffect:@"wood_hit_brick_1.mp3" pitch:soundVariety pan:0.0 gain:.4];

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
    [self runAction:[CCShake actionWithDuration:.11f amplitude:ccp(5, 5) dampening:true shakes:0]];
}

-(void) deathEffect:(Jouster*) deadJouster{
    SimpleAudioEngine* SAE = [SimpleAudioEngine sharedEngine];
    [SAE playEffect:@"wood_hit_metal_heavy_1.mp3" pitch:1.3 pan:0.0 gain:.7];
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
