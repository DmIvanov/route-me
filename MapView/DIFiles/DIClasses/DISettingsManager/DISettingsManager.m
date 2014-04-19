//
//  DISettingsManager.m
//  
//
//  Created by Dmitry Ivanov on 19.04.14.
//
//

#import "DISettingsManager.h"

#import "DICitySettingsRusSpb.h"

@interface DISettingsManager()
{

}
@property (nonatomic, strong) id<DICitySettingsManager> currentCityManager;

@end

@implementation DISettingsManager

@synthesize currentCity = _currentCity;

+ (DISettingsManager *)sharedInstance {
    
    static DISettingsManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DISettingsManager alloc] initSingletone];
    });
    return sharedInstance;
}

- (id)initSingletone {
    
    self = [super init];
    if (self) {
        //while we have only one city
        self.currentCity = DICityID_rus_spb;
    }
    return self;
}


#pragma mark - Offline Mode
+ (BOOL)offlineMode {
    return YES; //tiles only from cache database
    //    return NO;  //tiles downloading from server is available
}
+ (BOOL)deceleration {
    return NO;  //map deceleration turned off
    //    return YES;  //map deceleration turned on
}
+ (BOOL)uploadingTilesToFileSystem {
    //    return YES; //writing tiles to file system in Documets folder
    return NO;  //writiting to cache database
}
+(BOOL)downloadingTilesFromFileSystem {
    //    return YES; //reading tiles from Documets folder
    return NO;  //reading from remote source
}
+ (BOOL)cacheBaseCleaning {
    return NO;  //no limits
    //    return YES; //deleting tiles from cache database (capacity <= tilesInDb)
}


#pragma mark - Setters & getters

- (DICityID)currentCity {
    
    return _currentCity;    //right now just SPb
}

- (void)setCurrentCity:(DICityID)currentCity {
    
    if (_currentCity != currentCity) {
        _currentCity = currentCity;
        [self initCityManagerForCityId:currentCity];
    }
}


#pragma mark - CurrentCityManager responsibility

- (NSString *)dbPathForTileSource {
    
    if (!_currentCityManager)
        return nil;
    
    return [_currentCityManager dbPathForTileSource];
}

- (double)maxZoom {
    
    if (!_currentCityManager)
        return 0.;
    
    return [_currentCityManager maxZoom];
}

- (double)minZoom {
    
    if (!_currentCityManager)
        return 0.;
    
    return [_currentCityManager minZoom];
}

- (double)initialZoom {
    
    if (!_currentCityManager)
        return 0.;
    
    return [_currentCityManager initialZoom];
}


- (double)initialLatitude {
    
    if (!_currentCityManager)
        return 0.;
    
    return [_currentCityManager initialLatitude];
}

- (double)initialLongitude {
    
    if (!_currentCityManager)
        return 0.;
    
    return [_currentCityManager initialLongitude];
}


- (CLLocationCoordinate2D)SWBorderPoint {
    
    if (!_currentCityManager)
        return CLLocationCoordinate2DMake(0., 0.);
    
    return [_currentCityManager SWBorderPoint];
}

- (CLLocationCoordinate2D)NEBorderPoint {
    
    if (!_currentCityManager)
        return CLLocationCoordinate2DMake(0., 0.);
    
    return [_currentCityManager NEBorderPoint];
}


#pragma mark - Other methods

- (void)initCityManagerForCityId:(DICityID)cityId {
    
    Class<DICitySettingsManager> managerClass;
    switch (cityId) {
        case DICityID_rus_spb:
            managerClass = [DICitySettingsRusSpb class];
            break;
            
        default:
            break;
    }
    
    _currentCityManager = [managerClass sharedInstance];
}

@end
