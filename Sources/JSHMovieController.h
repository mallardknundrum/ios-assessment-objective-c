//
//  JSHMovieController.h
//  MovieSearch
//
//  Created by Jeremiah Hawks on 3/3/17.
//  Copyright © 2017 Open Reel Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSHMovie.h"
@interface JSHMovieController : NSObject

@property (nonatomic) NSArray *moviesArray;

- (void)fetchMoviesWithSearchTerm:(NSString *)searchTerm completion:(void (^)(NSArray *moviesCompletionArray, NSError *error))completion;

@end
