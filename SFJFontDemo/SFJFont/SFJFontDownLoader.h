//
//  SFJFontDownLoader.h
//  SFJFontDemo
//
//  Created by 沙缚柩 on 2017/8/18.
//  Copyright © 2017年 沙缚柩. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SFJFontDownLoader;

static NSString *const SFJDownloadedFontsKey = @"SFJDownloadedFontsKey";
//static NSString *const SFJSelectedFontKey = @"SFJSelectedFontKey";

@protocol SFJFontDownLoaderDelegate <NSObject>

- (void)fontDownloaderDidBegin:(SFJFontDownLoader *)downloader fontName:(NSString *)fontName;;
- (void)fontDownloaderDidFinish:(SFJFontDownLoader *)downloader fontName:(NSString *)fontName;
- (void)fontDownloader:(SFJFontDownLoader *)downloader didFailWithError:(NSError *)error fontName:(NSString *)fontName;
- (void)fontDownloader:(SFJFontDownLoader *)downloader progress:(CGFloat)progress fontName:(NSString *)fontName;

@end

@interface SFJFontDownLoader : NSObject

@property (nonatomic, weak) id<SFJFontDownLoaderDelegate> delegate;

- (void)downloadFontNamed:(NSString *)fontName;
- (void)registerDownloadedFontNamed:(NSString *)fontName;


@end
