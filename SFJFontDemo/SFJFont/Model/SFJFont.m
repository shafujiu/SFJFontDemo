//
//  SFJFont.m
//  SFJFontDemo
//
//  Created by 沙缚柩 on 2017/8/26.
//  Copyright © 2017年 沙缚柩. All rights reserved.
//

#import "SFJFont.h"
#import "SFJFontDownLoader.h"

@implementation SFJFont

/**
 报隶-简 常规体         STBaoliSC-Regular
 华文楷体 常规体        STKaiti
 凌慧体-简 中黑体       MLingWaiMedium-SC
 
 翩翩体-简 常规体       HanziPenSC-W3
 娃娃体-简 常规体       DFWaWaSC-W5
 */

+ (instancetype)fontWithChineseName:(NSString *)chineseName fontName:(NSString *)fontName{
    SFJFont *font = [[self alloc] init];
    font.chineseName = chineseName;
    font.fontName = fontName;
    return font;
}

+ (NSArray *)loadFonts{
    NSString *fontsPath = [[NSBundle mainBundle] pathForResource:@"SFJFonts" ofType:@"plist"];
    NSArray *fontInfos = [NSArray arrayWithContentsOfFile:fontsPath];
    NSMutableArray *fonts = [NSMutableArray array];
    for (NSDictionary *dic in fontInfos) {
        SFJFont *font = [SFJFont fontWithChineseName:dic[@"chinesName"] fontName:dic[@"fontName"]];
        [fonts addObject:font];
    }
    return fonts;
}

+ (NSArray *)loadFontNames{
    NSString *fontsPath = [[NSBundle mainBundle] pathForResource:@"SFJFonts" ofType:@"plist"];
    NSArray *fontInfos = [NSArray arrayWithContentsOfFile:fontsPath];
    NSMutableArray *fontNames = [NSMutableArray array];
    for (NSDictionary *dic in fontInfos) {
        [fontNames addObject:dic[@"fontName"]];
    }
    return fontNames;
}

//- (BOOL)isSelectedItem{
//    NSString *selFontName = [[NSUserDefaults standardUserDefaults] objectForKey:SFJSelectedFontKey];
//    if ([selFontName isEqualToString:self.fontName]) {
//        return YES;
//    }else{
//        return NO;
//    }
//}

@end
