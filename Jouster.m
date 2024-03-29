//
//  Jouster.m
//  FingerJoust
//
//  Created by Hunter Francis on 7/11/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import "Jouster.h"
#import "GameLayer.h"
#import "CCWarpSprite.h"
#import "GameLayer.h"
#import "Player.h"
#import "PlayerManager.h"

@implementation Jouster

@synthesize velocity, waitingForTouch, bodyRadius, joustRadius, orbitalOffset,joustPosition, player, powerStones, jousterSprite, joustVelocity, motionStreak, isDead, wins, jousterMotionStreak, gameLayer, outsideVelocity, joustOutsideVelocity, isDisplay, bodyInnerSprite, isJousterInactive, jousterInactiveTimer;

-(id) initWithPlayer:(Player *) p{
    if(self = [super init]){
        self.player = p;
        self.velocity = CGPointZero;
        waitingForTouch = YES;
        joustPosition = ccp(1,0);
        [self resetJouster];
        bodyRadius = 30;
        joustRadius = 20;
        isJousterInactive = NO;
        jousterInactiveTimer = 0.0;
        bodyOuterSprite = [CCWarpSprite spriteWithSpriteFrameName:@"BodyOuter"];
        bodyOuterSprite.isWarping = NO;
        self.bodyInnerSprite = [CCWarpSprite spriteWithSpriteFrameName:@"BodyInner"];
        bodyInnerSprite.isWarping = NO;
        bodyInnerSprite.position = ccp(bodyOuterSprite.contentSize.width/2, bodyOuterSprite.contentSize.height/2);
        [self addChild:bodyOuterSprite];
        [bodyOuterSprite addChild:bodyInnerSprite];

        
        self.jousterSprite = [CCWarpSprite spriteWithSpriteFrameName:@"JousterOuter"];
        [self addChild:jousterSprite];
        jousterSprite.isWarping = NO;
        jousterInnerSprite = [CCWarpSprite spriteWithSpriteFrameName:@"JousterInner"];
        jousterInnerSprite.isWarping = NO;
        jousterInnerSprite.position = ccp(jousterSprite.contentSize.width/2, jousterSprite.contentSize.height/2);
        [jousterSprite addChild:jousterInnerSprite];
        
        
        
        stunParticles = [[CCParticleSystemQuad alloc] initWithFile: @"StunParticles.plist"];
        stunParticles.positionType = kCCPositionTypeRelative;
        [stunParticles stopSystem];
        [self addChild:stunParticles z:-1];
        
    
        maxSpeed = JOUSTER_BODY_MAXSPEED;
        
        
        /*
        const GLchar * fragmentSource = (GLchar*) [[NSString stringWithContentsOfFile:[[CCFileUtils sharedFileUtils] fullPathForFilename:@"Grain.fsh"] encoding:NSUTF8StringEncoding error:nil] UTF8String];
        const GLchar * vertexSource = (GLchar*) [[NSString stringWithContentsOfFile:[[CCFileUtils sharedFileUtils] fullPathForFilename:@"Grain.vsh"] encoding:NSUTF8StringEncoding error:nil] UTF8String];
        bodyOuterSprite.shaderProgram = [[CCGLProgram alloc] initWithVertexShaderByteArray:ccPositionTextureColor_vert
                                                          fragmentShaderByteArray:fragmentSource];
        
        [bodyOuterSprite.shaderProgram addAttribute:kCCAttributeNamePosition
                                         index:kCCVertexAttrib_Position];
        [bodyOuterSprite.shaderProgram addAttribute:kCCAttributeNameColor
                                            index:kCCVertexAttrib_Color];
        
        [bodyOuterSprite.shaderProgram addAttribute:kCCAttributeNameTexCoord
                                         index:kCCVertexAttrib_TexCoords];
        [bodyOuterSprite.shaderProgram link];
        [bodyOuterSprite.shaderProgram updateUniforms];
        */

        
        
        
    }
    return self;
}

