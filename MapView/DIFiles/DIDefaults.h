//
//  DIDefaults.h
//
//
//  Created by Dmitry Ivanov on 06.01.14.
//  Copyright (c) 2014 Dmitry Ivanov. All rights reserved.
//

#import "DIHelper.h"

#define SCREEN_SIZE                 [UIScreen mainScreen].bounds.size
#define SCREEN_RECT                 [UIScreen mainScreen].bounds

#if defined(DEBUG)
#   define DLog(...) NSLog(__VA_ARGS__)
#else
#   define DLog(...)
#endif

#define DILocalizedString(key) \
    [DIHelper localizedStringForKey:(key)]

#define NAVIBAR_DELTA               44.
#define NAVIBAR_FRAME               CGRectMake(0, 20, SCREEN_SIZE.width, NAVIBAR_DELTA);

typedef enum : NSUInteger {
    DICityID_rus_spb    = 1,
} DICityID;