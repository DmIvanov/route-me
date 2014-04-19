//
//  DICitySettingsRusSpb.h
//  MapView
//
//  Created by Dmitry Ivanov on 19.04.14.
//
//

#import <Foundation/Foundation.h>

#import "DICitySettingsManager.h"


@interface DICitySettingsRusSpb : NSObject <DICitySettingsManager>

+ (DICitySettingsRusSpb *)sharedInstance;
- (id)init __attribute__((unavailable("init is not available, use class methods 'sharedInstance' instead!")));
- (id)copy __attribute__((unavailable("copy is not available, use class methods 'sharedInstance' instead!")));

@end
