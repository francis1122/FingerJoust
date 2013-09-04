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



@implementation GameLayer

@synthesize powerStone;

-(id) initWithPlayerOne:(int) characterOne playerTwo:(int) characterTwo{
    if(self = [super initWithColor:ccc4(50, 50, 50, 255)] ){
        CGSize winSize= [[CCDirector sharedDirector] winSize];
        
        redLayer = [CCLayerColor layerWithColor:ccc4(255, 200, 200, 255) width:CONTROL_OFFSET height:winSize.height];
        redLayer.position = ccp(0, 0);
        [self addChild: redLayer];
        blueLayer = [CCLayerColor layerWithColor:ccc4(200, 200, 255, 255) width:CONTROL_OFFSET height:winSize.height];
        blueLayer.position = ccp(winSize.width - blueLayer.contentSize.width, 0);
        [self addChild:blueLayer];
        
        redBorderLayer = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255) width:40 height:winSize.height];
        redBorderLayer.position = ccp(CONTROL_OFFSET - redBorderLayer.contentSize.width, 0);
        [self addChild:redBorderLayer];
        blueBorderLayer = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255) width:40 height:winSize.height];
        blueBorderLayer.position = ccp(winSize.width - CONTROL_OFFSET, 0);
        [self addChild:blueBorderLayer];
        
        //labels to display who is winning
        redWinsLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Marker Felt" fontSize:64];
        redWinsLabel.color = ccRED;
        redWinsLabel.position = ccp(winSize.width/2 - 50, 50);
        blueWinsLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Marker Felt" fontSize:64];
        blueWinsLabel.position = ccp(winSize.width/2 + 50, 50);
        blueWinsLabel.color = ccBLUE;
        
        [self addChild:redWinsLabel];
        [self addChild:blueWinsLabel];
        

        
        //powerstones display labels
        redPowerStonesLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Marker Felt" fontSize:32];
        redPowerStonesLabel.color = ccRED;
        redPowerStonesLabel.position = ccp(150, 50);
        bluePowerStonesLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Marker Felt" fontSize:32];
        bluePowerStonesLabel.position = ccp(winSize.width - 150, 50);
        bluePowerStonesLabel.color = ccBLUE;
        
        [self addChild:redPowerStonesLabel];
        [self addChild:bluePowerStonesLabel];
        
        
        [self scheduleUpdate];
        _touchEnabled = YES;
        currentRound = 0;
        _touchMode = NO;
        
        redJouster = [self createJouster:characterOne];
        redJouster.player = 1;
        //shader tests
        
        /*
        const GLchar * fragmentSource = (GLchar*) [[NSString stringWithContentsOfFile:[[CCFileUtils sharedFileUtils] fullPathForFilename:@"Touch.fsh"] encoding:NSUTF8StringEncoding error:nil] UTF8String];
        const GLchar * vertexSource = (GLchar*) [[NSString stringWithContentsOfFile:[[CCFileUtils sharedFileUtils] fullPathForFilename:@"Touch.vsh"] encoding:NSUTF8StringEncoding error:nil] UTF8String];
        self.shaderProgram = [[CCGLProgram alloc] initWithVertexShaderByteArray:ccPositionColor_vert
                                                                 fragmentShaderByteArray:fragmentSource];
        
        [self.shaderProgram addAttribute:kCCAttributeNamePosition
                                            index:kCCVertexAttrib_Position];
        [self.shaderProgram addAttribute:kCCAttributeNameColor
                                            index:kCCVertexAttrib_Color];
        
        [self.shaderProgram addAttribute:kCCAttributeNameTexCoord
                                            index:kCCVertexAttrib_TexCoords];
        [self.shaderProgram link];
        [self.shaderProgram updateUniforms];
        
        
        */
        
        
        
        blueJouster =  [self createJouster:characterTwo];
        blueJouster.player = 2;
        
        [redJouster resetJouster];
        [blueJouster resetJouster];
        
        [self addChild:redJouster];
        [self addChild:blueJouster];
        
        self.powerStone = [[PowerStone alloc] init];
        //has to be called after jousters have been added
        [self spawnPowerStone];
        
        displayedTime = ROUND_TIME;
        roundTimer = ROUND_TIME;
        timerLabel = [CCLabelTTF labelWithString:@"10" fontName:@"Marker Felt" fontSize:32];
        timerLabel.position = ccp(winSize.width/2, 720);
        [self addChild:timerLabel];

        centerSprite = [CCSprite spriteWithSpriteFrameName:@"BodyOuter"];
        centerSprite.visible = NO;
        centerSprite.position = ccp(winSize.width/2, winSize.height/2);
        centerSprite.color = ccYELLOW;
        [self addChild:centerSprite];

        [self gameIntro];
    }
    return self;
}


-(void) spawnPowerStone{
    
    [self.powerStone removeFromParent];
    //make sure power stone
    
    //make sure stone doesn't spawn too close to either of the players
    BOOL validSpawnPosition = NO;
    while(!validSpawnPosition){
        validSpawnPosition = YES;
        [self.powerStone randomSpot];
        
        //check position against josuters
        if(ccpDistance(redJouster.position, powerStone.position) < 100){
            validSpawnPosition = NO;
        }else if(ccpDistance(blueJouster.position, powerStone.position) < 100){
            validSpawnPosition = NO;
        }
        
    }
    [self addChild:self.powerStone];
    [self refreshUI];
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
    
    roundTimer = ROUND_TIME;
    displayedTime = ROUND_TIME;
    centerSprite.visible = NO;
    timerLabel.string = [NSString stringWithFormat:@"%d", displayedTime];
}

