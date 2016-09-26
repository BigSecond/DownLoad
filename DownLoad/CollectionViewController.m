//
//  CollectionViewController.m
//  DownLoad
//
//  Created by JacksonMichael on 16/8/13.
//  Copyright © 2016年 JacksonMichael. All rights reserved.
//

#import "CollectionViewController.h"
#import "MBHUDUntil.h"
#import "PicListViewCell.h"
#import "CommonUtil.h"

@interface CollectionViewController ()<UITableViewDelegate,UITableViewDataSource,PicListCellDelegate>
{
    NSMutableArray * resultArray2;
    NSString *createPath;
}

@property (nonatomic,weak) IBOutlet UITableView * tableView;
@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"PicListViewCell" bundle:nil] forCellReuseIdentifier:@"picListCell"];
    // Do any additional setup after loading the view.
    [self initData];
    [self initBarItemBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData{
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    createPath = [NSString stringWithFormat:@"%@/Collection", pathDocuments];
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
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"清空收藏" style:UIBarButtonItemStyleDone target:self action:@selector(deleteCollection)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
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

-(void)deleteCollection{
    
    [CommonUtil confirmWithTitle:@"提示" message:@"清空收藏" buttonTitles:@[@"确认",@"取消"] completionBlock:^(NSUInteger buttonIndex) {
        if (buttonIndex == 0) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            createPath = [NSString stringWithFormat:@"%@/Collection", pathDocuments];
            
            NSArray *contents = [fileManager contentsOfDirectoryAtPath:createPath error:NULL];
            NSEnumerator *e = [contents objectEnumerator];
            NSString *filename;
            while ((filename = [e nextObject])) {
                
                [fileManager removeItemAtPath:[createPath stringByAppendingPathComponent:filename] error:NULL];
                
            }
            
            //清空临时数组
            [resultArray2 removeAllObjects];
            
            //提示
            [MBHUDUntil showHUDAddedTo:self.view OnlyText:@"收藏已清空"];
            [self.tableView reloadData];
        }
    }];
    
    
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
    PicListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"picListCell"];
    cell.constraint.constant = 0;
    cell.collectionBtn.hidden = YES;
    cell.titleLabel.text = resultArray2[indexPath.row]; //标题
    //临时地址，用于计算文件夹大小
    NSString * tempPath = [createPath stringByAppendingPathComponent:resultArray2[indexPath.row]];
    //获取文件数量
    NSInteger filecount = [[[NSFileManager alloc] init] contentsOfDirectoryAtPath:tempPath error:nil].count;
    cell.imagesCount = (int)filecount;
    cell.attributeLabel.text = [NSString stringWithFormat:@"%ld 张 (%.2fMB)",(long)filecount,[self folderSizeAtPath:tempPath]];
    cell.delegate = self;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        
        [CommonUtil confirmWithTitle:@"提示" message:@"删除收藏" buttonTitles:@[@"确认",@"取消"] completionBlock:^(NSUInteger buttonIndex) {
            if (buttonIndex == 0) {
                NSFileManager *fileManager = [[NSFileManager alloc] init];
                NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                createPath = [NSString stringWithFormat:@"%@/Collection", pathDocuments];
                
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
        return @[deleteRoWAction];//最后返回这俩个RowAction 的数组
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"collectionGoPic" sender:resultArray2[indexPath.row]];
}

#pragma mark - PicListCellDelegate

//删除按钮回调代理
- (void)tableViewCell:(PicListViewCell*)cell deleteButton:(UIButton*)button{
    
    [CommonUtil confirmWithTitle:@"提示" message:@"删除收藏" buttonTitles:@[@"确认",@"取消"] completionBlock:^(NSUInteger buttonIndex) {
        if (buttonIndex == 0) {
            NSIndexPath* indexpath = [self.tableView indexPathForCell:cell];
            
            NSFileManager *fileManager = [[NSFileManager alloc] init];
            NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            createPath = [NSString stringWithFormat:@"%@/Collection", pathDocuments];
            
            
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"collectionGoPic"]) {
        NSString *docstr = (NSString *)sender;
        NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *createPaths = [NSString stringWithFormat:@"%@/Collection", pathDocuments];
        
        [segue.destinationViewController setValue:createPaths forKey:@"mainPath"];
        [segue.destinationViewController setValue:docstr forKey:@"docPathStr"];
    }
}

@end
