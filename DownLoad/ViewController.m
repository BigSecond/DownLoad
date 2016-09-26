//
//  ViewController.m
//  DownLoad
//
//  Created by JacksonMichael on 16/8/9.
//  Copyright © 2016年 JacksonMichael. All rights reserved.
//



#import "ViewController.h"
#import "ListViewCell.h"
#import "JsonModel.h"
#import "PicDetailViewController.h"
#import "CommonUtil.h"
#import "MBHUDUntil.h"



@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,NSURLConnectionDelegate,myCellDelegate>
{
    //主页相关
    NSMutableArray *arraytmp;
    NSMutableArray * muarr;
    NSMutableArray * muarr2;
    
//    //详情页内容相关
//    NSMutableArray * darraytmp;
//    NSMutableArray * dmuarr;
//    NSMutableArray * dmuarr2;
    
    int pages;
    
    UIBarButtonItem * upbtn;
    
    //下载线程状态标识
    BOOL thread1;
    BOOL thread2;
    BOOL thread3;
    
    NSMutableArray * queueArray;
    
    
    dispatch_queue_t myQueue;
    dispatch_queue_t myQueue2;
    
    dispatch_group_t group;
    dispatch_group_t group2;
    
    //docment地址
    NSString *pathDocuments;
    
    //world地址
    NSString *createPath;
    //具体文件夹地址
    NSString *createDir;
    
}

@property (nonatomic,weak) IBOutlet UITableView * tableView;

@property (nonatomic,strong) UIWebView * webView;


/**
 -  存储data数据
 */
@property(nonatomic,strong)NSMutableData *dataM;
/**
 -  访问url链接
 */
@property(nonatomic,strong)NSURL *url;


@end





@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //不留白
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.webView.scalesPageToFit = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"ListViewCell" bundle:nil] forCellReuseIdentifier:@"mycell"];
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    [self initItemButton];
    pages = 1;
    [self webDataInit];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    //初始化队列数组
    queueArray = [[NSMutableArray alloc]init];
    
    //创建文件夹
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    createPath = [NSString stringWithFormat:@"%@/Weworld", pathDocuments];
    
    
    
    
    // 判断主文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
}


//初始化功能键
- (void)initItemButton{
    UIBarButtonItem * leftbtn = [[UIBarButtonItem alloc]initWithTitle:@"首页" style:UIBarButtonItemStyleDone target:self action:@selector(refresh)];
    self.navigationItem.leftBarButtonItem = leftbtn;
    
    upbtn = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(changUpPage)];
    UIBarButtonItem * downbtn = [[UIBarButtonItem alloc]initWithTitle:@"下页" style:UIBarButtonItemStyleDone target:self action:@selector(changeDownPage)];
    downbtn.tintColor = [UIColor blueColor];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:downbtn, upbtn, nil];
}

//刷新
-(void)refresh{
    UIAlertController * myalert = [UIAlertController alertControllerWithTitle:@"要去哪页？" message:@"输入你要去的页" preferredStyle:UIAlertControllerStyleAlert];
    
    [myalert addTextFieldWithConfigurationHandler:^(UITextField *textfield){
        textfield.keyboardType = UIKeyboardTypeNumberPad;
        textfield.textAlignment = NSTextAlignmentCenter;
    }];
    
    UIAlertAction * myaction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        pages = [[myalert.textFields[0] text] intValue];
        [self webDataInit];
    }];
    UIAlertAction * myaction2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
    }];
    UIAlertAction * myaction3 = [UIAlertAction actionWithTitle:@"首页" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        pages = 1;
        [self webDataInit];
    }];
    UIAlertAction * myaction4 = [UIAlertAction actionWithTitle:@"穿越" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        pages = arc4random() % 100;
        if (pages == 0) {
            pages =1;
        }
        [self webDataInit];
    }];
    
    [myalert addAction:myaction];
    [myalert addAction:myaction2];
    [myalert addAction:myaction3];
    [myalert addAction:myaction4];
    [self presentViewController:myalert animated:YES completion:nil];
    
}

//下一页
-(void)changeDownPage{
    pages ++;
    if (pages > 1) {
        upbtn.enabled = YES;
        upbtn.title = @"上页";
        upbtn.tintColor = [UIColor blueColor];
    }
    [self webDataInit];
}

//上一页
-(void)changUpPage{
    pages --;
    if (pages <= 1) {
        upbtn.enabled = NO;
        upbtn.title = @"无";
        upbtn.tintColor = [UIColor redColor];
    }
    [self webDataInit];
    
}

