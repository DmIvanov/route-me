//
//  RMDatabaseCache.m
//
// Copyright (c) 2008-2009, Route-Me Contributors
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#import "RMDatabaseCache.h"
#import "RMTileCacheDAO.h"
#import "RMTileImage.h"
#import "RMTile.h"

#import "DISettingsManager.h"
#import "DIHelper.h"

@implementation RMDatabaseCache

@synthesize databasePath;

+ (NSString*)dbPathForTileSource: (id<RMTileSource>) source usingCacheDir: (BOOL) useCacheDir
{
    if ([DISettingsManager offlineMode]) {
        NSString *path = [[DISettingsManager sharedInstance] dbPathForTileSource];
        return path;
    }
    else {
        NSArray *paths;
        
        if (useCacheDir) {
            paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        } else {
            paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        }
        
        if ([paths count] > 0) // Should only be one...
        {
            NSString *cachePath = [paths objectAtIndex:0];
            
            // check for existence of cache directory
            if ( ![[NSFileManager defaultManager] fileExistsAtPath: cachePath])
            {
                // create a new cache directory
                [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:NO attributes:nil error:nil];
            }
            
            /// \bug magic string literals
            NSString *filename = @"rus_spb_10_15.sqlite";
            //NSString *filename = [NSString stringWithFormat:@"Map%@.sqlite", [source uniqueTilecacheKey]];
            return [cachePath stringByAppendingPathComponent:filename];
        }
        return nil;
    }
}

-(id) initWithDatabase: (NSString*)path
{
	if (![super init])
		return nil;
	
	
	self.databasePath = path;
	dao = [[RMTileCacheDAO alloc] initWithDatabase:path];

	if (dao == nil)
		return nil;
    
    if ([DISettingsManager downloadingTilesFromFileSystem])
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addImageData:) name:RMMapImageLoadedNotification object:nil];
	
	return self;	
}

-(id) initWithTileSource: (id<RMTileSource>) source usingCacheDir: (BOOL) useCacheDir
{
	return [self initWithDatabase:[RMDatabaseCache dbPathForTileSource:source usingCacheDir: useCacheDir]];
}

-(void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[databasePath release];
	[dao release];
	
	[super dealloc];
}

-(void) setPurgeStrategy: (RMCachePurgeStrategy) theStrategy
{
	purgeStrategy = theStrategy;
}

-(void) setCapacity: (NSUInteger) theCapacity
{
	capacity = theCapacity;
}

-(void) setMinimalPurge: (NSUInteger) theMinimalPurge
{
	minimalPurge = theMinimalPurge;
}

-(void)addTile: (RMTile)tile WithImage: (RMTileImage*)image
{
	// The tile probably hasn't loaded any data yet... we must be patient.
	
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addImageData:) name:RMMapImageLoadedNotification object:image];
    
    static int tiles = 0;
    tiles++;
    RMLog(@"tiles : %d", tiles);
}

-(void) addImageData: (NSNotification *)notification
{
	NSData *data = [[notification userInfo] objectForKey:@"data"];
	/// \bug magic string literals
	RMTileImage *image = (RMTileImage*)[notification object];
	
	@synchronized (self) {

		if (capacity != 0 && [DISettingsManager cacheBaseCleaning]) {
			NSUInteger tilesInDb = [dao count];
			if (capacity <= tilesInDb) {
				[dao purgeTiles: MAX(minimalPurge, 1+tilesInDb-capacity)];
			}
		}
        
        if ([DISettingsManager uploadingTilesToFileSystem]) {
            [[DIHelper sharedInstance] addImageToFolder:data forTile:[image tile]];
        }
        else {
            NSDate *lastUsedTime = [[image lastUsedTime] retain];
            [self addImageData:data forTile:[image tile] lastUsed:lastUsedTime];
            [lastUsedTime release]; lastUsedTime = nil;
        }
	}
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:RMMapImageLoadedNotification
												  object:image];
	
	static double size = .0;
    size += (float)data.length/1024.0f/1024.0f;
	RMLog(@"%2lu items in DB (zoom = %2.d xTile = %5.d yTile = %5.d)", (unsigned long)[dao count], image.tile.zoom, image.tile.x, image.tile.y);
    RMLog(@"database size in MB: %.3f", size);
}

- (void)addImageData:(NSData *)imageData forTile:(RMTile)tile lastUsed:(NSDate *)lastUsedTime {
    
    [dao addData:imageData LastUsed:lastUsedTime ForTile:RMTileKey(tile)];
}

-(RMTileImage*) cachedImage:(RMTile)tile
{
//	RMLog(@"Looking for cached image in DB");

	NSData *data = nil;
	
	@synchronized (self) {
	
		data = [dao dataForTile:RMTileKey(tile)];
		if (data == nil)
			return nil;
	
		if (capacity != 0 && purgeStrategy == RMCachePurgeStrategyLRU) {
			[dao touchTile: RMTileKey(tile) withDate: [NSDate date]];
		}
		
	}
	
	RMTileImage *image = [RMTileImage imageForTile:tile withData:data];
//	RMLog(@"DB cache hit for tile %d %d %d", tile.x, tile.y, tile.zoom);
	return image;
}

-(void) purgeTilesFromBefore: (NSDate*) date
{
    @synchronized(self)
    {
        [dao purgeTilesFromBefore:date];
    }
}

-(void)didReceiveMemoryWarning
{
        @synchronized(self) 
        {
		[dao didReceiveMemoryWarning];
        }
}

-(void) removeAllCachedImages 
{
        @synchronized(self) 
        {
		[dao removeAllCachedImages];
        }
}

@end
