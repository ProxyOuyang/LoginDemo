//
//  OYLoginViewController.m
//  LGOIN DEMO
//
//  Created by ; on 17/2/28.
//  Copyright © 2017年 Proxy_OuYang. All rights reserved.
//

#import "OYLoginViewController.h"
#import "AppDelegate.h"

#define TAG_USERNAME_TEXTVIEW 1000
#define TAG_PASSWORD_TEXTVIEW 1001
#define RESUTL NO
#define DEFAULT_CORNERRADIUS 5

@interface OYLoginViewController ()
{
    CGFloat y_center;
    CGFloat x_center;
    BOOL isClick;
    CGFloat cornerRadius;
    CADisplayLink *dispaly;
}

@property (nonatomic, strong) UIView *loginView;
@property (nonatomic, strong) CAShapeLayer *loadingLayer;
@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation OYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isClick = NO;
    y_center = self.view.center.y;
    x_center = self.view.center.x;
    cornerRadius = DEFAULT_CORNERRADIUS;
    
    [self createLoginViewBackground];
    [self createLoginView];
    [self createLoginButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  background color
 *
 *  @author Administration
 */
- (void)createLoginViewBackground
{
    CAGradientLayer *bgLayer = [[CAGradientLayer alloc] init];
    bgLayer.bounds = self.view.bounds;
    bgLayer.position = self.view.center;
    bgLayer.type = kCAGradientLayerAxial;
    bgLayer.startPoint = CGPointMake(0.0, 1.0);
    bgLayer.endPoint = CGPointMake(0.0, 0.0);
    bgLayer.colors = @[(__bridge id)[UIColor colorWithRed:144/255.0 green:233/255.0 blue:190/255.0 alpha:1.0].CGColor,
                     (__bridge id)[UIColor colorWithRed:91/255.0 green:199/255.0 blue:159/255.0 alpha:1.0].CGColor];
    bgLayer.locations = @[@(0.5)];
    [self.view.layer addSublayer:bgLayer];
}

/**
*  create views
*
*  @author Administration
*/
- (void)createLoginView
{
    self.loginView = [[UIView alloc] init];
    self.loginView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.loginView];
    self.loginView.frame = CGRectMake(30, y_center-120, CGRectGetWidth(self.view.frame)-60, 100);
    self.loginView.layer.cornerRadius = cornerRadius;
    
    [self createTextField];
    [self createLineView];
}

- (void)createLineView
{
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_loginView.frame)/2-1, CGRectGetWidth(_loginView.frame), 2)];
    _lineView.backgroundColor = [UIColor colorWithRed:144/255.0 green:233/255.0 blue:190/255.0 alpha:1.0];
    [_loginView addSubview:_lineView];
}
    
- (void)createTextField
{
    self.usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(self.loginView.frame), 35)];
    self.usernameTextField.placeholder = @"please input username";
    self.usernameTextField.text = @"user";
    self.usernameTextField.tag = TAG_USERNAME_TEXTVIEW;
    [self.loginView addSubview:self.usernameTextField];
    
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 55, CGRectGetWidth(self.loginView.frame), 35)];
    self.passwordTextField.placeholder = @"please input password";
    self.passwordTextField.text = @"1";
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.tag = TAG_PASSWORD_TEXTVIEW;
    [self.loginView addSubview:self.passwordTextField];
}

