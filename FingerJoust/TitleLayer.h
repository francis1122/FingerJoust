//
//  TitleLayer.h
//  FingerJoust
//
//  Created by Hunter Francis on 7/11/13.
//  Copyright 2013 Hunter Francis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class SettingsPanel, AboutPanel;
@interface TitleLayer : CCLayerColor {
    CCSprite *jousterBoxLeft, *jousterBoxRight;
    SettingsPanel *settingsMenu;
    AboutPanel *aboutMenu;
    NSMutableArray *playerSelectArray;
    CCMenu *menu;
    CCSprite *logo;
//    CCLabelTTF *ballLabel;
//    CCLabelTTF *busterLabel;
}

@property (nonatomic, assign) SettingsPanel *settingsMenu;
@property (nonatomic, assign) AboutPanel *aboutMenu;
@property (nonatomic, assign) CCMenu *menu;
@property (nonatomic, retain) NSMutableArray *playerSelectArray;

-(void) setWinner:(NSString*) winner;

-(void) animateOut;

@end
