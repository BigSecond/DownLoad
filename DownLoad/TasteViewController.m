//
//  TasteViewController.m
//  DownLoad
//
//  Created by JacksonMichael on 16/8/15.
//  Copyright © 2016年 JacksonMichael. All rights reserved.
//

#import "TasteViewController.h"
#import "SeeImageObj.h"
#import "SeeImagesView.h"

@interface TasteViewController ()
{
    UIBarButtonItem * items;
    SeeImagesView * Img;
}
@end

@implementation TasteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initImages];
    items = [[UIBarButtonItem alloc]initWithTitle:@"gogogo" style:UIBarButtonItemStyleDone target:self action:@selector(gogogo)];
    self.navigationItem.rightBarButtonItem = items;
    
}

-(void)gogogo{
    [Img gostart];
}

- (void)initImages{
    NSMutableArray * temparr = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.imagesArr.count; i++) {
        SeeImageObj *z = [[SeeImageObj alloc]init];
        UIImage * img = (UIImage *)self.imagesArr[i];
        
        z.imgdata = img;
        //大渺的完美算法
        float beishu = img.size.width / img.size.height;
        z.whidth = [NSString stringWithFormat:@"%f", [[UIScreen mainScreen] bounds].size.width];
        z.height = [NSString stringWithFormat:@"%f", img.size.height - ((img.size.width - [[UIScreen mainScreen] bounds].size.width) / beishu)];
        z.imgTitle = @"";
        z.imgContent = self.titleName;
        
        [temparr addObject:z];
    }
    
    Img = [[SeeImagesView alloc]initWithFrame:CGRectMake(0, 10, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
//    SeeImagesView * Img = [[SeeImagesView alloc]initWithFrame:CGRectMake(0, 10, 320, 400)];
    [Img setObj:temparr[0] ImageArray:temparr andBtn:items];
    Img.isOpen = YES;
    [self.view addSubview:Img];
    
//    [Img gostart];
    
//    SeeImagesView *ss = [[SeeImagesView alloc]init];
//    CGRect re1 = ss.frame;
//    re1.origin.x = 200;
//    re1.origin.y = 250;
//    re1.size.width = 320;
//    re1.size.height = 400;
//    ss.frame = re1;
//    
//    [ss setObj:temparr[0] ImageArray:nil];
//    ss.isOpen = YES;
//    [self.view addSubview:ss];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
