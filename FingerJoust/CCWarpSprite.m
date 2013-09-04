//
//  CCWarpSprite.m
//  ZooChase
//
//  Created by Hunter Francis on 6/13/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "CCWarpSprite.h"


@implementation CCWarpSprite


@synthesize isWarping, springConst, lifeTime, velocity;


+(id)spriteWithSpriteFrameName:(NSString*)spriteFrameName{
    CCWarpSprite *test = [super spriteWithSpriteFrameName:spriteFrameName];
    [test setupWarpVars];
    return test;
    
}

-(id)initWithSpriteFrameName:(NSString*)spriteFrameName{
    if(self = [super initWithSpriteFrameName:spriteFrameName]){
        [self setupWarpVars];
    }
    return self;
}


- (void) setupWarpVars{
    lifeTime = (arc4random()%100) / 100;
    springConst = 1;
}



-(void) update:(ccTime)dt{
    [super update:dt];
    if(isWarping){
        lifeTime += dt;
        //TODO: possible ways to optimize code
/*        warpOffset = ccp(springConst * (powf(sinf(lifeTime * warpTimeScaleX) * warpPositionX, 2) - (warpPositionX*warpPositionX/2) ), springConst * (powf(sinf(lifeTime + M_PI_2 * warpTimeScaleY) * warpPositionY, 2 ) - (warpPositionY*warpPositionY/2) ) );
 
 */
        CGPoint norm_V = ccpNormalize(self.velocity);
        CGPoint trPoint = ccp(1,1);
        CGPoint tlPoint = ccp(-1,1);
        CGPoint brPoint = ccp(1,-1);
        CGPoint blPoint = ccp(-1,-1);
        
        float tr_dis = ccpDistance(norm_V, trPoint);
        float tl_dis = ccpDistance(norm_V, tlPoint);
        float br_dis = ccpDistance(norm_V, brPoint);
        float bl_dis = ccpDistance(norm_V, blPoint);
        
        //inverse the distance
        float tr_scale = 1.4142135623730951 * 2 - tr_dis;
        float tl_scale = 1.4142135623730951 * 2 - tl_dis;
        float br_scale = 1.4142135623730951 * 2 - br_dis;
        float bl_scale = 1.4142135623730951 * 2 - bl_dis;
        
        
        
        
        CGPoint nonZeroVelocity = self.velocity;
        if(ccpLength(self.velocity) < 0.001 ){
            nonZeroVelocity = ccp(.1, .1);
        }
        
        CGPoint temp_V = ccpMult(nonZeroVelocity, .02);
        tr_Offset = ccpMult(temp_V, tr_scale);
        tl_Offset = ccpMult(temp_V, tl_scale);
        br_Offset = ccpMult(temp_V, br_scale);
        bl_Offset = ccpMult(temp_V, bl_scale);
        
        
        
    }
}

