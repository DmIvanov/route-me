//
//  DIHelper.h
//  MapView
//
//  Created by Dmitry Ivanov on 19.01.14.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "RMTile.h"

@interface DIHelper : NSObject

@property (nonatomic) BOOL mapRoundingCeil;

+ (instancetype)sharedInstance;

- (void)addImageToFolder:(NSData *)imageData forTile:(RMTile)tile;
- (void)downloadTilesToDBFromFolder;

- (BOOL)roundingCeil;

+ (NSInteger)randomValueBetween:(NSInteger)min and:(NSInteger)max;

@end
