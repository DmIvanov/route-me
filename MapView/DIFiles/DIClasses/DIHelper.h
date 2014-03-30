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

+ (BOOL)offlineMode;
+ (BOOL)deceleration;
+ (BOOL)uploadingTilesToFileSystem;
+ (BOOL)downloadingTilesFromFileSystem;
+ (BOOL)cacheBaseCleaning;

+ (double)maxZoom;
+ (double)minZoom;
+ (double)initialZoom;

+ (double)initialLatitude;
+ (double)initialLongitude;

+ (CLLocationCoordinate2D)SWBorderPoint;
+ (CLLocationCoordinate2D)NEBorderPoint;

- (void)addImageToFolder:(NSData *)imageData forTile:(RMTile)tile;
- (void)downloadTilesToDBFromFolder;

- (BOOL)roundingCeil;

@end
