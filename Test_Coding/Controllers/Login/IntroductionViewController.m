//
//  IntroductionViewController.m
//  Test_Coding
//
//  Created by kai hu on 16/8/12.
//  Copyright © 2016年 kai hu. All rights reserved.
//

#import "IntroductionViewController.h"
#import <NYXImagesKit.h>
#import "SMPageControl.h"

@interface IntroductionViewController ()

@property(nonatomic, strong) UIButton *btnRegister;

@property(nonatomic, strong) UIButton *btnLogin;

@property(nonatomic, strong) SMPageControl *pageControl;

@property (strong, nonatomic) NSMutableDictionary *iconsDict, *tipsDict;

@end

@implementation IntroductionViewController

- (instancetype)init
{
    if (self = [super init]) {
        
        self.numberOfPages = 7;
        
        // 配置滚动页图片与标题
        _iconsDict = [@{
                        @"0_image" : @"intro_icon_6",
                        @"1_image" : @"intro_icon_0",
                        @"2_image" : @"intro_icon_1",
                        @"3_image" : @"intro_icon_2",
                        @"4_image" : @"intro_icon_3",
                        @"5_image" : @"intro_icon_4",
                        @"6_image" : @"intro_icon_5",
                        } mutableCopy];
        _tipsDict = [@{
                       @"1_image" : @"intro_tip_0",
                       @"2_image" : @"intro_tip_1",
                       @"3_image" : @"intro_tip_2",
                       @"4_image" : @"intro_tip_3",
                       @"5_image" : @"intro_tip_4",
                       @"6_image" : @"intro_tip_5",
                       } mutableCopy];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:THEME_COLOR_INTRO_BACK]];
    [self configureViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma - mark 添加view

- (void)configureViews
{
    [self configureButtonsAndPageControl];
    
    CGFloat scaleFactor = 1.0;
    CGFloat desginHeight = 667.0;//iPhone6 的设计尺寸
    if (!kDevice_Is_iPhone6 && !kDevice_Is_iPhone6Plus) {
        scaleFactor = kScreen_Height/desginHeight;
    }
    
    for (int i = 0; i < self.numberOfPages; i++) {
        NSString *imageKey = [self imageKeyForIndex:i];
        NSString *viewKey  = [self viewKeyForIndex:i];
        NSString *iconImageName = [self.iconsDict objectForKey:imageKey];
        NSString *tipImageName = [self.tipsDict objectForKey:imageKey];
        
        if (iconImageName) {
            UIImage *iconImage = [UIImage imageNamed:iconImageName];
            if (iconImage) {
                iconImage = scaleFactor != 1.0? [iconImage scaleByFactor:scaleFactor] : iconImage;
                UIImageView *iconView = [[UIImageView alloc] initWithImage:iconImage];
                [self.contentView addSubview:iconView];
                [self.iconsDict setObject:iconView forKey:viewKey];
            }
        }
        
        if (tipImageName) {
            UIImage *tipImage = [UIImage imageNamed:tipImageName];
            if (tipImage) {
                tipImage = scaleFactor != 1.0? [tipImage scaleByFactor:scaleFactor]: tipImage;
                UIImageView *tipView = [[UIImageView alloc] initWithImage:tipImage];
                [self.contentView addSubview:tipView];
                [self.tipsDict setObject:tipView forKey:viewKey];
            }
        }
    }

}

//添加按钮与滑动分页
- (void)configureButtonsAndPageControl
{
    [self.view addSubview:self.btnLogin];
    [self.view addSubview:self.btnRegister];
    
    UIImage *pageIndicatorImage         = [UIImage imageNamed:@"intro_dot_unselected"];
    UIImage *currentPageIndicatorImage  = [UIImage imageNamed:@"intro_dot_selected"];
    
    if (!kDevice_Is_iPhone6 && !kDevice_Is_iPhone6Plus )
    {
        CGFloat desginWidth = 375.0;
        CGFloat scaleFactor = kScreen_Width/desginWidth;
        pageIndicatorImage  = [pageIndicatorImage scaleByFactor:scaleFactor];
        currentPageIndicatorImage = [currentPageIndicatorImage scaleByFactor:scaleFactor];
    }
    self.pageControl.pageIndicatorImage = pageIndicatorImage;
    self.pageControl.currentPageIndicatorImage = currentPageIndicatorImage;
    
    [self.view addSubview:self.pageControl];
}

- (void)configureAnimations
{
    for (int index = 0; index < 7; index++) {
        NSString *viewKey  = [self viewKeyForIndex:index];
        UIView *iconView   = [self.iconsDict objectForKey:viewKey];
        UIView *tipView    = [self.tipsDict objectForKey:viewKey];
        if (iconView) {
            if (index == 0) {
                [self keepView:iconView onPages:@[@(index+1),@(index)] atTimes:@[@(index-1),@(index)]];
                [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(kScreen_Height / 7);
                }];
            } else {
                [self keepView:iconView onPage:index];
                [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(-kScreen_Height/6);
                }];
            }
            IFTTTAlphaAnimation *iconAlphaAnimation = [IFTTTAlphaAnimation animationWithView:iconView];
            [iconAlphaAnimation addKeyframeForTime:index -0.5 alpha:0.f];
            [iconAlphaAnimation addKeyframeForTime:index alpha:1.f];
            [iconAlphaAnimation addKeyframeForTime:index +0.5 alpha:0.f];
            
            [self.animator addAnimation:iconAlphaAnimation];
        }
        if (tipView)
        {
            [self keepView:tipView onPages:@[@(index+1),@(index)] atTimes:@[@(index-1),@(index)]];
            
            IFTTTAlphaAnimation *tipAlphaAnimation = [IFTTTAlphaAnimation animationWithView:tipView];
            [tipAlphaAnimation addKeyframeForTime:index -0.5 alpha:0.f];
            [tipAlphaAnimation addKeyframeForTime:index alpha:1.f];
            [tipAlphaAnimation addKeyframeForTime:index +0.5 alpha:0.f];
            [self.animator addAnimation:tipAlphaAnimation];
            
            [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(iconView.mas_bottom).offset(kScaleFrom_iPhone5_Desgin(45));
            }];
        }
    }
}

