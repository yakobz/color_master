//
//  GameScreen.m
//  MadCat
//
//  Created by Yakov on 3/19/15.
//  Copyright (c) 2015 yakov. All rights reserved.
//

#import "GameScreen.h"
#import "GameOverScreen.h"
#import "ProgressBar.h"
#import <AVFoundation/AVFoundation.h>

@interface GameScreen () {
    int score;
    CGPoint locationWhenSlidingIsBegan;
    
    BOOL areLeftLabelTextAndColorSame;
    BOOL areRightLabelTextAndColorSame;
    
    ProgressBar *leftProgressBar;
    ProgressBar *rightProgressBar;
    
    CGFloat progressLeftProgressBar;
    CGFloat progressRightProgressBar;
    
    CGFloat progressSpead;
    
    NSTimer *timer;

    AVAudioPlayer *correctSong;
    AVAudioPlayer *incorrectSong;
}

@property (strong, nonatomic) GameOverScreen *gameOverScreen;

@property (copy, nonatomic) NSArray *text;
@property (copy, nonatomic) NSArray *color;
@property (copy, nonatomic) NSArray *backgrounds;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;

@end

@implementation GameScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.text = @[@"Red", @"Pink", @"Purple", @"Indigo", @"Blue",
                  @"Teal", @"Green", @"Yellow", @"Orange", @"Brown"];
    
    self.color = @[[NSNumber numberWithUnsignedInt:0xB71C1C],  /*red     0*/
                   [NSNumber numberWithUnsignedInt:0xEC407A],  /*pink    1*/
                   [NSNumber numberWithUnsignedInt:0x9C27B0],  /*purple  2*/
                   [NSNumber numberWithUnsignedInt:0x3F51B5],  /*indigo  3*/
                   [NSNumber numberWithUnsignedInt:0x64B5F6],  /*blue    4*/
                   [NSNumber numberWithUnsignedInt:0x009688],  /*teal    5*/
                   [NSNumber numberWithUnsignedInt:0x388E3C],  /*green   6*/
                   [NSNumber numberWithUnsignedInt:0xFDD835],  /*yellow  7*/
                   [NSNumber numberWithUnsignedInt:0xEF6C00],  /*orange  8*/
                   [NSNumber numberWithUnsignedInt:0x795548]]; /*brown   9*/
    
    self.backgrounds = @[@"tile_1.png", @"tile_2.png",
                         @"tile_3.png", @"tile_4.png",
                         @"tile_5.png", @"tile_6.png",
                         @"tile_7.png", @"tile_8.png",
                         @"tile_9.png", @"tile_10.png",
                         @"tile_11.png", @"tile_12.png",
                         @"tile_13.png", @"tile_14.png",
                         @"tile_15.png", @"tile_16.png",
                         @"tile_17.png", @"tile_18.png",
                         @"tile_19.png", @"tile_20.png",
                         @"tile_21.png", @"tile_22.png",
                         @"tile_23.png", @"tile_24.png",
                         @"tile_25.png"];
    
    
    self.leftLabel.font = [UIFont fontWithName:@"Theater" size:(self.screenCenter/3.8)];
    self.rightLabel.font = [UIFont fontWithName:@"Theater" size:(self.screenCenter/3.8)];
    self.scoreLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:(self.screenCenter/10)];
    
    //Background will be oval
    self.leftLabel.layer.masksToBounds = YES;
    self.leftLabel.layer.cornerRadius = 15;
    self.rightLabel.layer.masksToBounds = YES;
    self.rightLabel.layer.cornerRadius = 15;
    
    self.gameOverScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"GameOver"];
    self.gameOverScreen.screenCenter = self.screenCenter;
    
    //Set up progress bar
    CGFloat progressBarWidth = self.screenCenter * 0.993;
    
    leftProgressBar = [[ProgressBar alloc] initWithFrame:CGRectMake(0,                      //origin.x
                                                                    0,                      //origin.y
                                                                    progressBarWidth,       //origin.widht
                                                                    self.screenCenter/25)]; //origin.height

    rightProgressBar = [[ProgressBar alloc] initWithFrame:CGRectMake(2*self.screenCenter,
                                                                     0,
                                                                     -progressBarWidth,
                                                                     self.screenCenter/25)];

    [self.view addSubview:leftProgressBar];
    [self.view addSubview:rightProgressBar];
    
    NSString *pathToCorrectSound = [[NSBundle mainBundle] pathForResource:@"correct" ofType:@"wav"];
    NSString *pathToIncorrectSound = [[NSBundle mainBundle] pathForResource:@"incorrect" ofType:@"wav"];
    
    NSURL *urlForCorrectSound = [NSURL fileURLWithPath:pathToCorrectSound];
    NSURL *urlForIncorrectSound = [NSURL fileURLWithPath:pathToIncorrectSound];
    
    correctSong = [[AVAudioPlayer alloc] initWithContentsOfURL:urlForCorrectSound error:nil];
    incorrectSong = [[AVAudioPlayer alloc] initWithContentsOfURL:urlForIncorrectSound error:nil];
}

