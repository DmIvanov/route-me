 //
//  DIHelper.m
//  MapView
//
//  Created by Dmitry Ivanov on 19.01.14.
//
//

#import "DIHelper.h"

//#define TILE_SIZE           256


@interface DIHelper()
{
    NSDictionary *_dbDescription;
}
@end


@implementation DIHelper


#pragma mark - Offline Mode
+ (BOOL)offlineMode {
    return YES;
}
+ (BOOL)deceleration {
    return NO;
}


#pragma mark - Zoom
+ (double)maxZoom {
    return 17.;
}
+ (double)minZoom {
    return 10.;
}
+ (double)initialZoom {
    return 14.;
}


#pragma mark - LatLong
+ (double)initialLatitude {
    return 59.933;
}
+ (double)initialLongitude {
    return 30.315;
}


+ (CLLocationCoordinate2D)SWBorderPoint {
    return CLLocationCoordinate2DMake(59.8928, 30.1981);
}

+ (CLLocationCoordinate2D)NEBorderPoint {
    return CLLocationCoordinate2DMake(60.0033, 30.4117);
}



#pragma mark - Instance methods
+ (instancetype)sharedInstance {
    static DIHelper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DIHelper alloc] init];
    });
    return sharedInstance;
}
- (id)init {
    
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"dbDescription" ofType:@"plist"];
        _dbDescription = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return self;
}

//- (CGSize)viewSizeForZoom:(NSInteger)zoom {
//    if (_dbDescription) {
//        NSArray *zoomArray = _dbDescription[[NSString stringWithFormat:@"%@", @(zoom)]];
//        CGFloat width = zoomArray.count * TILE_SIZE;
//        if (zoomArray && zoomArray.count) {
//            NSDictionary *xDict = zoomArray[0];
//            NSArray *yArray = xDict[xDict.allKeys[0]];
//            CGFloat height = yArray.count * TILE_SIZE;
//            CGSize size = CGSizeMake(width, height);
//        }
//    }
//}

@end