-(void) refreshUI{
    [redWinsLabel setString:[NSString stringWithFormat:@"%d", redWins]];
    [blueWinsLabel setString:[NSString stringWithFormat:@"%d", blueWins]];
    [redPowerStonesLabel setString:[NSString stringWithFormat:@"%d", redJouster.powerStones]];
    [bluePowerStonesLabel setString:[NSString stringWithFormat:@"%d", blueJouster.powerStones]];
}

-(void) dealloc{
    [redJouster release];
    [blueJouster release];
    [super dealloc];
}

-(void) update:(ccTime)dt{
    if(currentState == GAMEPLAY){
        [redJouster update:dt];
        [blueJouster update:dt];
        //check collision for powerStone
        [self powerStoneCollisionCheck];
        BOOL bodyHit = [self bodyOnBodyCheck];
        BOOL joustersHit = [self jousterOnJousterCheck];
        //prevents odd losses
        if(!joustersHit && !bodyHit){
            [self jousterOnBodyCheck];
        }
        
        [self updateTimer:dt];
    }
}

-(void) updateTimer:(ccTime) dt{
    roundTimer -= dt;
    if((int)roundTimer < displayedTime){
        displayedTime = (int)roundTimer;
        timerLabel.string = [NSString stringWithFormat:@"%d", displayedTime];
        
        if(displayedTime < 6){
            centerSprite.visible = YES;
        }
        
        //endGame based on distance to center
        if(displayedTime < 1){
            //check distance to center point, closest player wins
            [self checkClosestJousterToCenter];
            
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


#pragma mark - collision functions
-(void) powerStoneCollisionCheck{
    //blue joust hitting red dude
    if([MathHelper circleCollisionPositionA:powerStone.position  raidusA:powerStone.bodyRadius positionB:redJouster.position radiusB:redJouster.bodyRadius] ){
        redJouster.powerStones++;
        [self spawnPowerStone];
        [self refreshUI];
    }
    if([MathHelper circleCollisionPositionA:powerStone.position  raidusA:powerStone.bodyRadius positionB:blueJouster.position radiusB:blueJouster.bodyRadius]){
        blueJouster.powerStones++;
        [self spawnPowerStone];
        [self refreshUI];
    }
}

-(BOOL) bodyOnBodyCheck{
    //bodies hit
    if( [MathHelper circleCollisionPositionA:redJouster.position raidusA:redJouster.bodyRadius positionB:blueJouster.position radiusB:blueJouster.bodyRadius]){
        //bounce off eachother
        CGPoint offset = ccpSub(redJouster.position, blueJouster.position);
        offset = [MathHelper normalize:offset];
        offset = ccpMult(offset, 410);
        redJouster.velocity = offset;
        offset = ccpMult(offset, -1);
        blueJouster.velocity = offset;

        [self clashEffect:redJouster.position otherPoint:blueJouster.position];
        return YES;
        
    }
    return NO;
}

-(void) jousterOnBodyCheck{
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
        [self refreshUI];
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
        [self refreshUI];
    }
}

-(BOOL) jousterOnJousterCheck{
    
    //jousters hitting
    if( [MathHelper circleCollisionPositionA:[redJouster getWorldPositionOfJoust]  raidusA:[redJouster joustRadius] positionB:[blueJouster getWorldPositionOfJoust] radiusB: [blueJouster joustRadius]]){
        //bounce off eachother
        //TODO: make class specific collision code
        
        [redJouster joustCollision: [blueJouster getWorldPositionOfJoust] withRadius: blueJouster.joustRadius];
        [blueJouster joustCollision: [redJouster getWorldPositionOfJoust] withRadius: redJouster.joustRadius];
        [self clashEffect:[redJouster getWorldPositionOfJoust] otherPoint:[blueJouster getWorldPositionOfJoust]];
        return YES;
    }
    return NO;
}

#pragma mark - touch code
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    if(currentState != GAMEPLAY){
        return NO;
    }
    return YES;
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
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
    
    CCDelayTime *delay = [CCDelayTime actionWithDuration:1];
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
    currentState = ROUND_START;
    //show names of fighters
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    CCLabelTTF *gameStartLabel = [[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"Round %d", currentRound] fontName:@"Marker Felt" fontSize:32] autorelease];
    gameStartLabel.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:gameStartLabel];
    
    CCDelayTime *delay = [CCDelayTime actionWithDuration:1];
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
    
    CCDelayTime *delay = [CCDelayTime actionWithDuration:1];
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
    
    CCDelayTime *delay = [CCDelayTime actionWithDuration:2];
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

-(void) clashEffect:(CGPoint) p1 otherPoint:(CGPoint) p2{
    //collision effect
    CCParticleSystemQuad *collisionEffect = [[CCParticleSystemQuad alloc] initWithFile: @"CollisionEffect.plist"];
    collisionEffect.autoRemoveOnFinish = YES;
    CGPoint midPoint = ccpMidpoint(p1, p2);
    float rotation = [MathHelper degreeAngleBetween:p1 and:p2];
    
    collisionEffect.rotation = -rotation - 90;
    collisionEffect.position = midPoint;
    [self addChild:collisionEffect];
    
    collisionEffect = [[CCParticleSystemQuad alloc] initWithFile: @"CollisionEffect.plist"];
    collisionEffect.autoRemoveOnFinish = YES;
    midPoint = ccpMidpoint(p1, p2);
    rotation = [MathHelper degreeAngleBetween:p1 and:p2];
    
    collisionEffect.rotation = -rotation + 90;
    collisionEffect.position = midPoint;
    [self addChild:collisionEffect];
    
    
}

@end
