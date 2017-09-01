//
//  SFJFontCell.m
//  SFJFontDemo
//
//  Created by 沙缚柩 on 2017/8/18.
//  Copyright © 2017年 沙缚柩. All rights reserved.
//

#import "SFJFontCell.h"
#import "SFJFontDownLoader.h"
#import "FFCircularProgressView.h"

@interface SFJFontCell ()
@property (weak, nonatomic) IBOutlet UILabel *fontNameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *fontImgView;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImg;

@end

@implementation SFJFontCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnAct:)];
    [_progressView addGestureRecognizer:tap];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    // 1. 取消上一次的选中
//    self.selectedImg.hidden = !selected;
//    // 保存选中
//    if (selected) {
//        [[NSUserDefaults standardUserDefaults] setObject:_fontModel.fontName forKey:SFJSelectedFontKey];
//    }
}

- (void)setFrame:(CGRect)frame{
    frame.origin.y += 10;
    frame.size.height -= 10;
    [super setFrame:frame];
}

- (IBAction)btnAct:(id)sender {
    
}

- (void)setFontModel:(SFJFont *)fontModel{
    _fontModel = fontModel;
    _fontNameLbl.text = fontModel.chineseName;
    _fontImgView.image = [UIImage imageNamed:fontModel.fontName];
    
    _selectedImg.hidden = !fontModel.isSelectedItem;
    
    if ([self isAvailableFontNamed:fontModel.fontName]) {
        _progressView.hidden = YES;
        NSLog(@"fontname %@  YES ",fontModel.fontName);
    } else {
        NSLog(@"fontname %@  NO ",fontModel.fontName);
        _progressView.hidden = NO;
    }
}

- (void)setShowSelectedImg:(BOOL)showSelectedImg{
    _selectedImg.hidden = !showSelectedImg;
}

- (BOOL)isAvailableFontNamed:(NSString *)fontName
{
    UIFont *font = [UIFont fontWithName:fontName size:1.0f];
    return font && ([font.fontName compare:fontName] == NSOrderedSame || [font.familyName compare:fontName] == NSOrderedSame);
}


@end
