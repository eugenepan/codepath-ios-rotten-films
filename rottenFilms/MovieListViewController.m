//
//  MovieListViewController.m
//  rottenFilms
//
//  Created by Eugene Pan on 10/13/14.
//  Copyright (c) 2014 Eugene Pan. All rights reserved.
//

#import "MovieListViewController.h"
#import "MovieTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "MovieDetailViewController.h"
#import "SVProgressHUD.h"

@interface MovieListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *moviesTableView;
@property (strong, nonatomic) NSArray *movies;
@end

@implementation MovieListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.moviesTableView.delegate = self;
    self.moviesTableView.dataSource = self;
    self.moviesTableView.rowHeight = 120;
    
    self.title = @"Rotten Movies";
    
    [self.moviesTableView registerNib:[UINib nibWithNibName:@"MovieTableViewCell" bundle:nil] forCellReuseIdentifier:@"MovieTableViewCell"];
    
    NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=3cw4jtr9vvp4ecsjh57fqhfr"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    [SVProgressHUD show];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        self.movies = responseDictionary[@"movies"];
        [SVProgressHUD dismiss];
        [self.moviesTableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.movies.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieTableViewCell *movieCell = [tableView dequeueReusableCellWithIdentifier: @"MovieTableViewCell"];
    
    movieCell.movieTitleTextView.userInteractionEnabled = NO;
    movieCell.movieSynopsisTextView.userInteractionEnabled = NO;
    
    movieCell.movieImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    movieCell.movieImageView.layer.shadowOffset = CGSizeMake(1, 1);
    movieCell.movieImageView.layer.shadowOpacity = 0.8;
    movieCell.movieImageView.layer.shadowRadius = 2.0;
    movieCell.movieImageView.clipsToBounds = NO;
    
    NSDictionary *movie = self.movies[indexPath.row];
    movieCell.movieTitleTextView.text = movie[@"title"];
    movieCell.movieSynopsisTextView.text = movie[@"synopsis"];
    
    NSString *movieThumbnailURL = [movie valueForKeyPath:@"posters.thumbnail"];
    [movieCell.movieImageView setImageWithURL:[NSURL URLWithString:movieThumbnailURL]];
    
    return movieCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MovieDetailViewController *vc = [[MovieDetailViewController alloc] init];
    vc.movie = self.movies[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
