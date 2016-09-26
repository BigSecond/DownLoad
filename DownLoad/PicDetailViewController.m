//
//  PicDetailViewController.m
//  DownLoad
//
//  Created by JacksonMichael on 16/8/9.
//  Copyright © 2016年 JacksonMichael. All rights reserved.
//

#import "PicDetailViewController.h"

@interface PicDetailViewController ()<UIWebViewDelegate,NSURLConnectionDelegate>

@property (nonatomic,weak) IBOutlet UIWebView * webView;


/**
 -  存储data数据
 */
@property(nonatomic,strong)NSMutableData *dataM;
/**
 -  访问url链接
 */
@property(nonatomic,strong)NSURL *url;

@end

@implementation PicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView.delegate = self;
    //不留白
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = self.titlestr;
    self.url = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    //发送请求
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSURLSessionDataDelegate代理方法
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler
{
    NSLog(@"challenge = %@",challenge.protectionSpace.serverTrust);
    //判断是否是信任服务器证书
    if (challenge.protectionSpace.authenticationMethod ==NSURLAuthenticationMethodServerTrust)
    {
        //创建一个凭据对象
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        //告诉服务器客户端信任证书
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
        
    }
}

/**
 *  接收到服务器返回的数据时调用
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //    NSLog(@"接收到的数据%zd",data.length);
    [self.dataM appendData:data];
}
/**
 *  请求完毕
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *html = [[NSString alloc]initWithData:self.dataM encoding:NSUTF8StringEncoding];
    
    //    NSLog(@"请求完毕 %@",html);
    [self.webView loadHTMLString:html baseURL:self.url];
    
    
    
}

- (NSMutableData *)dataM
{
    if (_dataM == nil)
    {
        _dataM = [[NSMutableData alloc]init];
    }
    return _dataM;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
