//
//  DIHelper.h
//  MapView
//
//  Created by Dmitry Ivanov on 19.01.14.
//
//

#import <Foundation/Foundation.h>

@interface DIHelper : NSObject

+ (BOOL)offlineMode;

+ (double)maxZoom;
+ (double)minZoom;
+ (double)initialZoom;

+ (double)initialLatitude;
+ (double)initialLongitude;

@end
