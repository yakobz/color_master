//
//  GameOverScreen.m
//  MadCat
//
//  Created by Yakov on 3/24/15.
//  Copyright (c) 2015 yakov. All rights reserved.
//

#import "GameOverScreen.h"
#import "GameScreen.h"

@interface GameOverScreen () {
    int bestScore;
    
    NSString *pathToDataFile;
}

@property (weak, nonatomic) IBOutlet UILabel *gameOverLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestScoreLabel;

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *leaderboardButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;

@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@end

@implementation GameOverScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // get paths to data file
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    pathToDataFile = [paths objectAtIndex:0];
    pathToDataFile = [pathToDataFile stringByAppendingPathComponent:@"Data.plist"];
    
    self.gameOverLabel.font = [UIFont fontWithName:@"Theater" size:(self.screenCenter/5)];
    self.gameOverLabel.text = @"GAME OVER";
    
    self.scoreLabel.font = [UIFont fontWithName:@"Theater" size:(self.screenCenter/10)];
    self.bestScoreLabel.font = [UIFont fontWithName:@"Theater" size:(self.screenCenter/10)];
    
    //Make image tile
    UIImage *imageToTile = [UIImage imageNamed:@"main_title.png"];
    UIColor *tiledColor = [UIColor colorWithPatternImage:imageToTile];
    self.mainImage.backgroundColor = tiledColor;
    
    // get best score
    NSFileManager *fm = [NSFileManager defaultManager];    
    if([fm fileExistsAtPath:pathToDataFile] == YES) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:pathToDataFile];
        bestScore = [dict[@"bestScore"] intValue];
    } else {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@0 forKey:@"bestScore"];
        
        //TODO: check that writting was write
        [dict writeToFile:pathToDataFile atomically:YES];
        bestScore = 0;
    }
}

- (void) viewDidAppear:(BOOL)animated {
    if(bestScore < self.score) {
        bestScore = self.score;
        
        //write new best score to file
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:pathToDataFile];
        dict[@"bestScore"] = [NSNumber numberWithInt:bestScore];
        [dict writeToFile:pathToDataFile atomically:YES];
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"SCORE         %i", self.score];
    self.bestScoreLabel.text = [NSString stringWithFormat:@"BEST         %i", bestScore];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playButtonPressed:(id)sender {
    [self.playButton setImage:[UIImage imageNamed:@"play_pressed.png"] forState:UIControlStateNormal];
}

- (IBAction)playButtonReleased:(id)sender {
    [self.playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [self.view.superview addSubview:self.gameScreen.view];
    [self.view removeFromSuperview];
}

- (IBAction)leaderboardButtonPressed:(id)sender {
    [self.leaderboardButton setImage:[UIImage imageNamed:@"leaderboard_pressed.png"] forState:UIControlStateNormal];
}

- (IBAction)leaderboardButtonReleased:(id)sender {
    [self.leaderboardButton setImage:[UIImage imageNamed:@"leaderboard.png"] forState:UIControlStateNormal];
}

- (IBAction)shareButtonPressed:(id)sender {
    [self.shareButton setImage:[UIImage imageNamed:@"share_pressed.png"] forState:UIControlStateNormal];
}

- (IBAction)shareButtonReleased:(id)sender {
    NSString *shareMessage = [NSString stringWithFormat:@"Score for this round was: %i", self.score];
    NSArray *shareMessageArray = @[shareMessage];
    
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:shareMessageArray
                                                                           applicationActivities:nil];
    
    [self presentViewController:activity animated:YES completion:nil];
    [self.shareButton setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
}

- (IBAction)homeButtonPressed:(id)sender {
    [self.homeButton setImage:[UIImage imageNamed:@"home_pressed.png"] forState:UIControlStateNormal];
}

- (IBAction)homeButtonReleased:(id)sender {
    [self.homeButton setImage:[UIImage imageNamed:@"home.png"] forState:UIControlStateNormal];
    [self.gameScreen.view removeFromSuperview];
    [self.view removeFromSuperview];
    
}

@end
