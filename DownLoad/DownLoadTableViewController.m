//
//  DownLoadTableViewController.m
//  DownLoad
//
//  Created by JacksonMichael on 16/8/10.
//  Copyright © 2016年 JacksonMichael. All rights reserved.
//

#import "DownLoadTableViewController.h"
#import "MBHUDUntil.h"
#import "CommonUtil.h"
#import "PicListViewCell.h"

@interface DownLoadTableViewController ()<UITableViewDelegate,UITableViewDataSource,PicListCellDelegate>
{
    NSMutableArray * mydocArr;
    NSMutableArray * resultArray2;
    NSString *createPath;
}

@property (nonatomic,weak) IBOutlet UITableView * tableView;

@end

@implementation DownLoadTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"下载列表";
    
    //不留白
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"PicListViewCell" bundle:nil] forCellReuseIdentifier:@"picListCell"];
    [self dataInit];
    [self initBarItemBtn];
    [self createCollection];
}

//获取数据源
-(void)dataInit{
    
//    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    createPath = [NSString stringWithFormat:@"%@/Weworld", pathDocuments];
    
//    //取得目录下所有文件名
//    mydocArr = [[[[NSFileManager alloc] init] contentsOfDirectoryAtPath:createPath error:nil] mutableCopy];
//    
//    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
//    NSWidthInsensitiveSearch|NSForcedOrderingSearch;
//    NSComparator sort = ^(NSString *obj1,NSString *obj2){
//        NSRange range = NSMakeRange(0,obj1.length);
//        return [obj1 compare:obj2 options:comparisonOptions range:range];
//    };
//    resultArray2 = [[mydocArr sortedArrayUsingComparator:sort] mutableCopy];
    
    
    //根据文件创建时间排序
    NSArray *paths = [[[NSFileManager alloc] init] contentsOfDirectoryAtPath:createPath error:nil];//取得文件列表
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

//添加BarItembutton
- (void)initBarItemBtn{
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"全部删除" style:UIBarButtonItemStyleDone target:self action:@selector(deleteAllPic)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    //收藏
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"收藏" style:UIBarButtonItemStyleDone target:self action:@selector(goCollection)];
    
    self.navigationItem.leftBarButtonItem = leftBtn;
}

- (void)goCollection{
    [self performSegueWithIdentifier:@"goCollection" sender:nil];
}