- (void) viewDidAppear:(BOOL)animated {
    if([timer isValid] == NO) {
        [self turnOnTimer];
    }
    progressSpead = 0.0213;
    
    //We change screen two times (for left side and right side), and for this operations
    //value of score was increase
    score = -2;
    [self changeScreenLabel:self.leftLabel andImage:self.leftImage];
    [self changeScreenLabel:self.rightLabel andImage:self.rightImage];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    locationWhenSlidingIsBegan = [touch locationInView:touch.view];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //When text and color the same, for correct answer we must move finger up
    UITouch *touch = [touches anyObject];
    CGPoint locationWhenSlidingIsEnded = [touch locationInView:touch.view];
    
    BOOL areSlidingUp, areLeftSide;

    //If we sliding finger up (y coordinates started from top of screen and move down)
    if((locationWhenSlidingIsEnded.y - locationWhenSlidingIsBegan.y) < 0)
        areSlidingUp = YES;
    else
        areSlidingUp = NO;
    
    //if this is left label
    if(locationWhenSlidingIsBegan.x < self.screenCenter)
        areLeftSide = YES;
    else
        areLeftSide = NO;
    
    //If we in left label:
    //if we sliding up and text and color the same
    if((areSlidingUp && areLeftSide && areLeftLabelTextAndColorSame) ||
    //or we sliding down and text and color not the same
       (!areSlidingUp && areLeftSide && !areLeftLabelTextAndColorSame))
    {
        [self changeScreenLabel:self.leftLabel andImage:self.leftImage];
        [self playSound:correctSong];
        return;
    }
    
    //If we in right label:
    //if we sliding up and text and color the same
    if ((areSlidingUp && !areLeftSide && areRightLabelTextAndColorSame) ||
    //or we sliding down and text and color are not the same
        (!areSlidingUp && !areLeftSide && !areRightLabelTextAndColorSame))
    {
        [self changeScreenLabel:self.rightLabel andImage:self.rightImage];
        [self playSound:correctSong];
        return;
    }
    
    [self playSound:incorrectSong];
    //in another cases
    [self goToGameOverScreen];
}

