//
//  citysViewController.m
//  小精灵
//
//  Created by kaifeng on 16/1/20.
//  Copyright © 2016年 kaifeng. All rights reserved.
//

#import "citysViewController.h"
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

@interface citysViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *indexSource;

@property (nonatomic,strong) NSString *cityName;

@end

@implementation citysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"城市列表";
    
    self.navigationController.navigationBar.hidden = NO;
    
    [self initData];
    
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    _tableView.sectionIndexColor = [UIColor lightGrayColor];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    
}


-(void)initData {
    self.dataSource = [[NSMutableArray alloc] init];
    self.indexSource = [[NSMutableArray alloc] init];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
    NSMutableArray *city = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    _dataSource = [self sortArray:city];
    
}



-(void)OnCloseBtn:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//排序并按首字母分组
-(NSMutableArray *)sortArray:(NSMutableArray *)arrayToSort {
    NSMutableArray *arrayForArrays = [[NSMutableArray alloc] init];
    
    //根据拼音对数组排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinyin" ascending:YES]];
    //排序
    [arrayToSort sortUsingDescriptors:sortDescriptors];
    
    NSMutableArray *tempArray = nil;
    BOOL flag = NO;
    
    //分组
    for (int i = 0; i < arrayToSort.count; i++) {
        NSString *pinyin = [arrayToSort[i] objectForKey:@"pinyin"];
        NSString *firstChar = [pinyin substringToIndex:1];
        if (![_indexSource containsObject:[firstChar uppercaseString]]) {
            [_indexSource addObject:[firstChar uppercaseString]];
            tempArray = [[NSMutableArray alloc] init];
            flag = NO;
        }
        if ([_indexSource containsObject:[firstChar uppercaseString]]) {
            [tempArray addObject:arrayToSort[i]];
            if (flag == NO) {
                [arrayForArrays addObject:tempArray];
                flag = YES;
            }
        }
    }
    
    return arrayForArrays;
}


#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource[section] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_indexSource objectAtIndex:section];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return _indexSource;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 51;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"selectedCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    cell.textLabel.text = [[self.dataSource[indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getCity" object:nil userInfo:@{@"value":[[self.dataSource[indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"]}];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
