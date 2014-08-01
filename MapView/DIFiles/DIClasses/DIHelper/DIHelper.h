//
//  DIHelper.h
//  MapView
//
//  Created by Dmitry Ivanov on 19.01.14.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "RMTile.h"

@interface DIHelper : NSObject

@property (nonatomic) BOOL mapRoundingCeil; //scale rounding when zomming (if YES objects stay small without tile layer switching and the whole map looks sharper

+ (instancetype)sharedInstance;

- (void)addImageToFolder:(NSData *)imageData forTile:(RMTile)tile;
- (void)downloadTilesToDBFromFolder;

- (BOOL)roundingCeil;

+ (NSInteger)randomValueBetween:(NSInteger)min and:(NSInteger)max;
+ (NSArray *)propertiesForСlass:(Class)objClass;
+ (NSString *)localizedStringForKey:(NSString *)key;

@end
