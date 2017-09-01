//
//  SFJFontDownLoader.m
//  SFJFontDemo
//
//  Created by 沙缚柩 on 2017/8/18.
//  Copyright © 2017年 沙缚柩. All rights reserved.
//

#import "SFJFontDownLoader.h"
#import <CoreText/CoreText.h>

@implementation SFJFontDownLoader
// 1、我们先判断该字体是否已经被下载下来了，代码如下：
+ (BOOL)isFontDownloaded:(NSString *)fontName {
    UIFont* aFont = [UIFont fontWithName:fontName size:12.0];
    if (aFont && ([aFont.fontName compare:fontName] == NSOrderedSame
                  || [aFont.familyName compare:fontName] == NSOrderedSame)) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)downloadFontWithFontName:(NSString *)fontName
                        progress:(void (^)(double currentValue))progress
                         success:(void(^)())success
                         failure:(void(^)(NSError *error))failure{
//    // 用字体的 PostScript 名字创建一个 Dictionary
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:fontName, kCTFontNameAttribute, nil];
//    // 创建一个字体描述对象 CTFontDescriptorRef
//    CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attrs);
//    // 将字体描述对象放到一个 NSMutableArray 中
//    NSMutableArray *descs = [NSMutableArray arrayWithCapacity:0];
//    [descs addObject:(__bridge id)desc];
//    CFRelease(desc);
//
//    __block BOOL errorDuringDownload = NO;
//    CTFontDescriptorMatchFontDescriptorsWithProgressHandler( (__bridge CFArrayRef)descs, NULL,  ^(CTFontDescriptorMatchingState state, CFDictionaryRef progressParameter) {
//        
//        double progressValue = [[(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingPercentage] doubleValue];
//
//        if (state == kCTFontDescriptorMatchingDidBegin) {
//            NSLog(@" 字体已经匹配 ");
//        } else if (state == kCTFontDescriptorMatchingDidFinish) {
//            if (!errorDuringDownload) {
//                !success ? : success();
//                NSLog(@" 字体 %@ 下载完成 ", fontName);
//            }
//        } else if (state == kCTFontDescriptorMatchingWillBeginDownloading) {
//            NSLog(@" 字体开始下载 ");
//        } else if (state == kCTFontDescriptorMatchingDidFinishDownloading) {
//            NSLog(@" 字体下载完成 ");
//            dispatch_async( dispatch_get_main_queue(), ^ {
//                // 可以在这里修改 UI 控件的字体
//            });
//            
////            !success ? : success();
//        } else if (state == kCTFontDescriptorMatchingDownloading) {
//            !progress ? : progress(progressValue);
//            
//            NSLog(@" 下载进度 %.0f%% ", progressValue);
//        } else if (state == kCTFontDescriptorMatchingDidFailWithError) {
//            NSError *error = [(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingError];
//            NSString *errorMessage;
//            if (error != nil) {
//                
//                errorMessage = [error description];
//            } else {
//                errorMessage = @"ERROR MESSAGE IS NOT AVAILABLE!";
//            }
//            // 设置标志
//            errorDuringDownload = YES;
//            NSLog(@" 下载错误: %@", errorMessage);
//            
//            !failure ? : failure(error);
//        }
//        
//        return (BOOL)YES;
//    });
}


+ (void)asynchronouslySetFontName:(NSString *)fontName success:(void(^)())success{
    [self asynchronouslySetFontName:fontName downLoadProgress:^(double currentValue) {
    } success:^{
        dispatch_async( dispatch_get_main_queue(), ^ {
            !success ? : success();
        });
    } downLoadFailure:^(NSError *error) {
    }];
}

+ (void)asynchronouslySetFontName:(NSString *)fontName
                        downLoadProgress:(void (^)(double currentValue))progress
                         success:(void(^)())success
                          downLoadFailure:(void(^)(NSError *error))failure{
    if ([self isFontDownloaded:fontName]) {
        !success ? : success();
    }else{
        [self downloadFontWithFontName:fontName progress:^(double currentValue) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                !progress ? : progress((currentValue/100.0));
            });
        } success:^{
            dispatch_async( dispatch_get_main_queue(), ^ {
                !success ? : success();
            });
        } failure:^(NSError *error) {
            !failure ? : failure(error);
        }];
    }
}


#pragma mark -
#pragma mark - 

