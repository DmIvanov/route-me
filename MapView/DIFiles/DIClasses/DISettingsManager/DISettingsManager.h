//
//  DISettingsManager.h
//  
//
//  Created by Dmitry Ivanov on 19.04.14.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "DIDefaults.h"


@interface DISettingsManager : NSObject

@property (nonatomic) DICityID currentCity;

+ (DISettingsManager *)sharedInstance;
- (id)init __attribute__((unavailable("init is not available, use class methods 'sharedInstance' instead!")));
- (id)copy __attribute__((unavailable("copy is not available, use class methods 'sharedInstance' instead!")));


+ (BOOL)offlineMode;
+ (BOOL)deceleration;
+ (BOOL)uploadingTilesToFileSystem;
+ (BOOL)downloadingTilesFromFileSystem;
+ (BOOL)cacheBaseCleaning;


//CitySettingsManager responsibility
- (double)maxZoom;
- (double)minZoom;
- (double)initialZoom;

//CitySettingsManager responsibility
- (double)initialLatitude;
- (double)initialLongitude;

//CitySettingsManager responsibility
- (CLLocationCoordinate2D)SWBorderPoint;
- (CLLocationCoordinate2D)NEBorderPoint;

//CitySettingsManager responsibility
- (NSString*)dbPathForTileSource;

@end
