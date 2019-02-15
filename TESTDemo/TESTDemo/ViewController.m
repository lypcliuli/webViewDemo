//
//  ViewController.m
//  TESTDemo
//
//  Created by LiuLi on 2019/2/15.
//  Copyright © 2019年 LYPC. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController ()

@property (nonatomic,strong) WKWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //WKWebview 禁止长按(超链接、图片、文本...)弹出效果
    [self.webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
    [self.webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';"completionHandler:nil];
    
    NSURL *url = [NSURL URLWithString:@"http://www.mingyizhi.cn/test/mingyizhishare/caseDetails.html?caseId=72df6b2036b740b985e478946002fecc"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    // Do any additional setup after loading the view, typically from a nib.
}

- (WKWebView *)webView {
    if (!_webView) {
        //禁止长按弹出 UIMenuController
        NSString*css = @"body{-webkit-user-select:none;-webkit-user-drag:none;}";
        NSMutableString*javascript = [NSMutableString string];
        [javascript appendString:@"var style = document.createElement('style');"];
        [javascript appendString:@"style.type = 'text/css';"];
        [javascript appendFormat:@"var cssContent = document.createTextNode('%@');", css];
        [javascript appendString:@"style.appendChild(cssContent);"];
        [javascript appendString:@"document.body.appendChild(style);"];
        [javascript appendString:@"document.documentElement.style.webkitUserSelect='none';"];
        [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];
        // javascript注入
        WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript
                                          
                                                                injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                                          
                                                             forMainFrameOnly:YES];
        
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        [userContentController addUserScript:noneSelectScript];
        
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = userContentController;
        
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        
        [_webView.configuration.userContentController addUserScript:noneSelectScript];
        
        _webView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_webView];
    }
    return _webView;
}

@end
