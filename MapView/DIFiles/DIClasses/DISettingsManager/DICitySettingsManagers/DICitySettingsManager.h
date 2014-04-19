//
//  DICitySettingsManager.h
//  MapView
//
//  Created by Dmitry Ivanov on 19.04.14.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol DICitySettingsManager <NSObject>

@required

+ (instancetype)sharedInstance;

- (double)maxZoom;
- (double)minZoom;
- (double)initialZoom;

- (double)initialLatitude;
- (double)initialLongitude;

- (CLLocationCoordinate2D)SWBorderPoint;
- (CLLocationCoordinate2D)NEBorderPoint;

- (NSString*)dbPathForTileSource;

@end
