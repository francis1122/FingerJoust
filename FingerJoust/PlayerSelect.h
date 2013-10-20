//
//  PlayerSelect.h
//  FingerJoust
//
//  Created by Hunter Francis on 10/17/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Player;
@interface PlayerSelect : CCLayerColor {
    CCSprite *isActiveSprite;
    CCLabelTTF * characterLabel;
    CCNode *isActiveNode;
    CCMenu *teamPlayMenu;
    CCMenuItemSprite *teamPlayItem;
    CCSprite *border;
}

@property (nonatomic, assign) Player *player;

-(id) initWithPlayer:(Player *)p;


-(void) playerColorChangedToTeam:(int)team;
-(void) setBorderColorForPlayer;
-(void) playerCharacterChangedTo:(int) character;
-(void) activatePlayer;
-(void) deactivatePlayer;
-(void) turnOnTeamPlay;
-(void) turnOffTeamPlay;

@end
