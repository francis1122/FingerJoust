//
//  SettingsPanel.h
//  FingerJoust
//
//  Created by Hunter Francis on 10/24/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SettingsPanel : CCLayerColor {
    BOOL isActive;
    CCMenuItemFont *menuToggle;
    CCSprite *windActive, *bombActive, *hurricaneActive, *spikeActive, *missileActive;
}

-(void) resolve;

-(void) makeEventSettingsItemFor:(NSString*) title AtPosition:(CGPoint) position WithState:(int)state WithActiveSprite:(CCSprite*) activeSprite WithCallback:(SEL) selector;


-(void) windCallback:(CCMenuItemFont*) sender;
-(void) bombCallback:(CCMenuItemFont*) sender;
-(void) hurricaneCallback:(CCMenuItemFont*) sender;
-(void) missileCallback:(CCMenuItemFont*) sender;
-(void) spikeCallback:(CCMenuItemFont*) sender;
@end