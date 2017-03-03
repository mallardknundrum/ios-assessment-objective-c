//
//  JSHMovie.h
//  MovieSearch
//
//  Created by Jeremiah Hawks on 3/3/17.
//  Copyright © 2017 Open Reel Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JSHMovie : NSObject

-(instancetype)initWithTitle:(NSString *)title rating:(NSString *)rating plot:(NSString *)plot imageEndpoint:(NSString *)imageEndpoint NS_DESIGNATED_INITIALIZER;
-(instancetype)initWithDictionary:(NSDictionary<NSString *, id> *)jsonDictionary;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *rating;
@property (nonatomic, copy) NSString *plot;
@property (nonatomic, copy) UIImage *movieImage;
@property (nonatomic, copy) NSString *imageEndpoint;

@end