- (void)webDataInit{
    
    if (pages == 1) {
        self.title = @"首页";
    }else{
        self.title = [NSString stringWithFormat:@"第%d页",pages];
    }
    //清空之前内容
    if (muarr2 != nil) {
        [muarr2 removeAllObjects];
    }
    if (muarr != nil) {
        [muarr removeAllObjects];
    }
    if (arraytmp != nil) {
        [arraytmp removeAllObjects];
    }
    
    if (self.dataM != nil) {
        self.dataM = nil;
    }
    
    
    
    self.url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.zipaishe.com/page/%d/",pages]];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    //发送请求
    [NSURLConnection connectionWithRequest:request delegate:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.0001f;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (muarr2.count == 0 || muarr2 == nil) {
        return 0;
    }else{
        return muarr2.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    MainCellModel * model = muarr2[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCellValues:model];
    cell.delegate = self;
//    cell.backgroundColor = [UIColor redColor];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"PicDetailViewController" sender:muarr2[indexPath.row]];
    
    
    
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    NSString *lJs = @"document.documentElement.innerHTML";
//    NSString *lJs2 = @"document.title";
//    NSString *lHtml1 = [webView stringByEvaluatingJavaScriptFromString:lJs];
//    NSString *lHtml2 = [webView stringByEvaluatingJavaScriptFromString:lJs2];
//    
//    NSLog(@"HTML所有内容：%@",lHtml1);
//    
//    
//    NSLog(@"Title:%@",lHtml2);
//}


#pragma mark - NSURLSessionDataDelegate代理方法
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler
{
//    NSLog(@"challenge = %@",challenge.protectionSpace.serverTrust);
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
    
    NSString * html = @"";
    html = [[NSString alloc]initWithData:self.dataM encoding:NSUTF8StringEncoding];
    NSLog(@"长度有多少：%lu",(unsigned long)html.length);
//    NSLog(@"请求完毕 %@",html);
//    [self.webView loadHTMLString:html baseURL:self.url];
    
    [self onestr:html];
    
}

//拿到一级字符串
-(void)onestr:(NSString *)strTemp{
//    //匹配得到的下标
//    NSRange range = [strTemp rangeOfString:@"<div class=\"row\">"];
//    NSLog(@"rang:%@",NSStringFromRange(range));
//    strTemp = [strTemp substringWithRange:range];//截取范围类的字符串
//    NSLog(@"截取的值为：%@",strTemp);
    
//    NSString * tmpstr = @"<ul class=\"pager\">";
    
    arraytmp = [[strTemp componentsSeparatedByString:@"<div class=\"row\">"] mutableCopy]; //从字符A中分隔成2个元素的数组
//    NSLog(@"array:%@",array);
    NSString * urlindex = @"https://www.zipaishe.com/gallery/%E5%8E%9F%E5%88%9B%E8%AE%A4%E8%AF%81%E7%BE%8E%E7%9C%89%E5%95%A6%E5%95%A6%E9%98%9F%E9%95%BF%E5%8F%AF%E4%BB%A5%E8%BF%99%E5%BE%88%E9%98%9F%E9%95%BF%E4%BA%8C%E5%8D%81%E4%B8%80-%E5%85%A8%E5%A5%97%E5%9B%BE%E5%85%B190%E5%BC%A0%E5%85%8D%E8%B4%B929p/";
    muarr = [[NSMutableArray alloc]init];
    
    for (int i=0; i < arraytmp.count; i++) {
        NSRange range = [arraytmp[i] rangeOfString:@"<h2 class=\"entry-title visible-xs col-xs-12\" style=\"text-align: center\">"];
        if (range.length != 0) {
            [muarr addObject:arraytmp[i]];
        }
    }
    
//    NSLog(@"%@",muarr);
    
    [self twostr:muarr];
}

-(void)twostr:(NSMutableArray *)muarrtmp{
    //开始的位置
    NSString * tmpstr = @"class=\"col-lg-4 cover\" src=\"";
    //结束的位置
    NSString * tmpstrover = @"<p class=\"entry-meta\">";
    
    //图片结束的位置
    NSString * tmpimagestr = @"\" alt=";
    
    
    //标题开始的位置
    NSString * titstartstr = @"\" title=\"";
    //标题结束的位置
    NSString * titoverstr = @"<div class=\"col-lg-8\">";
    
    
    //链接开始的位置
    NSString * hrefstartstr = @"href=\"";
    //链接结束的位置
    NSString * hrefoverstr = @"</h2>";
    
    
    
    muarr2 = [[NSMutableArray alloc]init];
    
    for (int i=0; i < muarrtmp.count; i++) {
        NSRange range = [muarrtmp[i] rangeOfString:tmpstr];
        int startindex = range.location+range.length;
        
        NSRange rangeover = [muarrtmp[i] rangeOfString:tmpstrover];
        int overindex = rangeover.location;
        
        NSString * tmpstr1 = [muarrtmp[i] substringWithRange:NSMakeRange(startindex,overindex - startindex)];
//        NSLog(@"截取的字符串是：%@",tmpstr1);
        
        //图片截取
        NSRange imageover = [tmpstr1 rangeOfString:tmpimagestr];
        NSString * imgstr = [tmpstr1 substringWithRange:NSMakeRange(0, imageover.location)];
        NSLog(@"图片地址:%@",imgstr);
        MainCellModel * model = [[MainCellModel alloc]init];
        model.imgurl = imgstr;
        
        //标题截取
        NSRange titstartindex = [tmpstr1 rangeOfString:titstartstr];
        NSRange titoverindex = [tmpstr1 rangeOfString:titoverstr];
        NSString * titstr = [tmpstr1 substringWithRange:NSMakeRange(titstartindex.location+titstartindex.length, titoverindex.location - (titstartindex.location + titstartindex.length)-3)];
        NSLog(@"标题是：%@",titstr);
        model.title = titstr;
        
        
        //链接截取
        NSRange hrefrange = [tmpstr1 rangeOfString:hrefstartstr];
        NSRange hrefrange1 = [tmpstr1 rangeOfString:hrefoverstr];
        NSString * temphref = [tmpstr1 substringWithRange:NSMakeRange(hrefrange.location+hrefrange.length, hrefrange1.location - (hrefrange.location + hrefrange.length))];
        
        NSRange hrefrange2 = [temphref rangeOfString:@"\">"];
        NSString * hrefstr = [temphref substringWithRange:NSMakeRange(0, hrefrange2.location)];
        model.herf = [NSString stringWithFormat:@"https://www.zipaishe.com/%@",hrefstr];
        
        //加入到数组
        [muarr2 addObject:model];
    }
    
    self.title = [NSString stringWithFormat:@"第%d页(%lu)",pages,(unsigned long)muarr2.count];
    
//    NSLog(@"数组：%@",muarr2);
    [self.tableView reloadData];
}

- (NSMutableData *)dataM
{
    if (_dataM == nil)
    {
        _dataM = [[NSMutableData alloc]init];
    }
    
    return _dataM;
}

//按钮回调代理
- (void)tableViewCell:(ListViewCell*)cell tapeddButton:(UIButton*)button{
    NSLog(@"进入按钮点击代理");
    
//    if (thread1) {
//        //提示
//        [MBHUDUntil showHUDAddedTo:self.view OnlyText:@""];
//    }
    
    createDir = [NSString stringWithFormat:@"%@/Weworld/%@", pathDocuments,cell.labelTitle.text];
    // 判断具体项目文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:createDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:createDir withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        [MBHUDUntil showHUDAddedTo:self.view OnlyText:@"已下载，跳过下载"];
        NSLog(@"文件夹已有，跳过下载");
        return;
    }
    
    //提示
    [MBHUDUntil showHUDAddedTo:self.view OnlyText:@"开始下载"];
    
    
    
    
    NSIndexPath* indexpath = [self.tableView indexPathForCell:cell];
    
    MainCellModel * model = muarr2[indexpath.row];
    NSURL *urlstr = [NSURL URLWithString:model.herf];
    NSData *datatemp = [NSData dataWithContentsOfURL:urlstr];
    NSString * htmlstr = @"";
    htmlstr = [[NSString alloc]initWithData:datatemp encoding:NSUTF8StringEncoding];
//    NSLog(@"详情页的内容:%@",htmlstr);
    
//    //先清空数据
//    if (darraytmp) {
//        [darraytmp removeAllObjects];
//    }
//    if (dmuarr) {
//        [dmuarr removeAllObjects];
//    }
//    if (dmuarr2) {
//        [dmuarr2 removeAllObjects];
//    }
    
    
    NSMutableArray * darraytmp = [[htmlstr componentsSeparatedByString:@"<figure>"] mutableCopy]; //从字符A中分隔成2
    
    NSMutableArray * dmuarr = [[NSMutableArray alloc]init];
    if (datatemp != nil) {
        
        for (int i=0; i < darraytmp.count; i++) {
            NSRange range = [darraytmp[i] rangeOfString:@"<figcaption class=\"gallery-caption \">"];
            if (range.length != 0) {
                [dmuarr addObject:darraytmp[i]];
            }
        }
    }
    
    //开始截取图片url;
    [self getDetailimgurls:model andarr:dmuarr];
    
}

-(void)getDetailimgurls:(MainCellModel *)mainmodel andarr:(NSMutableArray *)tempsarr{
    NSString * dtempstart = @"<img class=\"gallery-img\" src=\"";
    
    NSString * dtempover = @"\" alt=\"\" title=";
    
    NSMutableArray * dmuarr2 = [[NSMutableArray alloc]init];
    //先加一个第一张图(他第一张图的规格不一样)
//    [dmuarr2 addObject:mainmodel.imgurl];
    for (int i=0; i < tempsarr.count; i++) {
        
        //地址截取
        NSRange titstartindex = [tempsarr[i] rangeOfString:dtempstart];
        NSRange titoverindex = [tempsarr[i] rangeOfString:dtempover];
        NSString * titstr = [tempsarr[i] substringWithRange:NSMakeRange(titstartindex.location+titstartindex.length, titoverindex.location - (titstartindex.location + titstartindex.length))];
//        NSLog(@"Url是：%@",titstr);
        [dmuarr2 addObject:titstr];
        
    }
    
    DownLoadModel * model = [[DownLoadModel alloc]init];
    model.urlArray = [dmuarr2 copy];
    model.titleName = [mainmodel.title copy];
    
    //查看队列数组里是否有任务在进行或者在排队，没有则马上开始下载，有则加入队列等待下载
    if (queueArray.count == 0) {
        [queueArray addObject:model];
        [self DownLoadPicsIng];
    }else{
        [queueArray addObject:model];
        [MBHUDUntil showHUDAddedTo:self.view OnlyText:@"任务正在下载，已加入队列"];
    }
    
    
//    //准备开始异步下载图片
//    [self downLoadImages:dmuarr2 andtitle:mainmodel];
}


//方法暂时废弃
-(void)downLoadImages:(NSMutableArray *)tmparrurls andtitle:(MainCellModel *)mainmodels{
    

    
//    //获取文件数量
//    NSInteger filecount = [[[NSFileManager alloc] init] contentsOfDirectoryAtPath:createPath error:nil].count;
    
    
    
    if (!myQueue) {
        myQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    }
    

    
    
    
    
    NSLog(@"Queue1 : %@ ----Queue2  :%@",myQueue);
//    NSLog(@"1.当前线程：%@", [NSThread currentThread]);
    if (!thread1) {
        // 1号线程异步下载
        dispatch_async(myQueue, ^{
            thread1 = true; //线程被占用
            NSLog(@"<%@>下载总量：%lu",mainmodels.title,(unsigned long)tmparrurls.count);
//            NSLog(@"2.当前线程：%@", [NSThread currentThread]);
            for (int i=0; i < tmparrurls.count ; i++) {
                // 1.下载第1张
                NSURL *url1 = [NSURL URLWithString:tmparrurls[i]];
                NSData *data1 = [NSData dataWithContentsOfURL:url1];
                UIImage *image1 = [UIImage imageWithData:data1];
                NSLog(@"%d --- 《%@》,下载完成  1号线程%@",i +1,mainmodels.title,image1);
                
                //保存图片到Document
                [self saveImage:image1 withFileName:[NSString stringWithFormat:@"%@0%d",mainmodels.title,i+1] ofType:@"jpg" inDirectory:createDir];
                
            }
            
            
            //取得目录下所有文件名
            //        NSArray *file = [[[NSFileManager alloc] init] subpathsAtPath:createPath];
            //NSLog(@"%d",[file count]);
            //        NSLog(@"myworld文件夹下所有文件：%@",file);
            
            
            
            //取得目录下所有文件名
            //        NSArray *file1 = [[[NSFileManager alloc] init] contentsOfDirectoryAtPath:createPath error:nil];
            //NSLog(@"%d",[file count]);
            //        NSLog(@"myworld文件夹下所有文件：%@",file1);
            
            
            

//            [CommonUtil alertWithMessage:@"下载完成" andContent:mainmodels.title withCompletionHandler:nil];
            
            
            thread1 = false;    //线程可用
            //回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                //此处准备写个下载完成弹框
                
                [CommonUtil confirmWithTitle:@"下载完成" message:mainmodels.title buttonTitles:@[@"确认"] completionBlock:^(NSUInteger buttonIndex) {
                    //不作为就行
                }];
            });
        });
        
        

    }else if (!thread2){
        
        dispatch_suspend(myQueue2);
        // 2号线程异步下载
        dispatch_async(myQueue2, ^{
            thread2 = true; //线程被占用
            NSLog(@"<%@>下载总量：%lu",mainmodels.title,(unsigned long)tmparrurls.count);
//            NSLog(@"3.当前线程：%@", [NSThread currentThread]);
            for (int i=0; i < tmparrurls.count ; i++) {
                // 1.下载第1张
                NSURL *url1 = [NSURL URLWithString:tmparrurls[i]];
                NSData *data1 = [NSData dataWithContentsOfURL:url1];
                UIImage *image1 = [UIImage imageWithData:data1];
                NSLog(@"%d --- 《%@》,下载完成%@   2号线程",i +1,mainmodels.title,image1);
                
                //保存图片到Document
                [self saveImage:image1 withFileName:[NSString stringWithFormat:@"%@0%d",mainmodels.title,i+1] ofType:@"jpg" inDirectory:createDir];
                
            }
            
            
            //取得目录下所有文件名
            //        NSArray *file = [[[NSFileManager alloc] init] subpathsAtPath:createPath];
            //NSLog(@"%d",[file count]);
            //        NSLog(@"myworld文件夹下所有文件：%@",file);
            
            
            
            //取得目录下所有文件名
            //        NSArray *file1 = [[[NSFileManager alloc] init] contentsOfDirectoryAtPath:createPath error:nil];
            //NSLog(@"%d",[file count]);
            //        NSLog(@"myworld文件夹下所有文件：%@",file1);
            
            
            //此处准备写个下载完成弹框
            
            //弹出提示框；
            
            
            thread2 = false;    //线程可用
            //回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        });
    }else{
        
        //弹出提示框；
        [CommonUtil alertWithMessage:@"提示" andContent:@"抱歉最多同时下载2个" withCompletionHandler:nil];
    }
    
}

-(void)DownLoadPicsIng{
    
    //拿队列中的第一个模型
    DownLoadModel * down = (DownLoadModel *)queueArray[0];
    NSMutableArray * tempArray = down.urlArray;
    
    
    if (!myQueue) {
        myQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    }
    
    dispatch_async(myQueue, ^{
        thread1 = true; //线程被占用
        NSLog(@"<%@>下载总量：%lu",down.titleName,(unsigned long)tempArray.count);
        //            NSLog(@"2.当前线程：%@", [NSThread currentThread]);
        for (int i=0; i < tempArray.count ; i++) {
            // 1.下载第1张
            NSURL *url1 = [NSURL URLWithString:tempArray[i]];
            NSData *data1 = [NSData dataWithContentsOfURL:url1];
            UIImage *image1 = [UIImage imageWithData:data1];
            NSLog(@"%d --- 《%@》,下载完成  1号线程%@",i +1,down.titleName,image1);
            
            //保存图片到Document
            //NSLog(@"图片呗保存到:<%@>",down.titleName);
            [self saveImage:image1 withFileName:[NSString stringWithFormat:@"%@0%d",down.titleName,i+1] ofType:@"jpg" inDirectory:[NSString stringWithFormat:@"%@/%@", createPath,down.titleName]];
            
        }
        
        
        
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            //此处准备写个下载完成弹框
            thread1 = false;    //线程可用
            [CommonUtil confirmWithTitle:@"下载完成" message:down.titleName buttonTitles:@[@"确认"] completionBlock:^(NSUInteger buttonIndex) {
                //不作为就行
            }];
            
            //下载完成后清空掉第一个队列
            [queueArray removeObjectAtIndex:0];
            
            if (queueArray.count > 0) {
                [self DownLoadPicsIng];
            }else{
                NSLog(@"暂无任务");
            }
            
        });
    });
}

//图片保存文件夹
-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        //ALog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
        NSLog(@"文件后缀不认识");
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"PicDetailViewController"]) {
        MainCellModel *newsModel = (MainCellModel *)sender;
        [segue.destinationViewController setValue:newsModel.title forKey:@"titlestr"];
        [segue.destinationViewController setValue:newsModel.herf forKey:@"urlString"];
    }
}


@end
