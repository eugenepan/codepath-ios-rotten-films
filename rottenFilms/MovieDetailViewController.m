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

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.movie[@"title"];
    self.movieSynopsisTextView.text = self.movie[@"synopsis"];
    self.movieDetailImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.movieDetailImageView.layer.shadowOffset = CGSizeMake(1, 1);
    self.movieDetailImageView.layer.shadowOpacity = 0.8;
    self.movieDetailImageView.layer.shadowRadius = 2.0;
    self.movieDetailImageView.clipsToBounds = NO;
    
    NSString *oriImageString = [[self.movie valueForKeyPath:@"posters.thumbnail"] stringByReplacingOccurrencesOfString:@"_tmb" withString:@"_ori"];
    UIImage *movieThumbnail = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.movie valueForKeyPath:@"posters.thumbnail"]]]];
    [self.movieDetailImageView setImageWithURL:[NSURL URLWithString: oriImageString] placeholderImage:movieThumbnail];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