-(void) draw
{
	CC_PROFILER_START_CATEGORY(kCCProfilerCategorySprite, @"CCSprite - draw");
    
	NSAssert(!_batchNode, @"If CCSprite is being rendered by CCSpriteBatchNode, CCSprite#draw SHOULD NOT be called");
    
	CC_NODE_DRAW_SETUP();
    
	ccGLBlendFunc( _blendFunc.src, _blendFunc.dst );
    
	ccGLBindTexture2D( [_texture name] );
    
	//
	// Attributes
	//
    
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_PosColorTex );
/*    //! top left
	ccV3F_C4B_T2F	tl;
	//! bottom left
	ccV3F_C4B_T2F	bl;
	//! top right
	ccV3F_C4B_T2F	tr;
	//! bottom right
	ccV3F_C4B_T2F	br;
} ccV3F_C4B_T2F_Quad;*/
    ccV3F_C4B_T2F_Quad temp;
    temp = _quad;
    
    if(isWarping){
        temp.tl.vertices.x = temp.tl.vertices.x + tl_Offset.x;
        temp.tl.vertices.y = temp.tl.vertices.y + tl_Offset.y;
        temp.tr.vertices.x = temp.tr.vertices.x + tr_Offset.x;
        temp.tr.vertices.y = temp.tr.vertices.y + tr_Offset.y;
        temp.bl.vertices.x = temp.bl.vertices.x + bl_Offset.x;
        temp.bl.vertices.y = temp.bl.vertices.y + bl_Offset.y;
        temp.br.vertices.x = temp.br.vertices.x + br_Offset.x;
        temp.br.vertices.y = temp.br.vertices.y + br_Offset.y;
    }
    
    #define kQuadSize sizeof(temp.bl)
	long offset = (long)&temp;
    
	// vertex
	NSInteger diff = offsetof( ccV3F_C4B_T2F, vertices);
	glVertexAttribPointer(kCCVertexAttrib_Position, 3, GL_FLOAT, GL_FALSE, kQuadSize, (void*) (offset + diff));
    
	// texCoods
	diff = offsetof( ccV3F_C4B_T2F, texCoords);
	glVertexAttribPointer(kCCVertexAttrib_TexCoords, 2, GL_FLOAT, GL_FALSE, kQuadSize, (void*)(offset + diff));
    
	// color
	diff = offsetof( ccV3F_C4B_T2F, colors);
	glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_UNSIGNED_BYTE, GL_TRUE, kQuadSize, (void*)(offset + diff));
    
    
    
 //   	quad->br.vertices.x = quad->br.vertices.y = quad->tr.vertices.x = quad->tr.vertices.y = quad->tl.vertices.x = quad->tl.vertices.y = quad->bl.vertices.x = quad->bl.vertices.y = 0.0f;
    
/*    typedef struct _ccVertex3F
    {
        GLfloat x;
        GLfloat y;
        GLfloat z;
    } ccVertex3F;
    
    ccV3F_C4B_T2F_Quad test = ccV3F_C4B_T2F_Quad*/
    
    /*#define kQuadSize sizeof(_quad.bl)
	long offset = (long)&_quad;
    
	// vertex
	NSInteger diff = offsetof( ccV3F_C4B_T2F, vertices);
	glVertexAttribPointer(kCCVertexAttrib_Position, 3, GL_FLOAT, GL_FALSE, kQuadSize, (void*) (offset + diff));
    
	// texCoods
	diff = offsetof( ccV3F_C4B_T2F, texCoords);
	glVertexAttribPointer(kCCVertexAttrib_TexCoords, 2, GL_FLOAT, GL_FALSE, kQuadSize, (void*)(offset + diff));
    
	// color
	diff = offsetof( ccV3F_C4B_T2F, colors);
	glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_UNSIGNED_BYTE, GL_TRUE, kQuadSize, (void*)(offset + diff));
    
    */
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
 
	CHECK_GL_ERROR_DEBUG();
    
    
#if CC_SPRITE_DEBUG_DRAW == 1
	// draw bounding box
	CGPoint vertices[4]={
		ccp(_quad.tl.vertices.x,_quad.tl.vertices.y),
		ccp(_quad.bl.vertices.x,_quad.bl.vertices.y),
		ccp(_quad.br.vertices.x,_quad.br.vertices.y),
		ccp(_quad.tr.vertices.x,_quad.tr.vertices.y),
	};
	ccDrawPoly(vertices, 4, YES);
#elif CC_SPRITE_DEBUG_DRAW == 2
	// draw texture box
	CGSize s = self.textureRect.size;
	CGPoint offsetPix = self.offsetPosition;
	CGPoint vertices[4] = {
		ccp(offsetPix.x,offsetPix.y), ccp(offsetPix.x+s.width,offsetPix.y),
		ccp(offsetPix.x+s.width,offsetPix.y+s.height), ccp(offsetPix.x,offsetPix.y+s.height)
	};
	ccDrawPoly(vertices, 4, YES);
#endif // CC_SPRITE_DEBUG_DRAW
    
	CC_INCREMENT_GL_DRAWS(1);
    
	CC_PROFILER_STOP_CATEGORY(kCCProfilerCategorySprite, @"CCSprite - draw");
}





@end
