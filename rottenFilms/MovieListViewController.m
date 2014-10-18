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

@property (strong, nonatomic) NSArray *movies;
@property (weak, nonatomic) IBOutlet UITableView *moviesTableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITextView *networkErrorTextView;
@property (weak, nonatomic) IBOutlet UITabBar *moviesTabBar;
@property (nonatomic, assign) NSString *currAPIEndpoint;

@end

@implementation MovieListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Rotten Movies";

    self.moviesTableView.delegate = self;
    self.moviesTableView.dataSource = self;
    
    self.moviesTabBar.delegate = self;
    
    self.moviesTableView.rowHeight = 120;
    [self.moviesTableView registerNib:[UINib nibWithNibName:@"MovieTableViewCell" bundle:nil]
               forCellReuseIdentifier:@"MovieTableViewCell"];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [self.refreshControl addTarget:self
                            action:@selector(loadMovies)
                  forControlEvents:UIControlEventValueChanged];
    [self.moviesTableView addSubview:self.refreshControl];
    [self.refreshControl.superview sendSubviewToBack:self.refreshControl];
    
    self.networkErrorTextView.layer.cornerRadius = 4.0f;
    
    self.currAPIEndpoint = @"box_office";
    
    [self loadMovies];
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
    
    NSString *movieThumbnailURL = [[movie valueForKeyPath:@"posters.thumbnail"] stringByReplacingOccurrencesOfString:@"_tmb" withString:@"_det"];
    [movieCell.movieImageView setImageWithURL:[NSURL URLWithString:movieThumbnailURL]];
    
    return movieCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MovieDetailViewController *vc = [[MovieDetailViewController alloc] init];
    vc.movie = self.movies[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSLog(@"didSelectItem: %ld", (long)item.tag);
    
    switch (item.tag) {
        case 0:
            self.currAPIEndpoint = @"box_office";
            break;
        case 1:
            self.currAPIEndpoint = @"in_theaters";
            break;
        case 2:
            self.currAPIEndpoint = @"opening";
            break;
        case 3:
            self.currAPIEndpoint = @"upcoming";
            break;
    }
    
    [self loadMovies];
}

- (void) loadMovies {
    self.networkErrorTextView.hidden = YES;
    
    [SVProgressHUD show];
    
    NSString *apiCall = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/%@.json?apikey=3cw4jtr9vvp4ecsjh57fqhfr", self.currAPIEndpoint];
    
    NSURL *url = [NSURL URLWithString:apiCall];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError) {
                                   self.networkErrorTextView.hidden = NO;
                               } else {
                                   NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   self.movies = responseDictionary[@"movies"];
                                   [self.moviesTableView reloadData];
                               }
                               [SVProgressHUD dismiss];
                           }];
    
    [self.refreshControl endRefreshing];
}

@end