- (void)createLoginButton
{
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.loginButton.frame = CGRectMake(x_center - 80, y_center, 160, 40);
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(actionOnTouchLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.loginButton addTarget:self action:@selector(notificationOnButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.loginButton addTarget:self action:@selector(notificationOnButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    self.loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.loginButton.layer.cornerRadius = 20.0;
    self.loginButton.layer.borderWidth = 1.0;
    
    [self.view addSubview:self.loginButton];
}

- (void)createLodingView
{
    _loadingLayer = [CAShapeLayer layer];
    
    _loadingLayer.position = CGPointMake(_loginView.bounds.size.width/2, _loginView.bounds.size.height/2);
    _loadingLayer.fillColor = [UIColor clearColor].CGColor;
    _loadingLayer.strokeColor = [UIColor colorWithRed:144/255.0 green:233/255.0 blue:190/255.0 alpha:1.0].CGColor;
    _loadingLayer.lineWidth = 5;
    _loadingLayer.path = [self drawLoadingView].CGPath;
    
    [_loginView.layer addSublayer:_loadingLayer];
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    basicAnimation.fromValue = @(0);
    basicAnimation.toValue = @(M_PI*2);
    basicAnimation.duration = 0.5;
    basicAnimation.repeatCount = LONG_MAX;
    
    [_loadingLayer addAnimation:basicAnimation forKey:@"loadingAnimation"];
}

-(UIBezierPath *)drawLoadingView{
    
    CGFloat radius = _loginView.bounds.size.height/2 - 20;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath addArcWithCenter:CGPointMake(0,0) radius:radius startAngle:M_PI/2 endAngle:M_PI/2+M_PI/2 clockwise:YES];
    return bezierPath;
}

/**
 * reset view
 * @author Administration
 */
- (void)resetView
{
    [_loadingLayer removeFromSuperlayer];
    cornerRadius = DEFAULT_CORNERRADIUS;
    [dispaly invalidate];
    dispaly = nil;
    self.loginView.frame = CGRectMake(30, y_center-120, CGRectGetWidth(self.view.frame)-60, 100);
    self.loginView.layer.cornerRadius = cornerRadius;
    self.usernameTextField.alpha = 1;
    self.passwordTextField.alpha = 1;
    self.lineView.alpha = 1;
    self.loginButton.enabled = YES;
}
    
/**
 * network request
 * @parameter: user name and password
 * @author Administration
 */
- (void)requestNetworkOfLoginWithUserName: (NSString *)username Password: (NSString *)password
{
    if ([username isEqualToString:@"user"] && [password isEqualToString:@"1"]) {
        
        BOOL result = RESUTL;
        __block __typeof(self) weakSelf = self;
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            
            if (result == YES) {
                AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [app setWindowRootViewWithStringType:@"Login"];
            } else {
                [weakSelf resetView];
            }
        });
        
    } else {
        [self resetView];
    }
}

// MARK: timer
- (void)createTimer
{
    dispaly = [CADisplayLink displayLinkWithTarget:self selector:@selector(actionOnDisplayTimer)];
    dispaly.frameInterval = 0;
    [dispaly addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
}

- (void)actionOnDisplayTimer
{
    if (cornerRadius < 50) {
        cornerRadius += 1.25;
    } else {
        cornerRadius = 50;
    }
    
    self.loginView.layer.cornerRadius = cornerRadius;
    
    if (cornerRadius == 50){
        [dispaly invalidate];
        dispaly = nil;
        [self createLodingView];
        
        [self requestNetworkOfLoginWithUserName:_usernameTextField.text Password:_passwordTextField.text];
    }
}

// MARK: action
- (void)actionOnTouchLoginButton: (UIButton *)button
{    
    self.loginButton.enabled = NO;
    self.usernameTextField.alpha = 0;
    self.passwordTextField.alpha = 0;
    self.lineView.alpha = 0;
    
    [self createTimer];
    [UIView animateWithDuration:0.5 animations:^{
        self.loginView.layer.bounds = CGRectMake(0, 0, 100, 100);
    }];
}

// MARK: button touch method of notification
- (void)notificationOnButtonTouchDown: (UIButton *)button
{
    [UIView animateWithDuration:0.5 animations:^{
        
        button.transform = CGAffineTransformMakeScale(1.1,  1.1);
        
        button.backgroundColor = [UIColor whiteColor];
    }];
}

- (void)notificationOnButtonTouchUpInside: (UIButton *)button
{
    [UIView animateWithDuration:0 animations:^{
        
        button.transform = CGAffineTransformMakeScale(1.0,  1.0);
        
        button.backgroundColor = [UIColor clearColor];
    }];
}

// MARK: touch method
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
