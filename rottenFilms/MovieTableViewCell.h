//
//  MovieTableViewCell.h
//  rottenFilms
//
//  Created by Eugene Pan on 10/13/14.
//  Copyright (c) 2014 Eugene Pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *movieImageView;
@property (weak, nonatomic) IBOutlet UITextView *movieSynopsisTextView;
@property (weak, nonatomic) IBOutlet UITextView *movieTitleTextView;

@end
