//
//  SFJFontViewController.m
//  SFJFontDemo
//
//  Created by 沙缚柩 on 2017/8/17.
//  Copyright © 2017年 沙缚柩. All rights reserved.
//

#import "SFJFontViewController.h"
#import "SFJFontCell.h"
#import "SFJFont.h"
#import "SFJFontDownLoader.h"
#import <CoreText/CoreText.h>
#import "FFCircularProgressView.h"
#import "AwesomeMenu.h"

@interface SFJFontViewController ()<SFJFontDownLoaderDelegate, AwesomeMenuDelegate>
{
    NSArray *fonts_;
    NSArray *fontNames_;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *previewLbl;

@property (nonatomic, strong) SFJFontDownLoader *downloader;
@property (nonatomic, strong) NSIndexPath *lastIndexPath;

@end

@implementation SFJFontViewController

- (instancetype)init{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:NSStringFromClass([self class]) bundle:nil];
    return [sb instantiateInitialViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_initDownLoader];
    
    [self p_creatData];
    [self p_setupTableView];
    
    [self p_setAwesomeMenuItem];
}

- (NSArray *)p_createMenuItems{
    NSMutableArray *mArr =[NSMutableArray array];
    for (SFJFont *font in fonts_) {
        AwesomeMenuItem *item = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_awesome_menuitem"] highlightedImage:nil ContentImage:[UIImage imageNamed:[NSString stringWithFormat:@"awesome_%@",font.fontName]] highlightedContentImage:nil];
        [mArr addObject:item];
    }
    return mArr;
}

- (void)p_setAwesomeMenuItem{
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    
    UIImage *starImage = [UIImage imageNamed:@"icon-star.png"];
    
    // Default Menu
    
//    AwesomeMenuItem *starMenuItem1 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
//                                                           highlightedImage:nil
////                                                               ContentImage:starImage
//                                                               ContentImage:[UIImage imageNamed:@"awesome_DFWaWaSC-W5"]
//                                                    highlightedContentImage:nil];
////    starMenuItem1.endPoint = CGPointMake(50, 100);
//    
//    AwesomeMenuItem *starMenuItem2 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
//                                                           highlightedImage:storyMenuItemImagePressed
//                                                               ContentImage:starImage
//                                                    highlightedContentImage:nil];
////    starMenuItem2.endPoint = CGPointMake(100, 100);
//    
//    AwesomeMenuItem *starMenuItem3 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
//                                                           highlightedImage:storyMenuItemImagePressed
//                                                               ContentImage:starImage
//                                                    highlightedContentImage:nil];
//    AwesomeMenuItem *starMenuItem4 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
//                                                           highlightedImage:storyMenuItemImagePressed
//                                                               ContentImage:starImage
//                                                    highlightedContentImage:nil];
//    AwesomeMenuItem *starMenuItem5 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
//                                                           highlightedImage:storyMenuItemImagePressed
//                                                               ContentImage:starImage
//                                                    highlightedContentImage:nil];
//    AwesomeMenuItem *starMenuItem6 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
//                                                           highlightedImage:storyMenuItemImagePressed
//                                                               ContentImage:starImage
//                                                    highlightedContentImage:nil];
//    AwesomeMenuItem *starMenuItem7 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
//                                                           highlightedImage:storyMenuItemImagePressed
//                                                               ContentImage:starImage
//                                                    highlightedContentImage:nil];
//    AwesomeMenuItem *starMenuItem8 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
//                                                           highlightedImage:storyMenuItemImagePressed
//                                                               ContentImage:starImage
//                                                    highlightedContentImage:nil];
//    AwesomeMenuItem *starMenuItem9 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
//                                                           highlightedImage:storyMenuItemImagePressed
//                                                               ContentImage:starImage
//                                                    highlightedContentImage:nil];
//    
//    NSArray *menuItems = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, starMenuItem5, starMenuItem6, starMenuItem7,starMenuItem8,starMenuItem9, nil];
    NSArray *menuItems = [self p_createMenuItems];
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg-addbutton.png"]
                                                       highlightedImage:[UIImage imageNamed:@"bg-addbutton-highlighted.png"]
                                                           ContentImage:[UIImage imageNamed:@"icon-plus.png"]
                                                highlightedContentImage:[UIImage imageNamed:@"icon-plus-highlighted.png"]];
    
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:self.view.bounds startItem:startItem menuItems:menuItems];
    menu.delegate = self;
    //    menu.rotateAddButton = NO;
    //    menu.expandRotation = M_PI * 2;
    //    menu.menuWholeAngle = M_PI * .5;
    menu.menuWholeAngle = M_PI * 2;
    //    menu.nearRadius = 100.0f;
    //    menu.farRadius = 300.0f;
    menu.startPoint = CGPointMake(200, 300);
    menu.endRadius = 80.0f;
    menu.rotateAngle = M_PI_4;
    [self.view addSubview:menu];
}

- (void)p_initDownLoader{
    self.downloader = [[SFJFontDownLoader alloc] init];
    self.downloader.delegate = self;
    
    NSDictionary *downloadedFonts = [[NSUserDefaults standardUserDefaults] valueForKey:SFJDownloadedFontsKey];
    for (NSString *downloadedFontName in downloadedFonts.allKeys) {
        [self.downloader registerDownloadedFontNamed:downloadedFontName];
    }
}