- (void)downloadFontNamed:(NSString *)fontName
{
    if (!fontName) {
        return;
    }
    
    NSDictionary *attributes = @{(id)kCTFontNameAttribute: fontName};
    
    CTFontDescriptorRef fontDescriptor = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attributes);
    NSArray *fontDescriptors = @[(__bridge id)fontDescriptor];
    CFRelease(fontDescriptor);
    
    __block BOOL errorDuringDownload = NO;
    
    CTFontDescriptorMatchFontDescriptorsWithProgressHandler((__bridge CFArrayRef)fontDescriptors, NULL, ^bool(CTFontDescriptorMatchingState state, CFDictionaryRef progressParameter) {
        NSDictionary *parameter = (__bridge NSDictionary *)progressParameter;
        double progressValue = [parameter[(id)kCTFontDescriptorMatchingPercentage] doubleValue];
        
        if (state == kCTFontDescriptorMatchingDidBegin) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                if ([self.delegate respondsToSelector:@selector(fontDownloaderDidBegin:fontName:)]) {
                    [self.delegate fontDownloaderDidBegin:self fontName:fontName];
                }
            });
        } else if (state == kCTFontDescriptorMatchingDidFinish) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                UIFont *font = [UIFont fontWithName:fontName size:1.0f];
                if (font) {
                    if ([self.delegate respondsToSelector:@selector(fontDownloaderDidFinish:fontName:)]) {
                        [self.delegate fontDownloaderDidFinish:self fontName:fontName];
                    }
                } else {
                    if ([self.delegate respondsToSelector:@selector(fontDownloader:didFailWithError:fontName:)]) {
                        [self.delegate fontDownloader:self didFailWithError:nil fontName:fontName];
                    }
                }
            });
        } else if (state == kCTFontDescriptorMatchingWillBeginDownloading) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                if ([self.delegate respondsToSelector:@selector(fontDownloader:progress:fontName:)]) {
                    [self.delegate fontDownloader:self progress:0.0f fontName:fontName];
                }
            });
        } else if (state == kCTFontDescriptorMatchingDownloading) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                if ([self.delegate respondsToSelector:@selector(fontDownloader:progress:fontName:)]) {
                    [self.delegate fontDownloader:self progress:progressValue / 100.0 fontName:fontName];
                }
            });
        } else if (state == kCTFontDescriptorMatchingDidFinishDownloading) {
            if ([self.delegate respondsToSelector:@selector(fontDownloader:progress:fontName:)]) {
                [self.delegate fontDownloader:self progress:1.0f fontName:fontName];
            }
        } else if (state == kCTFontDescriptorMatchingDidFailWithError) {
            
            if (!errorDuringDownload) {
                NSError *error = parameter[(id)kCTFontDescriptorMatchingError];
                errorDuringDownload = YES;
                
                dispatch_async( dispatch_get_main_queue(), ^ {
                    if ([self.delegate respondsToSelector:@selector(fontDownloader:didFailWithError:fontName:)]) {
                        [self.delegate fontDownloader:self didFailWithError:error fontName:fontName];
                    }
                });
            }
        }
        
        return (bool)YES;
    });
}


- (void)registerDownloadedFontNamed:(NSString *)fontName
{
    if (!fontName) {
        return;
    }
    
    NSDictionary *attributes = @{(id)kCTFontNameAttribute: fontName};
    
    CTFontDescriptorRef fontDescriptor = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attributes);
    NSArray *fontDescriptors = @[(__bridge id)fontDescriptor];
    CFRelease(fontDescriptor);
    
    CTFontDescriptorMatchFontDescriptorsWithProgressHandler((__bridge CFArrayRef)fontDescriptors, NULL, ^bool(CTFontDescriptorMatchingState state, CFDictionaryRef progressParameter) {
        if (state == kCTFontDescriptorMatchingDidFinish) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                UIFont *font = [UIFont fontWithName:fontName size:1.0f];
                if (font) {
                    NSLog(@"%@", @"kCTFontDescriptorMatchingDidFinish");
                    if ([self.delegate respondsToSelector:@selector(fontDownloaderDidFinish:fontName:)]) {
                        [self.delegate fontDownloaderDidFinish:self fontName:fontName];
                    }
                }
            });
        } else if (state == kCTFontDescriptorMatchingWillBeginDownloading) {
            NSLog(@"%@", @"kCTFontDescriptorMatchingWillBeginDownloading");
            return (bool)NO;
        }
        
        return (bool)YES;
    });
}


@end
