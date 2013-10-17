//
//  Player.h
//  FingerJoust
//
//  Created by Hunter Francis on 10/16/13.
//  Copyright (c) 2013 Hunter Francis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject{
    
    int jousterType;
    int colorCombo;
    int team;
    int playerNumber;
    BOOL isActive;
}
@property int jousterType, colorCombo, team, playerNumber;
@property BOOL isActive;

@end
