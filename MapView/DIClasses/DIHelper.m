//
//  DIHelper.m
//  MapView
//
//  Created by Dmitry Ivanov on 19.01.14.
//
//

#import "DIHelper.h"

@implementation DIHelper


#pragma mark - Offline Mode

+ (BOOL)offlineMode {
    
    return YES;
}


#pragma mark - Zoom

+ (double)maxZoom {
    
    return 18.;
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


@end
