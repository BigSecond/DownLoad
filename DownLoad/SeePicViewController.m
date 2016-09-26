//
//  SeePicViewController.m
//  DownLoad
//
//  Created by JacksonMichael on 16/8/10.
//  Copyright © 2016年 JacksonMichael. All rights reserved.
//

#import "SeePicViewController.h"
#import "PicDetailViewCell.h"
#import "SeeImageObj.h"
#import "SeeImagesView.h"

@interface SeePicViewController ()<UITableViewDelegate,UITableViewDataSource>
{
//    NSMutableArray * mypicArr;
    NSString *createPath;
    NSMutableArray *resultArray2;
    
    UIBarButtonItem * items;
    SeeImagesView * Img;
}
@property (nonatomic,weak) IBOutlet UITableView * tableView;

@end

@implementation SeePicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.docPathStr;
    //不留白
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"PicDetailViewCell" bundle:nil] forCellReuseIdentifier:@"detailcell"];
    [self dataInit];
    [self initBarItemBtn];
    [self initImages];
}

- (void)initImages{
    
    NSMutableArray * temparr1 = [[NSMutableArray alloc]init];
    for (int i = 0; i < resultArray2.count; i++) {
        UIImage * tempaimg = [self loadImage:resultArray2[i] ofType:@"jpg" inDirectory:createPath];
        [temparr1 addObject:tempaimg];
    }
    
    NSMutableArray * temparr = [[NSMutableArray alloc]init];
    for (int i = 0; i < temparr1.count; i++) {
        SeeImageObj *z = [[SeeImageObj alloc]init];
        UIImage * img = (UIImage *)temparr1[i];
        
        z.imgdata = img;
        //大渺的完美算法
        float beishu = img.size.width / img.size.height;
        z.whidth = [NSString stringWithFormat:@"%f", [[UIScreen mainScreen] bounds].size.width];
        z.height = [NSString stringWithFormat:@"%f", img.size.height - ((img.size.width - [[UIScreen mainScreen] bounds].size.width) / beishu)];
        z.imgTitle = @"";
        z.imgContent = self.docPathStr;
        
        [temparr addObject:z];
    }
    
    Img = [[SeeImagesView alloc]initWithFrame:CGRectMake(0, 10, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    //    SeeImagesView * Img = [[SeeImagesView alloc]initWithFrame:CGRectMake(0, 10, 320, 400)];
    [Img setObj:temparr[0] ImageArray:temparr andBtn:items];
    Img.isOpen = YES;
    [self.view addSubview:Img];
    Img.hidden = YES;
    
    
}

- (void)initBarItemBtn{
    items = [[UIBarButtonItem alloc]initWithTitle:@"细细品尝" style:UIBarButtonItemStyleDone target:self action:@selector(goTaste)];
    self.navigationItem.rightBarButtonItem = items;
}

- (void)goTaste{
    
    
    [Img gostart];
    
    
//    [self performSegueWithIdentifier:@"goTaste" sender:temparr];
}

- (void)dataInit{
    
    
    createPath = [NSString stringWithFormat:@"%@/%@", self.mainPath,self.docPathStr];
    
//    //取得目录下所有文件名
//    mypicArr = [[[[NSFileManager alloc] init] subpathsAtPath:createPath] mutableCopy];
    
    
//    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
//    NSWidthInsensitiveSearch|NSForcedOrderingSearch;
//    NSComparator sort = ^(NSString *obj1,NSString *obj2){
//        NSRange range = NSMakeRange(0,obj1.length);
//        return [obj1 compare:obj2 options:comparisonOptions range:range];
//    };
//    resultArray2 = [[mypicArr sortedArrayUsingComparator:sort] mutableCopy];
//    NSLog(@"字符串数组排序结果%@",resultArray2);
    
    //根据文件创建时间排序
    NSArray *paths = [[[NSFileManager alloc] init] subpathsAtPath:createPath];//取得文件列表
    resultArray2 = [[paths sortedArrayUsingComparator:^(NSString * firstPath, NSString* secondPath) {//
        NSString *firstUrl = [createPath stringByAppendingPathComponent:firstPath];//获取前一个文件完整路径
        NSString *secondUrl = [createPath stringByAppendingPathComponent:secondPath];//获取后一个文件完整路径
        NSDictionary *firstFileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:firstUrl error:nil];//获取前一个文件信息
        NSDictionary *secondFileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:secondUrl error:nil];//获取后一个文件信息
        id firstData = [firstFileInfo objectForKey:NSFileModificationDate];//获取前一个文件修改时间
        id secondData = [secondFileInfo objectForKey:NSFileModificationDate];//获取后一个文件修改时间
        
        return [firstData compare:secondData];//升序
        // return [secondData compare:firstData];//降序
    }] mutableCopy];
    
    
    [self.tableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300.f;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return resultArray2.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PicDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailcell"];
    
    [cell setCellValues:createPath andPicName:resultArray2[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//根据图片地址返回Image
- (UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"goTaste"]) {
        NSMutableArray * temparr = (NSMutableArray *)sender;
        [segue.destinationViewController setValue:temparr forKey:@"imagesArr"];
        [segue.destinationViewController setValue:self.docPathStr forKey:@"titleName"];
    }
}



@end
