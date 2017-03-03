//
//  JSHMovie.m
//  MovieSearch
//
//  Created by Jeremiah Hawks on 3/3/17.
//  Copyright © 2017 Open Reel Software. All rights reserved.
//

#import "JSHMovie.h"

@implementation JSHMovie

-(instancetype)initWithTitle:(NSString *)title rating:(NSString *)rating plot:(NSString *)plot imageEndpoint:(NSString *)imageEndpoint
{
    self = [super init];
    if (self) {
        _title = [title copy];
        _rating = [rating copy];
        _plot = [plot copy];
        _imageEndpoint = [imageEndpoint copy];
    }
    return self;
}
-(instancetype)initWithDictionary:(NSDictionary *)jsonDictionary
{
    NSString *title = jsonDictionary[@"title"];
    NSString *rating =[NSString stringWithFormat:@"%@", [jsonDictionary[@"vote_average"] stringValue]];
    NSString *plot = jsonDictionary[@"overview"];
    NSString *imageEndpoint = jsonDictionary[@"poster_path"];
    if (!title ||
        !rating ||
        !plot ||
        !imageEndpoint) {
        NSLog(@"Error: Missing information. Could not create instance of Movie from JSON dictionary.");
        return nil;
    }
    return [self initWithTitle:title rating:rating plot:plot imageEndpoint:imageEndpoint];
}


@end