-(void)createCollection{
    //创建文件夹
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *collectionPath = [NSString stringWithFormat:@"%@/Collection", pathDocuments];
    
    
    
    
    // 判断主文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:collectionPath]) {
        [fileManager createDirectoryAtPath:collectionPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}


//删除所有已下载栏目中图片
- (void)deleteAllPic{
    
    [CommonUtil confirmWithTitle:@"提示" message:@"清空已下载图片" buttonTitles:@[@"确认",@"取消"] completionBlock:^(NSUInteger buttonIndex) {
        if (buttonIndex == 0) {
            //    NSString *extension = @"m4r";
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            createPath = [NSString stringWithFormat:@"%@/Weworld", pathDocuments];
            
            NSArray *contents = [fileManager contentsOfDirectoryAtPath:createPath error:NULL];
            NSEnumerator *e = [contents objectEnumerator];
            NSString *filename;
            while ((filename = [e nextObject])) {
                
                [fileManager removeItemAtPath:[createPath stringByAppendingPathComponent:filename] error:NULL];
                
            }
            
            //清空临时数组
            [resultArray2 removeAllObjects];
            
            //提示
            [MBHUDUntil showHUDAddedTo:self.view OnlyText:@"全部删除成功"];
            [self.tableView reloadData];
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (resultArray2) {
        [self dataInit];
    }
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return resultArray2.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"mydoclistcell"];
//    cell.textLabel.text = resultArray2[indexPath.row];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    PicListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"picListCell"];
    
    cell.titleLabel.text = resultArray2[indexPath.row]; //标题
    //临时地址，用于计算文件夹大小
    NSString * tempPath = [createPath stringByAppendingPathComponent:resultArray2[indexPath.row]];
    //获取文件数量
    NSInteger filecount = [[[NSFileManager alloc] init] contentsOfDirectoryAtPath:tempPath error:nil].count;
    cell.imagesCount = (int)filecount;
    cell.attributeLabel.text = [NSString stringWithFormat:@"%ld 张 (%.2fMB)",(long)filecount,[self folderSizeAtPath:tempPath]];
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    editingStyle = UITableViewCellEditingStyleDelete;//此处的EditingStyle可等于任意UITableViewCellEditingStyle，该行代码只在iOS8.0以前版本有作用，也可以不实现。
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {//title可自已定义
        NSLog(@"点击删除");
        [CommonUtil confirmWithTitle:@"提示" message:@"删除图片" buttonTitles:@[@"确认",@"取消"] completionBlock:^(NSUInteger buttonIndex) {
            if (buttonIndex == 0) {
                NSFileManager *fileManager = [[NSFileManager alloc] init];
                NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                createPath = [NSString stringWithFormat:@"%@/Weworld", pathDocuments];
                
                //    NSArray * arr = [fileManager contentsOfDirectoryAtPath:createPath error:nil];
                
                
                
                
                NSString *filename = resultArray2[indexPath.row];
                
                [fileManager removeItemAtPath:[createPath stringByAppendingPathComponent:filename] error:NULL];
                
                [resultArray2 removeObjectAtIndex:indexPath.row];
                
                NSArray *contents1 = [fileManager contentsOfDirectoryAtPath:createPath error:NULL];
                NSLog(@"%@",contents1);
                [self.tableView reloadData];
                [MBHUDUntil showHUDAddedTo:self.view OnlyText:@"已删除"];
            }
        }];
        
        
    }];//此处是iOS8.0以后苹果最新推出的api，UITableViewRowAction，Style是划出的标签颜色等状态的定义，这里也可自行定义
    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"收藏" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        //移动到收藏中
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *collectionPath = [NSString stringWithFormat:@"%@/Collection", pathDocuments];
        NSString *thisPath = [NSString stringWithFormat:@"%@/Weworld", pathDocuments];
        NSString *filename = resultArray2[indexPath.row];
        
        
        [fileManager moveItemAtPath:[thisPath stringByAppendingPathComponent:filename] toPath:[collectionPath stringByAppendingPathComponent:filename] error:nil];
        
        [resultArray2 removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        [MBHUDUntil showHUDAddedTo:self.view OnlyText:@"已收藏"];
//        NSArray *contents1 = [fileManager contentsOfDirectoryAtPath:collectionPath error:NULL];
//        NSLog(@"%@",contents1);
    }];
    editRowAction.backgroundColor = [UIColor colorWithRed:0 green:124/255.0 blue:223/255.0 alpha:1];//可以定义RowAction的颜色
    return @[deleteRoWAction,editRowAction];//最后返回这俩个RowAction 的数组
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - PicListCellDelegate
//收藏按钮回调代理
- (void)tableViewCell:(PicListViewCell*)cell collectionButton:(UIButton*)button{
    
    NSIndexPath* indexpath = [self.tableView indexPathForCell:cell];
    
    //移动到收藏中
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *collectionPath = [NSString stringWithFormat:@"%@/Collection", pathDocuments];
    NSString *thisPath = [NSString stringWithFormat:@"%@/Weworld", pathDocuments];
    NSString *filename = resultArray2[indexpath.row];
    
    
    [fileManager moveItemAtPath:[thisPath stringByAppendingPathComponent:filename] toPath:[collectionPath stringByAppendingPathComponent:filename] error:nil];
    
    [resultArray2 removeObjectAtIndex:indexpath.row];
    [self.tableView reloadData];
    [MBHUDUntil showHUDAddedTo:self.view OnlyText:@"已收藏"];
}

//删除按钮回调代理
- (void)tableViewCell:(PicListViewCell*)cell deleteButton:(UIButton*)button{
    
    [CommonUtil confirmWithTitle:@"提示" message:@"删除图片" buttonTitles:@[@"确认",@"取消"] completionBlock:^(NSUInteger buttonIndex) {
        if (buttonIndex == 0) {
            NSIndexPath* indexpath = [self.tableView indexPathForCell:cell];
            
            NSFileManager *fileManager = [[NSFileManager alloc] init];
            NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            createPath = [NSString stringWithFormat:@"%@/Weworld", pathDocuments];
            
            
            NSString *filename = resultArray2[indexpath.row];
            
            [fileManager removeItemAtPath:[createPath stringByAppendingPathComponent:filename] error:NULL];
            
            [resultArray2 removeObjectAtIndex:indexpath.row];
            
            NSArray *contents1 = [fileManager contentsOfDirectoryAtPath:createPath error:NULL];
            NSLog(@"%@",contents1);
            [self.tableView reloadData];
            [MBHUDUntil showHUDAddedTo:self.view OnlyText:@"已删除"];
        }
    }];
    
}

//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PicListViewCell * cell = (PicListViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.imagesCount <= 0) {
        [MBHUDUntil showFailHUDAddedTo:self.view WithText:@"无内容"];
        return;
    }
    [self performSegueWithIdentifier:@"goSeePic" sender:resultArray2[indexPath.row]];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goSeePic"]) {
        NSString *docstr = (NSString *)sender;
        NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        createPath = [NSString stringWithFormat:@"%@/Weworld", pathDocuments];
        
        [segue.destinationViewController setValue:createPath forKey:@"mainPath"];
        [segue.destinationViewController setValue:docstr forKey:@"docPathStr"];
    }
    
}




@end