//设置约束
- (void)configureConstraints
{
    CGFloat btnWidth    = kScreen_Width *0.4f;
    CGFloat btnHeight   = kScaleFrom_iPhone5_Desgin(38);
    CGFloat paddingToCenter = kScaleFrom_iPhone5_Desgin(10);
    CGFloat paddingToBottom = kScaleFrom_iPhone5_Desgin(20);
    
    @weakify(self);
    [self.btnRegister mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.size.mas_equalTo(CGSizeMake(btnWidth, btnHeight));
        make.centerX.equalTo(self.view.mas_centerX).offset(-paddingToCenter);
        make.bottom.equalTo(self.view.mas_bottom).offset(paddingToBottom);
    }];
    
    [self.btnLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.size.mas_equalTo(CGSizeMake(btnWidth, btnHeight));
        make.centerX.equalTo(self.view.mas_centerX).offset(paddingToCenter);
        make.bottom.equalTo(self.view.mas_bottom).offset(paddingToBottom);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width, kScaleFrom_iPhone5_Desgin(20)));
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.btnRegister.mas_top).offset(kScaleFrom_iPhone5_Desgin(20));
    }];
}

- (NSString *)imageKeyForIndex:(NSInteger)index{
    return [NSString stringWithFormat:@"%ld_image", (long)index];
}

- (NSString *)viewKeyForIndex:(NSInteger)index{
    return [NSString stringWithFormat:@"%ld_view", (long)index];
}

#pragma - mark btn action 登录和注册

- (void)btnLoginAction
{
    
}

- (void)btnRegisterAction
{
    
}
#pragma - mark getter/setter

-(UIButton *)btnLogin
{
    if (!_btnLogin) {
        _btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnLogin.backgroundColor   = [UIColor colorWithHexString:THEME_COLOR_BLACK];
        _btnLogin.titleLabel.font   = [UIFont boldSystemFontOfSize:20];
        [_btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnLogin setTitle:@"登录" forState:UIControlStateNormal];
        
        _btnLogin.layer.masksToBounds = YES;
        _btnLogin.layer.cornerRadius  = kScaleFrom_iPhone5_Desgin(38);
        _btnLogin.layer.borderWidth   = 1.0;
        _btnLogin.layer.borderColor   = [UIColor colorWithHexString:THEME_COLOR_BLACK].CGColor;
        
        [_btnLogin addTarget:self action:@selector(btnLoginAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _btnLogin;
}

-(UIButton *)btnRegister
{
    if (!_btnRegister) {
        _btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnRegister.backgroundColor   = [UIColor colorWithHexString:THEME_COLOR_BLACK];
        _btnRegister.titleLabel.font   = [UIFont boldSystemFontOfSize:20];
        [_btnRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnRegister setTitle:@"注册" forState:UIControlStateNormal];
        
        _btnRegister.layer.masksToBounds = YES;
        _btnRegister.layer.cornerRadius  = kScaleFrom_iPhone5_Desgin(38);
        _btnRegister.layer.borderWidth   = 1.0;
        _btnRegister.layer.borderColor   = [UIColor colorWithHexString:THEME_COLOR_BLACK].CGColor;
        
        [_btnRegister addTarget:self action:@selector(btnRegisterAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnLogin;
}

- (SMPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[SMPageControl alloc]init];
        _pageControl.numberOfPages = self.numberOfPages;
        _pageControl.userInteractionEnabled = NO;
        [_pageControl sizeToFit];
        _pageControl.currentPage = 0;
        
    }
    return _pageControl;
}

@end
