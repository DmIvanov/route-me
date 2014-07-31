//
//  DICitySettingsRusSpb.m
//  MapView
//
//  Created by Dmitry Ivanov on 19.04.14.
//
//

#import "DICitySettingsRusSpb.h"
#import "DISettingsManager.h"

#import <CoreLocation/CoreLocation.h>


#define FULL_MAP_FILENAME       @"rus_spb_13_17.sqlite"


@implementation DICitySettingsRusSpb
{
    BOOL _fullDBDownloaded;
}

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
        _fullDBDownloaded = YES;
    }
    return self;
}


#pragma mark - Zoom
- (double)maxZoom {
    if (_fullDBDownloaded)
        return 17.;
    else
        return 17.;
}
- (double)minZoom {
    return 13.;
}
- (double)initialZoom {
    return 13.;
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


- (NSString *)dbPathForTileSource {
    
    NSString *path;
    if ([DISettingsManager downloadingTilesFromFileSystem]) {
        path = [self pathInDocumentsDir];
        path = [path stringByAppendingPathComponent:FULL_MAP_FILENAME];
    }
    else {
        if (_fullDBDownloaded) {
            path = [[NSBundle mainBundle] pathForResource:@"rus_spb_13_17" ofType:@"sqlite"];
        }
        else
            path = [[NSBundle mainBundle] pathForResource:@"rus_spb_13_17" ofType:@"sqlite"];
    }
    return path;
}

- (NSString *)pathInDocumentsDir {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"MapsDB"];
    //if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
    //    [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
    return dataPath;
}

@end
