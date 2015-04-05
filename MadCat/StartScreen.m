//
//  StartScreen.m
//  MadCat
//
//  Created by Yakov on 3/24/15.
//  Copyright (c) 2015 yakov. All rights reserved.
//

#import "StartScreen.h"
#import "GameScreen.h"

@interface StartScreen ()

@property CGFloat screenCenter;
@property BOOL isSoundOn;
@property BOOL isHardLevel;

@property (weak, nonatomic) IBOutlet UILabel *gameNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *leaderboardButton;
@property (weak, nonatomic) IBOutlet UIButton *markappButton;
@property (weak, nonatomic) IBOutlet UIButton *levelButton;
@property (weak, nonatomic) IBOutlet UIButton *soundButton;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;

@property (weak, nonatomic) IBOutlet UIImageView *mainImage;

@property (strong, nonatomic) GameScreen *gameScreen;

@end

@implementation StartScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.screenCenter = self.view.frame.size.width/2;
    
    self.gameNameLabel.font = [UIFont fontWithName:@"Theater" size:(self.screenCenter/7.5)];
    self.gameNameLabel.text = @"Color Master";
    
    self.gameScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"Game"];
    self.gameScreen.screenCenter = self.screenCenter;
    
    //Make image tile
    UIImage *imageToTile = [UIImage imageNamed:@"main_title.png"];
    UIColor *tiledColor = [UIColor colorWithPatternImage:imageToTile];
    self.mainImage.backgroundColor = tiledColor;
    
    self.isSoundOn = NO;
    self.isHardLevel = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playButtonPressed:(id)sender {
    self.gameScreen.isSoundOn = self.isSoundOn;
    self.gameScreen.isHardLevel = self.isHardLevel;
    [self.playButton setImage:[UIImage imageNamed:@"play_pressed.png"] forState:UIControlStateNormal];
}

- (IBAction)playButtonReleased:(id)sender {
    [self.playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [self.view addSubview:self.gameScreen.view];
}

- (IBAction)leaderboardButtonPressed:(id)sender {
    [self.leaderboardButton setImage:[UIImage imageNamed:@"leaderboard_pressed.png"] forState:UIControlStateNormal];
}

- (IBAction)leaderboardButtonReleased:(id)sender {
    [self.leaderboardButton setImage:[UIImage imageNamed:@"leaderboard.png"] forState:UIControlStateNormal];
}

- (IBAction)markappButtonPressed:(id)sender {
    [self.markappButton setImage:[UIImage imageNamed:@"markapp_pressed.png"] forState:UIControlStateNormal];
}

- (IBAction)markappButtonReleased:(id)sender {
    [self.markappButton setImage:[UIImage imageNamed:@"markapp.png"] forState:UIControlStateNormal];
}

- (IBAction)levelButtonPressed:(id)sender {
}

- (IBAction)levelButtonReleased:(id)sender {
    if(self.isHardLevel) {
        self.isHardLevel = NO;
        [self.levelButton setImage:[UIImage imageNamed:@"game_difficalty_1.png"] forState:UIControlStateNormal];
    } else {
        self.isHardLevel = YES;
        [self.levelButton setImage:[UIImage imageNamed:@"game_difficalty_2.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)soundButtonPressed:(id)sender {
    if(self.isSoundOn)
        [self.soundButton setImage:[UIImage imageNamed:@"sound_on_pressed.png"] forState:UIControlStateNormal];
    else
        [self.soundButton setImage:[UIImage imageNamed:@"sound_off_pressed.png"] forState:UIControlStateNormal];
}

- (IBAction)soundButtonReleased:(id)sender {
    if(self.isSoundOn) {
        self.isSoundOn = NO;
        [self.soundButton setImage:[UIImage imageNamed:@"sound_off.png"] forState:UIControlStateNormal];
    } else {
        self.isSoundOn = YES;
        [self.soundButton setImage:[UIImage imageNamed:@"sound_on.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)helpButtonPressed:(id)sender {
    [self.helpButton setImage:[UIImage imageNamed:@"help_pressed.png"] forState:UIControlStateNormal];
}

- (IBAction)helpButtonReleased:(id)sender {
    [self.helpButton setImage:[UIImage imageNamed:@"help.png"] forState:UIControlStateNormal];
}

@end
