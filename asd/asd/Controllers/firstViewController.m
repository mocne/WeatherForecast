//
//  firstViewController.m
//  asd
//
//  Created by kaifeng on 16/1/24.
//  Copyright © 2016年 kaifeng. All rights reserved.
//

#import "firstViewController.h"
#import "citysViewController.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "Header.h"
#import "weatherInfoView.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

@interface firstViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *citiesArr;
@property (nonatomic, strong) NSString *cityName;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSDictionary *weatherInfo;
@property (nonatomic, strong) NSArray *colorArr;
@property (nonatomic) int num;

@end

@implementation firstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.translucent = NO;
    
    _num = 0;
    _scrollView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    _scrollView.pagingEnabled = YES;
    
    _colorArr = @[[UIColor redColor],[UIColor blueColor],[UIColor greenColor]];
    
    _citiesArr = [[NSMutableArray alloc] init];
    
    [self setCity];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCity:) name:@"getCity" object:nil];
    
    // Do any additional setup after loading the view.
}

- (void)getCity:(NSNotification *)notification{
    
    NSString *temp = notification.userInfo[@"value"];
    [_citiesArr addObject:temp];
    
    [self getWeatherWithCity:_citiesArr[_citiesArr.count - 1]];
    
    
}

- (void)setCity{
    
    if (_citiesArr.count == 0) {
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择您要关注的城市" message:@"您还没有关注任何城市" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您没有关注任何城市" message:@"没有关注任何城市则无法获取任何信息，您要继续吗？" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *sancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
                
            }];
            
            UIAlertAction *doitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                citysViewController *new = [citysViewController new];
                [self.navigationController pushViewController:new animated:YES];
            }];
            
            [alert addAction:sancelAction];
            [alert addAction:doitAction];
            
            [self presentViewController:alert animated:YES completion:^{}];
            
        }];
        
        UIAlertAction *doitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            citysViewController *new = [citysViewController new];
            [self.navigationController pushViewController:new animated:YES];
        }];
        
        [alert addAction:sancelAction];
        [alert addAction:doitAction];
        
        [self presentViewController:alert animated:YES completion:^{}];
    }
}

- (IBAction)changeCity:(UIBarButtonItem *)sender {
    citysViewController *new = [citysViewController new];
    [self.navigationController pushViewController:new animated:YES];
}

- (NSDictionary *)getWeatherWithCity:(NSString *)cityName{
    
    _scrollView.contentSize = CGSizeMake(kScreenW * _citiesArr.count, 0);
    UIScrollView *new = [[UIScrollView alloc] initWithFrame:CGRectMake(kScreenW * (_citiesArr.count - 1), 0, kScreenW, kScreenH - 104)];
    
    new.contentSize = CGSizeMake(0, 1000);
    
//    UIButton *asd = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
//    asd.center = CGPointMake(kScreenW / 2, 30);
//    [asd setTitle:[NSString stringWithFormat:@"%@",_citiesArr[_citiesArr.count - 1]] forState:UIControlStateNormal];
//    [asd setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [asd addTarget:self action:@selector(addCity) forControlEvents:UIControlEventTouchUpInside];
//    [new addSubview:asd];
//    
//    UILabel *temperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 60)];
//    temperatureLabel.center = CGPointMake(kScreenW / 2, 110);
//    temperatureLabel.textAlignment = NSTextAlignmentCenter;
//    [new addSubview:temperatureLabel];
//    [_scrollView addSubview:asd];
    
    
    weatherInfoView *a = [weatherInfoView new];
    
    [new addSubview:a];
    
    
    [_scrollView addSubview:new];
    
    _scrollView.contentOffset = CGPointMake((_citiesArr.count - 1) * kScreenW, 0);

    //请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"] = kJuheWeatherAppKey;
    params[@"cityname"] = cityName;
    params[@"dtype"] = @"json";
    
    NSString *urlStr = @"http://op.juhe.cn/onebox/weather/query";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *temp = (NSDictionary *)responseObject;
        _weatherInfo = temp[@"result"][@"data"];
//        temperatureLabel.text = [NSString stringWithFormat:@"%@°",_weatherInfo[@"realtime"][@"weather"][@"temperature"]];
//        temperatureLabel.font = [UIFont systemFontOfSize:80];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"errror:%@",error);
        return ;
    }];
    
    return _weatherInfo;
    
}

- (void)addCity{
    citysViewController *cityVC = [citysViewController new];
    [self.navigationController pushViewController:cityVC animated:YES];
}

@end
