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

+ (double)maxZoom;
+ (double)minZoom;
+ (double)initialZoom;

+ (double)initialLatitude;
+ (double)initialLongitude;

-(CGPoint)isMovementAvailableToRect:(RMTileRect)rect toDisplayIn:(CGRect)bounds;

@end