-(void) makeTail{
    if(self.motionStreak){
        [self.motionStreak removeFromParentAndCleanup:YES];
        [self.motionStreak release];
        self.motionStreak = nil;
    }
    
    if(self.jousterMotionStreak){
        [self.jousterMotionStreak removeFromParentAndCleanup:YES];
        [self.jousterMotionStreak release];
        self.jousterMotionStreak = nil;
    }
    
    self.jousterMotionStreak = [[CCParticleSystemQuad alloc] initWithFile: @"MotionStreak.plist"];
    self.jousterMotionStreak.startSize = 70;
    self.motionStreak = [[CCParticleSystemQuad alloc] initWithFile: @"MotionStreak.plist"];
    int choice = player.playerNumber;
    if([[PlayerManager sharedInstance] isTeamPlay]){
        choice = player.team;
    }
    
    if(choice == 0){
        [motionStreak setStartColor:COLOR_PLAYER_ONE_LIGHT_F4];
        [motionStreak setEndColor:COLOR_PLAYER_ONE_LIGHT_F4];
        [jousterMotionStreak setStartColor:COLOR_PLAYER_ONE_LIGHT_F4];
        [jousterMotionStreak setEndColor:COLOR_PLAYER_ONE_LIGHT_F4];
    }else if(choice == 1){
        [motionStreak setStartColor:COLOR_PLAYER_TWO_LIGHT_F4];
        [motionStreak setEndColor:COLOR_PLAYER_TWO_LIGHT_F4];
        [jousterMotionStreak setStartColor:COLOR_PLAYER_TWO_LIGHT_F4];
        [jousterMotionStreak setEndColor:COLOR_PLAYER_TWO_LIGHT_F4];
    } else if(choice == 2){
        [motionStreak setStartColor:COLOR_PLAYER_THREE_LIGHT_F4];
        [motionStreak setEndColor:COLOR_PLAYER_THREE_LIGHT_F4];
        [jousterMotionStreak setStartColor:COLOR_PLAYER_THREE_LIGHT_F4];
        [jousterMotionStreak setEndColor:COLOR_PLAYER_THREE_LIGHT_F4];
    } else if(choice == 3){
        [motionStreak setStartColor:COLOR_PLAYER_FOUR_LIGHT_F4];
        [motionStreak setEndColor:COLOR_PLAYER_FOUR_LIGHT_F4];
        [jousterMotionStreak setStartColor:COLOR_PLAYER_FOUR_LIGHT_F4];
        [jousterMotionStreak setEndColor:COLOR_PLAYER_FOUR_LIGHT_F4];
    }

    
    motionStreak.positionType = kCCPositionTypeFree;
    [gameLayer addChild:motionStreak z:1];
    [gameLayer addChild:jousterMotionStreak z:1];
    motionStreak.visible = NO;
    jousterMotionStreak.visible = NO;
}

-(void) dealloc{
    [motionStreak release];
    [jousterMotionStreak release];
    [super dealloc];
}

-(void) resetJouster{
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    [self disengateSuperMode];
    self.visible = YES;
    isDead = NO;
    powerStones = 0;
    orbitalOffset = 0;
    CGPoint pos;
    jousterInactiveTimer = 0.0;
    isJousterInactive = NO;
    [stunParticles resetSystem];
    [stunParticles updateWithNoTime];
    [stunParticles stopSystem];
    if(player.playerNumber == 0){
        pos = ccp(290, winSize.height/2 + 200);
        bodyOuterSprite.color = ccWHITE;
        bodyInnerSprite.color = COLOR_PLAYER_ONE;
        jousterSprite.color = ccWHITE;
        jousterInnerSprite.color = COLOR_PLAYER_ONE;

    }else if(player.playerNumber == 1){
        pos = ccp(winSize.width - 290, winSize.height/2 + 200);
        bodyOuterSprite.color = ccWHITE;
        bodyInnerSprite.color = COLOR_PLAYER_TWO;
        jousterSprite.color = ccWHITE;
        jousterInnerSprite.color = COLOR_PLAYER_TWO;

    }else if(player.playerNumber == 2){
        pos = ccp(winSize.width - 290, winSize.height/2 - 200);
        bodyOuterSprite.color = ccWHITE;
        bodyInnerSprite.color = COLOR_PLAYER_THREE;
        jousterSprite.color = ccWHITE;
        jousterInnerSprite.color = COLOR_PLAYER_THREE;
        
    }else if(player.playerNumber == 3){
        pos = ccp(290, winSize.height/2 - 200);
        bodyOuterSprite.color = ccWHITE;
        bodyInnerSprite.color = COLOR_PLAYER_FOUR;
        jousterSprite.color = ccWHITE;
        jousterInnerSprite.color = COLOR_PLAYER_FOUR;
        
    }
    [self makeTail];
    
    velocity = ccp(1,0);
    previousVelocity = ccp(1,0);
    outsideVelocity = ccp(1,0);
    joustOutsideVelocity = ccp(1,0);
    self.position = pos;
    [self update:0.05];
    [self resetTouch];
    isStunned = NO;
    stunTimer = -1;
}

