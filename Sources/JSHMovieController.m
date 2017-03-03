//
//  JSHMovieController.m
//  MovieSearch
//
//  Created by Jeremiah Hawks on 3/3/17.
//  Copyright © 2017 Open Reel Software. All rights reserved.
//

#import "JSHMovieController.h"
#import "JSHMovie.h"

@interface JSHMovieController ()

@property (nonatomic, copy) NSString *baseURL;
@property (nonatomic, copy) NSString *apiKey;

@end

@implementation JSHMovieController : NSObject

-(instancetype)init
{
    self = [super init];
    if (self) {
        _baseURL = @"https://api.themoviedb.org/3/search/movie";
        _apiKey = @"e1d1200cb6c2133d1a0a490d72bbd5e4";
    }
    return self;
}

- (void)fetchMoviesWithSearchTerm:(NSString *)searchTerm completion:(void (^)(NSArray *moviesCompletionArray, NSError *))completion
{
    // Prepare search term:
    NSString *escapedSearchTerm = [searchTerm stringByReplacingOccurrencesOfString:@" " withString:@"%20" ];
    
    // Build URL & Query Items
    NSURL *baseURL = [NSURL URLWithString:[self baseURL]];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:baseURL resolvingAgainstBaseURL:YES];
    NSURLQueryItem *searchItem = [NSURLQueryItem queryItemWithName:@"query" value:escapedSearchTerm];
    NSURLQueryItem *apiKeyItem = [NSURLQueryItem queryItemWithName:@"api_key" value:[self apiKey]];
    NSURLQueryItem *languageItem = [NSURLQueryItem queryItemWithName:@"language" value:@"en-US"];
    NSURLQueryItem *includeAdultItem = [NSURLQueryItem queryItemWithName:@"include_adult" value:@"true"];
    urlComponents.queryItems = @[apiKeyItem, languageItem, searchItem, includeAdultItem];
    NSURL *url = urlComponents.URL;
    NSLog(@"url: %@", url.description);
    
    // Storage to pass to the completion
    NSMutableArray *fetchMovieArray = [[NSMutableArray alloc] init];
    
    // Create Dispatch Group
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error - Problem with data task: %@", error);
            completion (nil, error);
        }
        if (!data) {
            NSLog(@"Error: no data returned from the task. Error: %@", error);
            completion(nil, error);
        }
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (!jsonDict || ![jsonDict isKindOfClass:[NSDictionary class]]) {
            NSLog(@"Error, could not parse JSON correctly - Error: %@", error);
            completion(nil, error);
        }
        NSArray *resultsArray = [jsonDict valueForKey:@"results"];
        
        for (NSDictionary *resultDictionary in resultsArray) {
            dispatch_group_enter(group);
            JSHMovie *movieInitialized = [[JSHMovie alloc] initWithDictionary:resultDictionary];
            if ([movieInitialized.imageEndpoint isKindOfClass: [NSNull class]]) {
                movieInitialized.imageEndpoint = @"/c414cDeQ9b6qLPLeKmiJuLDUREJ.jpg";
            }
            NSString *baseURL = [NSString stringWithFormat:@"http://image.tmdb.org/t/p/w500"];
            NSString *imageURLString = [NSString stringWithFormat:@"%@%@", baseURL, movieInitialized.imageEndpoint];
            NSLog(@"Movie Image URL: %@", imageURLString);
            NSURLComponents *urlComponents = [NSURLComponents componentsWithString:imageURLString];
            NSURL *url = urlComponents.URL;
            [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error || !data) {
                    NSLog(@"No data was returned from the photo data task. Error: %@", error);
                    dispatch_group_leave(group);
                } else {
                    UIImage *movieImage = [[UIImage alloc]initWithData:data];
                    movieInitialized.movieImage = movieImage;
                    [fetchMovieArray addObject:movieInitialized];
                    dispatch_group_leave(group);
                }
            }]resume];
        }
        dispatch_group_leave(group);
    }]resume];
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSArray *completionArray = [NSArray arrayWithArray:fetchMovieArray];
    completion(completionArray, nil);
}

@end






























