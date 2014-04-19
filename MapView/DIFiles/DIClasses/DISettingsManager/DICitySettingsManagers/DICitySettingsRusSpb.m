//
//  DICitySettingsRusSpb.m
//  MapView
//
//  Created by Dmitry Ivanov on 19.04.14.
//
//

#import "DICitySettingsRusSpb.h"

#import <CoreLocation/CoreLocation.h>

@implementation DICitySettingsRusSpb

+ (DICitySettingsRusSpb *)sharedInstance {
    
    static DICitySettingsRusSpb *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DICitySettingsRusSpb alloc] initSingletone];
    });
    return sharedInstance;
}

- (id)initSingletone {
    
    self = [super init];
    if (self) {
    }
    return self;
}


#pragma mark - Zoom
- (double)maxZoom {
    return 18.;
}
- (double)minZoom {
    return 10.;
}
- (double)initialZoom {
    return 14.;
}


#pragma mark - LatLong
- (double)initialLatitude {
    return 59.933;
}
- (double)initialLongitude {
    return 30.315;
}
- (CLLocationCoordinate2D)SWBorderPoint {
    return CLLocationCoordinate2DMake(59.8928, 30.1981);
}
- (CLLocationCoordinate2D)NEBorderPoint {
    return CLLocationCoordinate2DMake(60.0033, 30.4117);
}


- (NSString*)dbPathForTileSource {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"spb_119909_10_18" ofType:@"sqlite"];
    return path;
}

@end
