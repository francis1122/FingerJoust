//
//  PlayerManager.h
//  FingerJoust
//
//  Created by Hunter Francis on 10/16/13.
//  Copyright (c) 2013 Hunter Francis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerManager : NSObject{
    NSMutableArray *playerArray;
}

@property (nonatomic, retain) NSMutableArray *playerArray;

+ (PlayerManager*)sharedInstance;


@end
