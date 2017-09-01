//
//  SFJFontCell.h
//  SFJFontDemo
//
//  Created by 沙缚柩 on 2017/8/18.
//  Copyright © 2017年 沙缚柩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFJFont.h"
@class FFCircularProgressView;

static NSString *const SFJFontCellID = @"SFJFontCellID";
static CGFloat const SFJFontCellHeight = 90;

@interface SFJFontCell : UITableViewCell

@property (nonatomic, strong) SFJFont *fontModel;

@property (weak, nonatomic) IBOutlet FFCircularProgressView *progressView;
@property (nonatomic, copy) void(^setFontSuccess)(NSString *fontName);

@property (nonatomic, assign) BOOL showSelectedImg;


@end
