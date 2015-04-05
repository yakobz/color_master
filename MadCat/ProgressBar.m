//
//  ProgressBar.m
//  MadCat
//
//  Created by Yakov on 3/29/15.
//  Copyright (c) 2015 yakov. All rights reserved.
//

#import "ProgressBar.h"

@implementation ProgressBar {
    UIImageView *greenImageView;
    UIImageView *greyImageView;
    
    CGRect frameForGreenImage;
    CGRect frameForGreyImage;
    
    CGFloat maxWidth;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    maxWidth = frame.size.width;
    
    frameForGreenImage = CGRectMake(0,
                                    0,
                                    frame.size.width,
                                    frame.size.height);
    frameForGreyImage = CGRectMake(frameForGreenImage.size.width,
                                   0,
                                   0,
                                   frame.size.height);
    
    greenImageView = [[UIImageView alloc] initWithFrame:frameForGreenImage];
    greyImageView = [[UIImageView alloc] initWithFrame:frameForGreyImage];
    
    greenImageView.image = [UIImage imageNamed:@"green.png"];
    greyImageView.image = [UIImage imageNamed:@"grey.png"];
    
    [self addSubview:greenImageView];
    [self addSubview:greyImageView];
    
    return self;
}

- (void) setProgress:(CGFloat)progress {
    frameForGreenImage.size.width = maxWidth*progress;

    frameForGreyImage.origin.x = frameForGreenImage.size.width;
    frameForGreyImage.size.width = maxWidth*(1 - progress);
    
    [greenImageView setFrame:frameForGreenImage];
    [greyImageView setFrame:frameForGreyImage];
}

@end