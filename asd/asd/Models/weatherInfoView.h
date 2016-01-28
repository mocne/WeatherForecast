//
//  weatherInfoView.h
//  asd
//
//  Created by kaifeng on 16/1/26.
//  Copyright © 2016年 kaifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface weatherInfoView : UIView

@property (weak, nonatomic) IBOutlet UIButton *cityNameBtn;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *hightest;
@property (weak, nonatomic) IBOutlet UILabel *lowest;
@property (weak, nonatomic) IBOutlet UIScrollView *futureWeather;
@property (weak, nonatomic) IBOutlet UILabel *todayWeatherInfoLabel;

@end