- (UIColor*)colorWithHex:(NSNumber*)hexColor {
    //Convert hex value for color to rgb value
    
    //For red in hex number value was third byte, so we shift hexValue to 2 byte to right and
    //highlight this third byte. Received value is devided by 300 (it's
    //max value for any of colors identifier), because for method
    //colorWithRed: green: blue: alpha: this values must be from 0.0 to 1.0
    CGFloat red = ((hexColor.unsignedIntValue >> 16) & 0x0000FF)/300.0;
    
    //Similarly to the red, just for green it was second byte
    CGFloat green = ((hexColor.unsignedIntValue >> 8) & 0x0000FF)/300.0;
    
    //1st byte
    CGFloat blue = (hexColor.unsignedIntValue & 0x0000FF)/300.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

- (void) changeScreenLabel:(UILabel*)label andImage:(UIImageView*)image {
    int textIndex, colorIndex;

    if((arc4random() % 2) == 0) {
        //maybe different (or same) text and color
        textIndex = arc4random()%10;
        colorIndex = arc4random()%10;
    } else {
        //same text and color
        textIndex = arc4random()%10;
        colorIndex = textIndex;
    }
    
    label.text = self.text[textIndex];
    label.textColor = [self colorWithHex:self.color[colorIndex]];

    //Make image tile
    UIImage *imageToTile = [UIImage imageNamed:self.backgrounds[arc4random()%25]];
    UIColor *tiledColor = [UIColor colorWithPatternImage:imageToTile];
    image.backgroundColor = tiledColor;
    
    BOOL areLabelTextAndColorSame;
    if(textIndex == colorIndex)
        areLabelTextAndColorSame = YES;
    else
        areLabelTextAndColorSame = NO;
    
    if(label == self.leftLabel) {
        areLeftLabelTextAndColorSame = areLabelTextAndColorSame;
        progressLeftProgressBar = 1;
    } else {
        if(self.isHardLevel == YES) {
            label.text = [self reverseString:label.text];
        }
        areRightLabelTextAndColorSame = areLabelTextAndColorSame;
        progressRightProgressBar = 1;
    }
    
    score++;
    self.scoreLabel.text = [NSString stringWithFormat:@"%i", score];
}

- (void) goToGameOverScreen {
    [timer invalidate];

    self.gameOverScreen.score = score;
    self.gameOverScreen.gameScreen = self;
    [self.view.superview addSubview:self.gameOverScreen.view];
    [self.view removeFromSuperview];
}

- (void)onTimer {
    [self checkProgress];
    
    progressLeftProgressBar -= progressSpead;
    progressRightProgressBar -= progressSpead;
    
    if((progressLeftProgressBar <= 0) || (progressRightProgressBar <= 0)) {
        [self goToGameOverScreen];
    }
    
    [leftProgressBar setProgress:progressLeftProgressBar];
    [rightProgressBar setProgress:progressRightProgressBar];
}

- (void)turnOnTimer {
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    
    progressLeftProgressBar = 1;
    progressRightProgressBar = 1;
}

- (void) checkProgress {
    if (score <= 5 && score >= 0) {
        progressSpead = 0.0213;
    } else if (score <= 10 && score > 5) {
        progressSpead = 0.0222;
    } else if (score <= 15 && score > 10) {
        progressSpead = 0.0238;
    } else if (score <= 20 && score > 15) {
        progressSpead = 0.027;
    } else if (score <= 25 && score > 20) {
        progressSpead = 0.03125;
    } else if (score <= 30 && score > 25) {
        progressSpead = 0.037;
    } else if (score <= 35 && score > 30) {
        progressSpead = 0.04545;
    } else if (score <= 40 && score > 35) {
        progressSpead = 0.05;
    } else if (score <= 45 && score > 40) {
        progressSpead = 0.0667;
    } else if (score <= 50 && score > 45) {
        progressSpead = 0.0689;
    } else if (score <= 55 && score > 50) {
        progressSpead = 0.0714;
    } else if (score <= 60 && score > 55) {
        progressSpead = 0.0741;
    } else if (score <= 65 && score > 60) {
        progressSpead = 0.0769;
    } else if (score <= 70 && score > 65) {
        progressSpead = 0.08;
    } else {
        progressSpead = 0.01;
    }
}

- (NSString*)reverseString:(NSString*)string {
    int length = [string length];
    NSMutableString *reversedString = [[NSMutableString alloc] initWithCapacity:[string length]];
    
    for(int i = length - 1; i >= 0; i--) {
        [reversedString appendFormat:@"%c", [string characterAtIndex:i]];
    }
    
    return reversedString;
}

- (void)playSound:(AVAudioPlayer*)sound {
    if(self.isSoundOn == YES) {
        [sound play];
    }
}

@end