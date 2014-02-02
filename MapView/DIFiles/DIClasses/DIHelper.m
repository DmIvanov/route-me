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
    return 11.;
}


#pragma mark - LatLong
+ (double)initialLatitude {
    return 59.933;
}
+ (double)initialLongitude {
    return 30.315;
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

//checking if it possible to move by delta
-(CGPoint)isMovementAvailableToRect:(RMTileRect)rect toDisplayIn:(CGRect)bounds {
    
    //all the code don't work without this copying
    NSDictionary *descr = [_dbDescription copy];
    
    NSUInteger zoom, x, y;
    CGPoint movingAvailability = CGPointZero;
    
    if (!_dbDescription)
        return movingAvailability;
    
	RMTileRect roundedRect = RMTileRectRound(rect);
	// The number of tiles we'll load in the vertical and horizontal directions
	int tileRegionWidth = (int)roundedRect.size.width;
	int tileRegionHeight = (int)roundedRect.size.height;
    
    zoom = rect.origin.tile.zoom;
    NSString *key = [NSString stringWithFormat:@"%@", @(zoom)];
    NSArray *zoomArray = descr[key];
    
    if (!zoomArray)
        return movingAvailability;
    
    movingAvailability.x = 1.;
    for (x = roundedRect.origin.tile.x; x < roundedRect.origin.tile.x + tileRegionWidth; x++) {
        //NSLog(@"checking x - %@", @(x));
        NSUInteger index = [zoomArray indexOfObjectPassingTest:^BOOL(NSDictionary *xDict, NSUInteger idx, BOOL *stop) {
            //NSLog(@"xDict key - %@", xDict.allKeys[0]);
            return [xDict.allKeys[0] isEqualToString:[NSString stringWithFormat:@"%@", @(x)]];
        }];
        if (index == NSNotFound) {
            movingAvailability.x = 0.;
            //NSLog(@"movingAvailability.x = 0. [%@]", NSStringFromCGPoint(movingAvailability));
            break;
        }
    }
    
    movingAvailability.y = 1.;
    for (NSDictionary *xDict in zoomArray) {
        NSArray *yArray = xDict[xDict.allKeys[0]];
        //NSLog(@"yArray - %@", yArray);
        for (y = roundedRect.origin.tile.y; y < roundedRect.origin.tile.y + tileRegionHeight; y++) {
            //NSLog(@"checking y - %@", @(y));
            NSUInteger index = [yArray indexOfObjectPassingTest:^BOOL(NSNumber *yN, NSUInteger idx, BOOL *stop) {
                return [yN isEqualToNumber:@(y)];
            }];
            if (index == NSNotFound) {
                movingAvailability.y = 0.;
                //NSLog(@"movingAvailability.y = 0. [%@]", NSStringFromCGPoint(movingAvailability));
                break;
            }
        }
    }
    //NSLog(NSStringFromCGPoint(movingAvailability));
    return movingAvailability;
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
