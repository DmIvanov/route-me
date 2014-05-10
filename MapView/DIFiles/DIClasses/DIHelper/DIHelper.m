 //
//  DIHelper.m
//  MapView
//
//  Created by Dmitry Ivanov on 19.01.14.
//
//

#import "DIHelper.h"
#import "RMTileImage.h"

//#define TILE_SIZE           256


@interface DIHelper()
{
    NSDictionary *_dbDescription;
}
@end


@implementation DIHelper

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

- (NSString *)pathForTilesFolder {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths.firstObject; // Get documents folder
    NSString *tilesFolderPath = [documentsDirectory stringByAppendingPathComponent:@"/Tiles"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:tilesFolderPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:tilesFolderPath withIntermediateDirectories:NO attributes:nil error:nil];
    
    return tilesFolderPath;
}

- (NSString *)pathForTile:(RMTile)tile {
    
    NSString *addition = [NSString stringWithFormat:@"/%@_%@_%@.png", @(tile.zoom), @(tile.x), @(tile.y)];
    NSString *path = [[self pathForTilesFolder] stringByAppendingPathComponent:addition];

    return path;
}

- (void)addImageToFolder:(NSData *)imageData forTile:(RMTile)tile {
 
    NSString *path = [self pathForTile:tile];
    [imageData writeToFile:path atomically:YES];
}

- (void)downloadTilesToDBFromFolder {
    
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self pathForTilesFolder] error:nil];
    for (int count = 0; count < (int)[directoryContent count]; count++)
    {
        NSString *fileName = directoryContent[count];
        NSString *filePath = [[self pathForTilesFolder] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", fileName]];
        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
        
        fileName = [fileName componentsSeparatedByString:@"."][0];
        RMTile tile = TileFromPath(fileName);
        RMTileImage *tileImage = [[RMTileImage alloc] initWithTile:tile];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:RMMapImageLoadedNotification
                                                            object:tileImage
                                                          userInfo:@{@"data" : imageData}];
    }
}

RMTile TileFromPath(NSString *path) {
    
    NSArray *components = [path componentsSeparatedByString:@"_"];
    if (components.count < 3)
        return RMTileDummy();
    
    RMTile tile;
    NSString *comp = components[0];
    tile.zoom = [comp integerValue];
    comp = components[1];
    tile.x = [comp integerValue];
    comp = components[2];
    tile.y = [comp integerValue];
    
    return tile;
}


- (BOOL)roundingCeil {
    
    return _mapRoundingCeil;
}

+ (NSInteger)randomValueBetween:(NSInteger)min and:(NSInteger)max {
    
    return (NSInteger)(min + arc4random_uniform(max - min + 1));
}

@end