-(void) engageSuperMode{
    superModeTimer = 0;
    powerStones = 0;
    isSuperMode = YES;
}

-(void) disengateSuperMode{
    superModeTimer = 0;
    powerStones = 0;
    isSuperMode = NO;
}

-(void) stunBody{
    isStunned = YES;
    stunTimer = STUN_TIME;
    bodyOuterSprite.color = ccBLACK;
    
}

-(void) clampMaxSpeed{
    float speed = ccpLength(self.velocity);
    if(speed > maxSpeed){
        CGPoint normal = ccpNormalize(self.velocity);
        self.velocity = ccpMult(normal, maxSpeed);
    }
}

-(void) update:(ccTime)dt{
    if(powerStones > 4){
        [self engageSuperMode];
    }
    jousterInactiveTimer -= dt;
    if(jousterInactiveTimer < 0){
        isJousterInactive = NO;
    }
    
    self.velocity = ccpAdd(self.velocity, ccpMult(touchPoint,dt));
    touchPoint = CGPointZero;
    if(self.parent && self.visible){
        jousterMotionStreak.visible = YES;
        motionStreak.visible = YES;
    }else{
        jousterMotionStreak.visible = NO;
        motionStreak.visible = NO;
    }
    jousterMotionStreak.position = ccpAdd(joustPosition,self.position);
    motionStreak.position = self.position;
    //velocity and position
    //reduce velocity
    [self clampMaxSpeed];
    velocity = ccpMult(velocity, .96);
    outsideVelocity = ccpMult(outsideVelocity, .92);
    joustOutsideVelocity = ccpMult(joustOutsideVelocity, .92);
    
    //update velocity
//    self.position = ccpAdd(self.position, ccpMult(self.velocity, dt));

    previousVelocity = velocity;

    bodyOuterSprite.velocity = velocity;
    bodyInnerSprite.velocity = velocity;
    [bodyOuterSprite update:dt];
    [bodyInnerSprite update:dt];
    
    
    //[jousterSprite.shaderProgram updateUniforms];
    //run super mode stuff
    if(isSuperMode){
        superModeTimer += dt;
        if(superModeTimer > 6){
            [self disengateSuperMode];
        }
    }
    
    //stun stuff
    if(isStunned){
        stunTimer -= dt;
        if(stunTimer < 0){
            isStunned = NO;
            bodyOuterSprite.color = ccWHITE;
            [stunParticles stopSystem];
        }
    }
}

-(void) setWorldPositionOfJoust:(CGPoint) pos{
    CGPoint newPos = ccp(pos.x - self.position.x, pos.y - self.position.y);
    self.joustPosition = newPos;
}

-(CGPoint) getWorldPositionOfJoust{
    return ccpAdd(self.position, self.joustPosition);
}

-(void) calculateJoustPosition{
    CGPoint oldNorm = ccpNormalize(joustPosition);
    CGPoint norm = ccpNormalize(velocity);
    CGPoint joining = ccpAdd( ccpMult(oldNorm, 20), ccpMult(norm, 2));
    CGPoint spot = ccpNormalize(joining);
    joustPosition = ccpMult(spot, joustRadius * 2);
}

