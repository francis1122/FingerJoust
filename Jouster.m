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


@implementation Jouster

@synthesize velocity, waitingForTouch, bodyRadius, joustRadius, orbitalOffset,joustPosition, player, powerStones, jousterSprite, joustVelocity;

-(id) init{
    if(self = [super init]){
        self.velocity = CGPointZero;
        waitingForTouch = YES;
        player = 1;
        joustPosition = ccp(1,0);
        [self resetJouster];
        
        bodyOuterSprite = [CCWarpSprite spriteWithSpriteFrameName:@"BodyOuter"];
        bodyOuterSprite.isWarping = NO;
        bodyInnerSprite = [CCWarpSprite spriteWithSpriteFrameName:@"BodyInner"];
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

-(void) resetJouster{
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    [self disengateSuperMode];
    self.visible = YES;
    powerStones = 0;
    bodyRadius = 35;
    joustRadius = 25;
    orbitalOffset = 0;
    CGPoint pos;
    if(player == 1){
        pos = ccp(350, winSize.height/2);
        bodyOuterSprite.color = ccORANGE;
        jousterSprite.color = ccORANGE;
        jousterInnerSprite.color = ccORANGE;
        bodyInnerSprite.color = ccORANGE;
    }else{
        pos = ccp(winSize.width - 350, winSize.height/2);
        bodyOuterSprite.color = ccRED;
        jousterSprite.color = ccRED;
        jousterInnerSprite.color = ccRED;
        bodyInnerSprite.color = ccRED;
    }
    
    
    velocity = ccp(1,0);
    previousVelocity = ccp(1,0);
    self.position = pos;
    [self update:0.05];
    [self resetTouch];
    isStunned = NO;    
}

-(void) engageSuperMode{
    superModeTimer = 0;
    powerStones = 0;
    isSuperMode = YES;
}

-(void) disengateSuperMode{
    superModeTimer = 0;
    powerStones = 0;
  //  joustRadius = 20;
    isSuperMode = NO;
}

-(void) stunBody{
    isStunned = YES;
    stunTimer = 5.0;
    bodyOuterSprite.color = ccBLACK;
}

-(void) clampMaxSpeed{
    float speed = ccpLength(self.velocity);
    if(speed > JOUSTER_BODY_MAXSPEED){
        CGPoint normal = ccpNormalize(self.velocity);
        self.velocity = ccpMult(normal, JOUSTER_BODY_MAXSPEED);
    }
}

-(void) update:(ccTime)dt{

    
    //jousterSprite.position = joustPosition;
//    jousterSprite.rotation = jousterSprite.rotation + 2.5;
    if(powerStones > 4){
        [self engageSuperMode];
    }
    
    //velocity and position
    //reduce velocity
    [self clampMaxSpeed];
    velocity = ccpMult(velocity, .96);
    
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

    //NSLog(@"diffference : %f, %f", difference.x, difference.y);
    

    if(isSuperMode){
        difference = ccp(difference.x * 5.5, difference.y *4.1);
    }else if(isStunned){
        difference = ccp(difference.x * 1.5, difference.y *1.2);
    }else{
        
        difference = ccp(difference.x * 2.7, difference.y *2.2);
//        difference = ccp(difference.x * 6, difference.y *6);

    }
    self.velocity = ccpAdd(velocity, difference);

    
    //tweaked movement
    
    //normalize direction
/*    CGPoint normalizedDifference = ccpNormalize(difference);
    
    //get magnitude of swipe
    float speed = ccpLength(difference);
    speed = log2f(1 +speed*speed);
    CGPoint newVelocity = ccp(normalizedDifference.x * speed, normalizedDifference.y *speed);
    self.velocity = ccpAdd(velocity, newVelocity);
    */
    
    previousTouch = touch;
    
}


-(void) checkJoustBoundaries{
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    CGPoint pos = [self getWorldPositionOfJoust];
    float radius = joustRadius;
    //check north side
    if((pos.y + radius) > winSize.height - MIDDLEBAR_HEIGHT){
        [self setWorldPositionOfJoust:ccp(pos.x, winSize.height - joustRadius - MIDDLEBAR_HEIGHT)];
        joustVelocity = ccp(joustVelocity.x, joustVelocity.y * -1);
    }
    
    //check south side
    if( (pos.y - joustRadius) < MIDDLEBAR_HEIGHT ){
        [self setWorldPositionOfJoust:ccp(pos.x, MIDDLEBAR_HEIGHT + joustRadius)];
        joustVelocity = ccp(joustVelocity.x, joustVelocity.y * -1);
    }
    
    //left side
    if((pos.x - joustRadius) < CONTROL_OFFSET){
        [self setWorldPositionOfJoust:ccp(CONTROL_OFFSET + joustRadius, pos.y)];
        joustVelocity = ccp(joustVelocity.x *  -1, joustVelocity.y);
    }
    
    //right side
    if((pos.x + joustRadius) >  (winSize.width - CONTROL_OFFSET)){
        [self setWorldPositionOfJoust:ccp(winSize.width - CONTROL_OFFSET - joustRadius, pos.y)];
        joustVelocity = ccp(joustVelocity.x * -1, joustVelocity.y);
    }
    
}

-(void) checkBoundaries{
    CGSize winSize= [[CCDirector sharedDirector] winSize];
    
    CGPoint pos = self.position;
    float radius = self.bodyRadius;
    
    //check north side
    if((pos.y + radius) > winSize.height - MIDDLEBAR_HEIGHT){
        self.position = ccp(self.position.x, winSize.height - radius - MIDDLEBAR_HEIGHT);
        self.velocity = ccp(self.velocity.x, self.velocity.y * -.8);
    }
    
    //check south side
    if( (pos.y - radius) < MIDDLEBAR_HEIGHT ){
        self.position = ccp(self.position.x, MIDDLEBAR_HEIGHT + radius);
        self.velocity = ccp(self.velocity.x, self.velocity.y * -.8);
    }
    
    //left side
    if((pos.x - radius) < CONTROL_OFFSET){
        self.position = ccp(CONTROL_OFFSET + radius, self.position.y);
        self.velocity = ccp(self.velocity.x *  -.8, self.velocity.y);
    }
    
    //right side
    if((pos.x + radius) >  (winSize.width - CONTROL_OFFSET)){
        self.position = ccp(winSize.width - CONTROL_OFFSET - radius, self.position.y);
        self.velocity = ccp(self.velocity.x * -.8, self.velocity.y);
    }
}


@end
