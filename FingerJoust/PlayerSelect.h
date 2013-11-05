//
//  PlayerSelect.h
//  FingerJoust
//
//  Created by Hunter Francis on 10/17/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Player, Jouster;
@interface PlayerSelect : CCLayerColor {
    CCSprite *isActiveSprite;
    CCLabelTTF * characterLabel;
    CCNode *isActiveNode;
    CCMenu *teamPlayMenu;
    CCMenuItemSprite *teamPlayItem;
    CCSprite *border;
    
    Jouster *currentJouster;
    
    CCMenu *playerChoiceMenu;
    
    CCLabelTTF *tapToJoinLabel;
    CCSprite *teamBG;
    CCSprite *lock;
    CCMenu *unlockMenu;
    
}
@property BOOL isLocked;
@property (nonatomic, assign) Player *player;

-(id) initWithPlayer:(Player *)p;


-(void) playerColorChangedToTeam:(int)team;
-(void) setBorderColorForPlayer;
-(void) playerCharacterChangedTo:(int) character From:(BOOL) leftSide;
-(void) activatePlayer;
-(void) deactivatePlayer;
-(void) turnOnTeamPlay;
-(void) turnOffTeamPlay;

@end