-(void) calculateJoustPositionB:(CGPoint) touch{
    CGPoint difference = ccpSub(touch, previousTouch);
    CGPoint oldNorm = ccpNormalize(joustPosition);
    CGPoint norm = ccpNormalize(difference);
    CGPoint joining = ccpAdd( ccpMult(oldNorm, 4), ccpMult(norm, 2));
    CGPoint spot = ccpNormalize(joining);
    joustPosition = ccpMult(spot, joustRadius * 2);
}

-(void) joustCollision:(CGPoint) joustPos withRadius:(float) radius{
    
    
}

- (void) draw{
    
//    glVertexAttribPointer(
    //white circle
   /* ccDrawColor4F(1, 1, 1, 1);
    ccDrawSolidCircle( CGPointZero, bodyRadius, 30);
    
    if(player == 1){
        ccDrawColor4F(1.0f, 0.3f, 0.3f, 1.0f);
    }else{
        ccDrawColor4F(0.3f, 0.3f, 1.0f, 1.0f);
    }
    ccDrawSolidCircle( CGPointZero, bodyRadius - 10, 30);
  */
    //jouster drawing debug stuff
    /*
    if(player == 1){
        ccDrawColor4F(.5f, 0.0f, 0.0f, 1.0f);
    }else{
        ccDrawColor4F(0.0f, 0.0f, 0.5f, 1.0f);
    }
    //joust
    ccDrawSolidCircle(joustPosition, joustRadius, 30);
    */
  
    [super draw];
}

-(void) resetTouch{
    previousTouch = CGPointZero;
    waitingForTouch = YES;
}

-(void) touch:(CGPoint) touch{
    if(waitingForTouch){
        previousTouch = touch;
        waitingForTouch = NO;
        return;
    }

    CGPoint difference = ccpSub(touch, previousTouch);

    if(isSuperMode){
        difference = ccp(difference.x * 5.5, difference.y *4.1);
    }else if(isStunned){
        difference = ccp(difference.x * 150.3, difference.y *130.0);
    }else{
        
//        difference = ccp(difference.x * 2.7, difference.y *2.2);
        difference = ccp(difference.x * 930, difference.y *930);
//        difference = ccp(difference.x * 2.0, difference.y *1.6);
//        difference = ccp(difference.x * 6, difference.y *6);

    }
//    self.velocity = ccpAdd(velocity, difference);
    touchPoint = difference;
    previousTouch = touch;
}

-(BOOL) doesTouchDeltaMakeSense:(CGPoint) touch{
    if(ccpLength(previousTouch) == 0){
        return YES;
    }
    CGPoint difference = ccpSub(touch, previousTouch);
    float mag = ccpLength(difference);
    if(mag < 50 ){
        return YES;
    }
    return NO;
}


-(void) checkJoustBoundaries{
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    CGPoint pos = [self getWorldPositionOfJoust];
    float radius = joustRadius;
    //check north side
    if((pos.y + radius) > winSize.height - MIDDLEBAR_HEIGHT){
        [self setWorldPositionOfJoust:ccp(pos.x, winSize.height - joustRadius - MIDDLEBAR_HEIGHT)];
        joustVelocity = ccp(joustVelocity.x, joustVelocity.y * -1);
        joustOutsideVelocity = ccp(joustOutsideVelocity.x, joustOutsideVelocity.y * -1);
        [gameLayer clashWeakEffect:ccp(pos.x, winSize.height - MIDDLEBAR_HEIGHT - 1) otherPoint:ccp(pos.x, winSize.height - MIDDLEBAR_HEIGHT) withMagnitude:250 withStun:NO];
    }
    
    //check south side
    if( (pos.y - joustRadius) < MIDDLEBAR_HEIGHT ){
        [self setWorldPositionOfJoust:ccp(pos.x, MIDDLEBAR_HEIGHT + joustRadius)];
        joustVelocity = ccp(joustVelocity.x, joustVelocity.y * -1);
        joustOutsideVelocity = ccp(joustOutsideVelocity.x, joustOutsideVelocity.y * -1);
        [gameLayer clashWeakEffect:ccp(pos.x, MIDDLEBAR_HEIGHT - 1) otherPoint:ccp(pos.x, MIDDLEBAR_HEIGHT) withMagnitude:250 withStun:NO];
    }
    
    //left side
    if((pos.x - joustRadius) < CONTROL_OFFSET + 10){
        [self setWorldPositionOfJoust:ccp(CONTROL_OFFSET + joustRadius + 10, pos.y)];
        joustVelocity = ccp(joustVelocity.x *  -1, joustVelocity.y);
        joustOutsideVelocity = ccp(joustOutsideVelocity.x * -1, joustOutsideVelocity.y);
        [gameLayer clashWeakEffect:ccp(CONTROL_OFFSET, pos.y) otherPoint:ccp(CONTROL_OFFSET - 1, pos.y) withMagnitude:250 withStun:NO];
    }
    
    //right side
    if((pos.x + joustRadius) >  (winSize.width - CONTROL_OFFSET) - 10){
        [self setWorldPositionOfJoust:ccp(winSize.width - CONTROL_OFFSET - joustRadius - 10, pos.y)];
        joustVelocity = ccp(joustVelocity.x * -1, joustVelocity.y);
        joustOutsideVelocity = ccp(joustOutsideVelocity.x * -1, joustOutsideVelocity.y);
        [gameLayer clashWeakEffect:ccp(winSize.width - CONTROL_OFFSET, pos.y) otherPoint:ccp(winSize.width - CONTROL_OFFSET - 1, pos.y) withMagnitude:250 withStun:NO];
    }
    
}

