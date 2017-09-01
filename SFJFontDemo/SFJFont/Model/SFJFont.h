//
//  SFJFont.h
//  SFJFontDemo
//
//  Created by 沙缚柩 on 2017/8/26.
//  Copyright © 2017年 沙缚柩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFJFont : NSObject
/**
 报隶-简 常规体         STBaoliSC-Regular
 华文楷体 常规体        STKaiti
 凌慧体-简 中黑体       MLingWaiMedium-SC
 
 翩翩体-简 常规体       HanziPenSC-W3
 娃娃体-简 常规体       DFWaWaSC-W5
 */
@property (nonatomic, copy) NSString *chineseName;
@property (nonatomic, copy) NSString *fontName;

@property (nonatomic, copy) void(^cellOpration)(void);

// 判断是否是上次选中的
@property (nonatomic, assign) BOOL isSelectedItem;



+ (instancetype)fontWithChineseName:(NSString *)chineseName fontName:(NSString *)fontName;

+ (NSArray *)loadFonts;

+ (NSArray *)loadFontNames;

@end
