# SFJFontDemo
动态下载字体，匹配字体

[参考链接](https://github.com/kishikawakatsumi/DownloadFont)

下载字体大都差不多，都是通过都是通过CTFontDescriptorMatchFontDescriptorsWithProgressHandler方法，通过block去传递各种状态。

本文是通过，代理的形式传递的。

`SFJFontDownLoader`结构

```Objective-c
- (void)fontDownloaderDidBegin:(SFJFontDownLoader *)downloader fontName:(NSString *)fontName;;
- (void)fontDownloaderDidFinish:(SFJFontDownLoader *)downloader fontName:(NSString *)fontName;
- (void)fontDownloader:(SFJFontDownLoader *)downloader didFailWithError:(NSError *)error fontName:(NSString *)fontName;
- (void)fontDownloader:(SFJFontDownLoader *)downloader progress:(CGFloat)progress fontName:(NSString *)fontName;
```
> 通过如上的4个方法去检测，字体的下载状态。

```Objective-c
- (void)downloadFontNamed:(NSString *)fontName;
- (void)registerDownloadedFontNamed:(NSString *)fontName;
```

> 需要注意的是 `registerDownloadedFontNamed:`方法，针对下载过的字体，我们通过这种方式去注册，然后就能正常使用了。
调用这个方法之后，如果有设置代理，那么会走代理方法中的`- (void)fontDownloaderDidFinish:(SFJFontDownLoader *)downloader fontName:(NSString *)fontName;`
方法

详细的用法请见demo。

<img src="http://on5ajnh9a.bkt.clouddn.com/1504253591.png" width="376" height="688" />