-(void) checkBoundaries{
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    
    CGPoint pos = self.position;
    float radius = self.bodyRadius;

    //check north side
    if((pos.y + radius) > winSize.height - MIDDLEBAR_HEIGHT){
        self.position = ccp(self.position.x, winSize.height - radius - MIDDLEBAR_HEIGHT);
        self.velocity = ccp(self.velocity.x, self.velocity.y * -1);
        outsideVelocity = ccp(self.outsideVelocity.x, self.outsideVelocity.y - 250);
        [gameLayer clashWeakEffect:ccp(pos.x, winSize.height - MIDDLEBAR_HEIGHT - 1) otherPoint:ccp(pos.x, winSize.height - MIDDLEBAR_HEIGHT) withMagnitude:250 withStun:NO];
    }
    
    //check south side
    if( (pos.y - radius) < MIDDLEBAR_HEIGHT ){
        self.position = ccp(self.position.x, MIDDLEBAR_HEIGHT + radius);
        self.velocity = ccp(self.velocity.x, self.velocity.y * -1);
        outsideVelocity = ccp(self.outsideVelocity.x, self.outsideVelocity.y + 250);
        [gameLayer clashWeakEffect:ccp(pos.x, MIDDLEBAR_HEIGHT - 1) otherPoint:ccp(pos.x, MIDDLEBAR_HEIGHT) withMagnitude:250 withStun:NO];
    }
    
    //left side
    if((pos.x - radius) < CONTROL_OFFSET + 10){
        self.position = ccp(CONTROL_OFFSET + 10 + radius, self.position.y);
        self.velocity = ccp(self.velocity.x * -1, self.velocity.y);
        outsideVelocity = ccp(self.outsideVelocity.x + 250, self.outsideVelocity.y);
        [gameLayer clashWeakEffect:ccp(CONTROL_OFFSET + 12, pos.y) otherPoint:ccp(CONTROL_OFFSET + 10 - 1, pos.y) withMagnitude:250 withStun:NO];
    }
    
    
    //right side
    if((pos.x + radius) >  (winSize.width - CONTROL_OFFSET - 10)){
        self.position = ccp(winSize.width - CONTROL_OFFSET- 10 - radius, self.position.y);
        self.velocity = ccp(self.velocity.x * -1, self.velocity.y);
        outsideVelocity = ccp(self.outsideVelocity.x - 250, self.outsideVelocity.y);
        [gameLayer clashWeakEffect:ccp(winSize.width - CONTROL_OFFSET- 12, pos.y) otherPoint:ccp(winSize.width - CONTROL_OFFSET- 10 - 1, pos.y) withMagnitude:250 withStun:NO];
    }
}


@end
