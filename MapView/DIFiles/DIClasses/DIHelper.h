//
//  DIHelper.h
//  MapView
//
//  Created by Dmitry Ivanov on 19.01.14.
//
//

#import <Foundation/Foundation.h>
#import "RMTile.h"

@interface DIHelper : NSObject

+ (instancetype)sharedInstance;

+ (BOOL)offlineMode;
+ (BOOL)deceleration;

+ (NSUInteger)maxZoom;
+ (NSUInteger)minZoom;
+ (NSUInteger)initialZoom;

+ (double)initialLatitude;
+ (double)initialLongitude;

//-(CGPoint)isMovementAvailableToRect:(RMTileRect)rect toDisplayIn:(CGRect)bounds;
- (CGSize)viewSizeForZoom:(NSUInteger)zoom;
- (CGPoint)contentOffsetForTileRect:(RMTileRect)tileRect;

@end