- (void)p_creatData{
    fonts_ = [SFJFont loadFonts];
    fontNames_ = [SFJFont loadFontNames];
}

- (void)p_setupTableView{
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SFJFontCell class]) bundle:nil] forCellReuseIdentifier:SFJFontCellID];
}



- (void)notifyFontChanged:(NSString *)fontName
{
    UIFont *font = [UIFont fontWithName:fontName size:18.0f];
    _previewLbl.font = font;
}

- (BOOL)isAvailableFontNamed:(NSString *)fontName
{
    UIFont *font = [UIFont fontWithName:fontName size:1.0f];
    return font && ([font.fontName compare:fontName] == NSOrderedSame || [font.familyName compare:fontName] == NSOrderedSame);
}

#pragma mark -
#pragma mark - tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return fonts_.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFJFontCell *cell = [tableView dequeueReusableCellWithIdentifier:SFJFontCellID forIndexPath:indexPath];
    SFJFont *font = fonts_[indexPath.row];
    
    cell.fontModel = font;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SFJFontCell *lastCell = [tableView cellForRowAtIndexPath:_lastIndexPath];
    lastCell.fontModel.isSelectedItem = NO;
    lastCell.showSelectedImg = NO;
    
    SFJFont *fontModel = fonts_[indexPath.row];
    NSString *fontName = fontModel.fontName;
    // 保存选中的font
//    [[NSUserDefaults standardUserDefaults] setObject:fontName forKey:SFJSelectedFontKey];
    
    SFJFontCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self isAvailableFontNamed:fontName]) {
        [self notifyFontChanged:fontName];
    } else {
        [self.downloader downloadFontNamed:fontName];
        [cell.progressView startSpinProgressBackgroundLayer];
    }
    
    cell.showSelectedImg = YES;
    cell.fontModel.isSelectedItem = YES;
    _lastIndexPath = indexPath;
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SFJFontCellHeight;
}

#pragma mark -
#pragma mark - <SFJFontDownLoaderDelegate>

- (void)fontDownloaderDidBegin:(SFJFontDownLoader *)downloader fontName:(NSString *)fontName
{
    NSLog(@"Begin download: %@", fontName);
}

- (void)fontDownloaderDidFinish:(SFJFontDownLoader *)downloader fontName:(NSString *)fontName
{
    NSLog(@"Finished download: %@", fontName);
    
    NSInteger index = [fontNames_ indexOfObject:fontName];
    SFJFontCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
    [cell.progressView stopSpinProgressBackgroundLayer];
    cell.progressView.hidden = YES;
    
    
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    if (indexPath) {
        NSString *selectedFontName = [fonts_[indexPath.row] fontName];
        [self notifyFontChanged:selectedFontName];
    }
    
    NSMutableDictionary *downloadedFonts = [[[NSUserDefaults standardUserDefaults] valueForKey:SFJDownloadedFontsKey] mutableCopy];
    if (!downloadedFonts) {
        downloadedFonts = [[NSMutableDictionary alloc] init];
    }
    
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)fontName, 0.0f, NULL);
    CFStringRef fontURL = CTFontCopyAttribute(fontRef, kCTFontURLAttribute);
    NSLog(@"Font URL: %@", (__bridge NSURL*)(fontURL));
    downloadedFonts[fontName] = ((__bridge NSURL *)fontURL).absoluteString;
    CFRelease(fontURL);
    CFRelease(fontRef);
    
    [[NSUserDefaults standardUserDefaults] setObject:downloadedFonts forKey:SFJDownloadedFontsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)fontDownloader:(SFJFontDownLoader *)downloader didFailWithError:(NSError *)error fontName:(NSString *)fontName
{
    NSLog(@"Failed download: %@", fontName);
    
    NSInteger index = [fontNames_ indexOfObject:fontName];
    SFJFontCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    cell.progressView.progress = 0.0f;
}

- (void)fontDownloader:(SFJFontDownLoader *)downloader progress:(CGFloat)progress fontName:(NSString *)fontName
{
    NSLog(@"Progress: %@ %f", fontName, progress);
    
    NSInteger index = [fontNames_ indexOfObject:fontName];
    SFJFontCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
    cell.progressView.progress = progress;
    
    if (progress > 0.0) {
        [cell.progressView stopSpinProgressBackgroundLayer];
    }
}

#pragma mark -
#pragma mark - <AwesomeMenuDelegate>

- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    
    NSString *fontName = [fonts_[idx] fontName];
    if ([self isAvailableFontNamed:fontName]) {
        [self notifyFontChanged:fontName];
    } else {
        [self.downloader downloadFontNamed:fontName];
    }
    NSLog(@"Select the index : %ld",idx);
    NSLog(@"select fontname %@",fontName);
}
- (void)awesomeMenuDidFinishAnimationClose:(AwesomeMenu *)menu {
    NSLog(@"Menu was closed!");
}
- (void)awesomeMenuDidFinishAnimationOpen:(AwesomeMenu *)menu {
    NSLog(@"Menu is open!");
}

@end
