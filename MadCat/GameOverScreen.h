//
//  GameOverScreen.h
//  MadCat
//
//  Created by Yakov on 3/24/15.
//  Copyright (c) 2015 yakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameScreen.h"

@interface GameOverScreen : UIViewController

@property CGFloat screenCenter;

@property int score;

@property (weak, nonatomic) GameScreen *gameScreen;

@end
