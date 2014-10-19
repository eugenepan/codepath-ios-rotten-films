//
//  MovieDetailViewController.m
//  rottenFilms
//
//  Created by Eugene Pan on 10/13/14.
//  Copyright (c) 2014 Eugene Pan. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import "QuartzCore/CALayer.h"

@interface MovieDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextView *movieSynopsisTextView;
@property (strong, nonatomic) IBOutlet UIImageView *movieDetailImageView;
@property (weak, nonatomic) IBOutlet UITextView *criticsRatingTextView;
@property (weak, nonatomic) IBOutlet UITextView *criticsScoreTextView;
@property (weak, nonatomic) IBOutlet UITextView *audienceRatingTextView;
@property (weak, nonatomic) IBOutlet UITextView *audienceScoreTextView;
@property (weak, nonatomic) IBOutlet UITextView *yearTextView;
@property (weak, nonatomic) IBOutlet UITextView *ratingTextView;

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.movie[@"title"];
    
    self.movieDetailImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.movieDetailImageView.layer.shadowOffset = CGSizeMake(1, 1);
    self.movieDetailImageView.layer.shadowOpacity = 0.8;
    self.movieDetailImageView.layer.shadowRadius = 2.0;
    self.movieDetailImageView.clipsToBounds = NO;
    
    NSString *oriImageString = [[self.movie valueForKeyPath:@"posters.thumbnail"] stringByReplacingOccurrencesOfString:@"_tmb" withString:@"_ori"];
    UIImage *movieThumbnail = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.movie valueForKeyPath:@"posters.thumbnail"]]]];
    [self.movieDetailImageView setImageWithURL:[NSURL URLWithString: oriImageString] placeholderImage:movieThumbnail];
    
    self.criticsRatingTextView.text = [self.movie valueForKeyPath:@"ratings.critics_rating"];
    self.criticsScoreTextView.text = [NSString stringWithFormat:@"%@", [self.movie valueForKeyPath:@"ratings.critics_score"]];
    self.audienceRatingTextView.text= [self.movie valueForKeyPath:@"ratings.audience_rating"];
    self.audienceScoreTextView.text= [NSString stringWithFormat:@"%@", [self.movie valueForKeyPath:@"ratings.audience_score"]];
    self.yearTextView.text = [NSString stringWithFormat:@"%@", [self.movie valueForKeyPath:@"year"]];
    self.ratingTextView.text = [NSString stringWithFormat:@"%@", [self.movie valueForKeyPath:@"mpaa_rating"]];
    self.movieSynopsisTextView.text = self.movie[@"synopsis"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
