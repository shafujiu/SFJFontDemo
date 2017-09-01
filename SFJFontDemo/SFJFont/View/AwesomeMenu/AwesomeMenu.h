//
//  AwesomeMenu.h
//  AwesomeMenu
//
//  Created by Levey on 11/30/11.
//  Copyright (c) 2011 Levey & Other Contributors. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwesomeMenuItem.h"

@protocol AwesomeMenuDelegate;

@interface AwesomeMenu : UIView <AwesomeMenuItemDelegate>

@property (nonatomic, copy) NSArray *menuItems;
@property (nonatomic, strong) AwesomeMenuItem *startButton;

@property (nonatomic, getter = isExpanded) BOOL expanded;
@property (nonatomic, weak) id<AwesomeMenuDelegate> delegate;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *highlightedImage;
@property (nonatomic, strong) UIImage *contentImage;
@property (nonatomic, strong) UIImage *highlightedContentImage;

@property (nonatomic, assign) CGFloat nearRadius;
// to adjust the bounce animation:
@property (nonatomic, assign) CGFloat endRadius;
@property (nonatomic, assign) CGFloat farRadius;
@property (nonatomic, assign) CGPoint startPoint;   // menu的中心点的位置
@property (nonatomic, assign) CGFloat timeOffset;   // to set the delay of every menu flying out animation:
@property (nonatomic, assign) CGFloat rotateAngle;  // 整体旋转的角度
@property (nonatomic, assign) CGFloat menuWholeAngle;  // 环绕的items的分布的角度
@property (nonatomic, assign) CGFloat expandRotation;
@property (nonatomic, assign) CGFloat closeRotation;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) BOOL    rotateAddButton;

- (id)initWithFrame:(CGRect)frame startItem:(AwesomeMenuItem*)startItem menuItems:(NSArray *)menuItems;

- (id)initWithFrame:(CGRect)frame startItem:(AwesomeMenuItem*)startItem optionMenus:(NSArray *)aMenusArray DEPRECATED_MSG_ATTRIBUTE("use -initWithFrame:startItem:menuItems: instead.");

- (AwesomeMenuItem *)menuItemAtIndex:(NSUInteger)index;

- (void)open;

- (void)close;

@end

@protocol AwesomeMenuDelegate <NSObject>
- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx;
@optional
- (void)awesomeMenuDidFinishAnimationClose:(AwesomeMenu *)menu;
- (void)awesomeMenuDidFinishAnimationOpen:(AwesomeMenu *)menu;
- (void)awesomeMenuWillAnimateOpen:(AwesomeMenu *)menu;
- (void)awesomeMenuWillAnimateClose:(AwesomeMenu *)menu;
@end
