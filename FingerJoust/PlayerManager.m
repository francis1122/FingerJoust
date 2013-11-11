//
//  PlayerManager.m
//  FingerJoust
//
//  Created by Hunter Francis on 10/16/13.
//  Copyright (c) 2013 Hunter Francis. All rights reserved.
//

#import "PlayerManager.h"
#import "Player.h"
#import "ZRIAPHelper.h"

@implementation PlayerManager

static PlayerManager *sharedInstance = nil;

@synthesize playerArray, isTeamPlay, windEvent, bombEvent, hurricaneEvent, spikeEvent, missileEvent, frequencyEvent, gameSpeed, isGameUnlocked;

+ (PlayerManager*)sharedInstance {
    @synchronized(self) {
		if (sharedInstance == nil)
			sharedInstance = [[[self class] alloc] init];
    }
    return sharedInstance;
}

-(id) init{
    if(self = [super init]){
        
        //have this called only when the app is opening for the first time on device
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"AppOpenedBefore"]){
            [[ZRIAPHelper sharedInstance] restoreCompletedTransactions];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AppOpenedBefore"];
        }
        
        [[ZRIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *_products) {
            if (success) {
                products = [[NSArray alloc] initWithArray:_products];
            }else{
                NSLog(@"In App Purchase Products Not Populated!");
            }
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
        self.playerArray = [NSMutableArray array];
        windEvent = EventOn;
        bombEvent = EventOn;
        hurricaneEvent = EventOn;
        spikeEvent = EventOn;
        missileEvent = EventOn;
        gameSpeed = 1;
        frequencyEvent = 1;
        for(int i = 0; i < 4; i++){
            Player *player = [[[Player alloc] init] autorelease];
            player.playerNumber = i;
            if(i < 2){
                player.team = 0;
            }else{
                player.team = 1;
            }
            [self.playerArray addObject:player];
        }
        
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"unlockGame"]) {
            self.isGameUnlocked = YES;
        } else {
            self.isGameUnlocked = NO;
        }
        
        
    }
    return self;
}


- (void)productPurchased:(NSNotification *)notification {
    NSString *title = @"Game Unlocked Successfully";
    NSString *message = nil;
    NSString * productIdentifier = notification.object;
    if ([productIdentifier isEqualToString:@"UnlockGameID"]) {
        [self unlockTheGame];
    }
    
    if (message) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_PurchaseCallback" object:nil];
    
    
}

-(void) purchaseProduct{
    for (SKProduct *product in products){
        if ([product.productIdentifier isEqualToString:@"UnlockGameID"]) {
            NSLog(@"Buying %@...", product.productIdentifier);
            [[ZRIAPHelper sharedInstance] buyProduct:product];
            break;
        }
    }
}

-(void) unlockTheGame{
    self.isGameUnlocked = YES;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"unlockGame"];
}

-(BOOL) isPlayerActive:(int) playerNumber{
    for(Player *player in self.playerArray){
        if(player.playerNumber == playerNumber){
            return player.isActive;
        }
    }
    return NO;
}

-(float) getGameSpeedScaler{
    float scaler = 1;
    if(gameSpeed == 0){
        scaler = .6;
    }else if(gameSpeed == 1){
        scaler = 1;
    }else if(gameSpeed == 2){
        scaler = 1.5;
    }
    return scaler;
}

@end
