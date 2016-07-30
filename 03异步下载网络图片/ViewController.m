//
//  ViewController.m
//  03异步下载网络图片
//
//  Created by 李朝霞 on 16/7/29.
//  Copyright © 2016年 李朝霞. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "HMAppInfo.h"
#import "UIImageView+WebCache.h"

@interface ViewController ()

@property(nonatomic,strong)NSMutableArray* appInfos;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.appInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    HMAppInfo* info = self.appInfos[indexPath.row];
    
    cell.textLabel.text = info.name;
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:info.icon]];
    
    return cell;
    
}

- (NSMutableArray *)appInfos{
    if (_appInfos == nil) {
        _appInfos = [NSMutableArray array];
    }
    return _appInfos;
}

- (void)loadData
{
    NSString* urlString = @"https://raw.githubusercontent.com/yinqiaoyin/SimpleDemo/master/apps.json";
    //初始化一个网络请求的管理器
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",[NSThread currentThread]);
        
        //1.字典转模型
        NSArray* array = responseObject;
        
        for (NSDictionary* dict in array) {
            //2初始化模型
            HMAppInfo* info = [[HMAppInfo alloc]init];
            //3使用KVC的方式赋值
            [info setValuesForKeysWithDictionary:dict];
            //4将模型添加到可变数组
            [self.appInfos addObject:info];
            
        }
        
        NSLog(@"%@",self.appInfos);
        //刷新数据
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",[NSThread currentThread]);
        NSLog(@"请求失败%@",error);
    }];
}


@end
