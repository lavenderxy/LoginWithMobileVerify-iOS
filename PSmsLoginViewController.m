//
//  PSmsLoginViewController.m
//  PaxiUser
//
//  Created by Xinyu Yan on 4/8/16.
//  Copyright © 2016 Deftsoft. All rights reserved.
//

#import "PSmsLoginViewController.h"
#import "SVProgressHUD.h"
#import "PAppManager.h"


@interface PSmsLoginViewController (){
    NSString *tableData;
}

@property(nonatomic,strong)NSTimer *codeTimer;

@end

@implementation PSmsLoginViewController

@synthesize countryCodeTF,mobileNumberTF,verigyCodeTF,sendVerifyCodeBtn,signUpBtn;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self m_GetApiResponseOnCompletion:^(NSDictionary *json){
        NSDictionary *dic = (NSDictionary *)json;
        NSLog(@"jsonData(Version test) %@",dic);
        if ([[dic valueForKey:@"return"] integerValue]==299 && [[json objectForKey:@"result"] isEqualToString:@"error"]) {
            NSString *messStr = [json objectForKey:@"data"];
//            [self alertShowWithMessage:messStr];
            UIView *alertUpdate = [[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width*0.5-135, self.view.bounds.size.height*0.5-72, 270, 144)];
            [alertUpdate setBackgroundColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0]];
            alertUpdate.layer.cornerRadius = 10;
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, 150, 30)];
            [title setText:@"Version Update"];
            [title setFont:[UIFont fontWithName:@"Helvetica" size:16]];
            [title setTextAlignment:NSTextAlignmentCenter];
            [alertUpdate addSubview:title];
            UILabel *des = [[UILabel alloc] initWithFrame:CGRectMake(15, 60, 240, 30)];
            des.text= messStr;
            [des setFont:[UIFont fontWithName:@"Helvetica-Light" size:14]];
            [des setTextAlignment:NSTextAlignmentCenter];
            [alertUpdate addSubview:des];
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 270, 0.5)];
            line.backgroundColor = [UIColor colorWithRed:20/255.0 green:20/255.0 blue:20/255.0 alpha:0.9];
            [alertUpdate addSubview:line];
            UIButton *updateBtw = [UIButton buttonWithType:UIButtonTypeSystem];
            [updateBtw setFrame:CGRectMake(85, 106,100, 30)];
            [updateBtw setTitle:@"OK" forState:UIControlStateNormal];
            [updateBtw addTarget:self action:@selector(jumpToVersion:) forControlEvents:UIControlEventTouchUpInside];
            [alertUpdate addSubview:updateBtw];
            
            
            UIView *backgroundOver = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            [backgroundOver setBackgroundColor:[UIColor colorWithRed:20/255.0 green:20/255.0 blue:20/255.0 alpha:0.3]];
            
            [self.view addSubview:backgroundOver];
            [backgroundOver addSubview:alertUpdate];
            
            
        }
    }];
}

-(void)jumpToVersion:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.apple.com/cn/"]];
}

-(void)alertShowWithMessage:(NSString*)messageForAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Version Update"
                                                    message:messageForAlert
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    alert.tag = 0;
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==0) {
        if (buttonIndex == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.apple.com/cn/"]];
        }

    }
}


-(void)m_GetApiResponseOnCompletion:(JSONResponseBlock)completionBlock{
    NSString *methodName = @"versionTest";
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//    int myInteger = 5;
//    NSString *app = [NSString stringWithFormat:@"%i",myInteger];
    NSString *urlStr = [NSString stringWithFormat:@"http://54.68.213.133/paxi2.php?method=verifyVersion&ver=%@",appVersion];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    NSLog(@"API URL: %@",urlStr);
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"API Return(%@): %@",methodName,responseObject);
        completionBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"API Return(%@, Error): %@",methodName,[error localizedDescription]);
        completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    [[NSOperationQueue currentQueue] addOperation:operation];

}

-(void)m_GetApiResponseCountryCode:(NSString *)ctyCode andMobileNumber:(NSString*)mblNum onCompletion:(JSONResponseBlock)completionBlock{
    NSString *methodName = @"SendCode";
    NSString *urlStr = [NSString stringWithFormat:@"http://54.68.213.133/paxi2.php?method=getLoginCode&phone=%@&countrycode=%@",mblNum,ctyCode];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    NSLog(@"API URL: %@",urlStr);
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"API Return(%@): %@",methodName,responseObject);
        completionBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"API Return(%@, Error): %@",methodName,[error localizedDescription]);
        completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    [[NSOperationQueue currentQueue] addOperation:operation];
    
}

-(void)m_GetApiResponsePhone:(NSString *)phoneNum andCountryCode:(NSString *)ctyCode andTableData:(NSString *)tableData andVerifyCode:(NSString *)verifyCode andDeviceCode:(NSString *)deviceCode onCompletion:(JSONResponseBlock)completionBlock{
    NSString *methodName = @"SignUp";
    NSString *urlStr = [NSString stringWithFormat:@"http://54.68.213.133/paxi2.php?method=verifyCode&phone=%@&countrycode=%@&table=%@&smscode=%@&devicetoken=%@",phoneNum,ctyCode,tableData,verifyCode,deviceCode];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    NSLog(@"API URL: %@",urlStr);
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"API Return(%@): %@",methodName,responseObject);
        completionBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"API Return(%@, Error): %@",methodName,[error localizedDescription]);
        completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    [[NSOperationQueue currentQueue] addOperation:operation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[PAppManager sharedData] m_AddPadding:countryCodeTF];
    [[PAppManager sharedData] m_AddPadding:mobileNumberTF];
    [[PAppManager sharedData] m_AddPadding:verigyCodeTF];
    
    [[PAppManager sharedData]m_ChangePLaceHolderColor:[UIColor colorWithRed:69/255.0 green:178/255.0 blue:181/255.0 alpha:1.0] textField:countryCodeTF];
    [[PAppManager sharedData]m_ChangePLaceHolderColor:[UIColor colorWithRed:69/255.0 green:178/255.0 blue:181/255.0 alpha:1.0] textField:mobileNumberTF];
    [[PAppManager sharedData] m_ChangePLaceHolderColor:[UIColor colorWithRed:69/255.0 green:178/255.0 blue:181/255.0 alpha:1.0] textField:verigyCodeTF];
    
    mobileNumberTF.placeholder = NSLocalizedString(@"Mobile Phone", nil);
    countryCodeTF.placeholder = NSLocalizedString(@"Country Code", nil);
    countryCodeTF.text = @"+86";
    verigyCodeTF.placeholder = NSLocalizedString(@"Verify Code", nil);
    
    
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

-(void)resetSmsVerifyCodeTimer:(UIButton *)button{
    [button setTitle:@"10s 剩余" forState:UIControlStateNormal];
    [button setUserInteractionEnabled:NO];
    _codeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimerText:) userInfo:button repeats:YES];
}

-(void)resetSmsVerifyCodeTimer1:(UIButton *)button{
    [button setTitle:@"60s 剩余" forState:UIControlStateNormal];
    [button setUserInteractionEnabled:NO];
    _codeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimerText:) userInfo:button repeats:YES];
}

-(void)updateTimerText:(NSTimer *)timer{
    UIButton *button = [timer userInfo];
    NSString *countdown = button.titleLabel.text;
    if ([countdown isEqualToString:@"0"] || [countdown intValue]<1) {
        [self cancelSMSTimer:timer];
    }else{
        int icountdown = [countdown intValue];
        icountdown--;
        NSString *ncountdown = [[NSString alloc] initWithFormat:@"%d",icountdown];
        NSString *ncountdownStr = [NSString stringWithFormat:@"%@ s 剩余",ncountdown];
        [button setTitle:ncountdownStr forState:UIControlStateNormal];
    }
}

-(void)cancelSMSTimer:(NSTimer *)timer{
    UIButton *button = [timer userInfo];
    if ([_codeTimer isValid]) {
        [_codeTimer invalidate];
        _codeTimer = nil;
    }
    [button setTitle:@"获取验证码" forState:UIControlStateNormal];
    button.userInteractionEnabled = YES;
    
}


- (IBAction)verifySend:(id)sender {
    NSString *mobileNumber = [NSString stringWithFormat:@"%@",mobileNumberTF.text];
    NSString *ctyNumber = [NSString stringWithFormat:@"%@",countryCodeTF.text];
    NSString *ctyStr =[ctyNumber substringFromIndex:1];
//    sendVerifyCodeBtn.enabled = NO;

    [self m_GetApiResponseCountryCode:ctyStr andMobileNumber:mobileNumber onCompletion:^(NSDictionary * json) {
        NSDictionary *dic = (NSDictionary *)json;
        NSLog(@"jsonData(verifyCode test) %@",dic);
        tableData = [json objectForKey:@"data"];
        if ([[dic valueForKey:@"return"] integerValue]==501 || [[dic valueForKey:@"return"] integerValue]==509) {
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:@"Please try again later!"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
            alert1.tag = 1;
            [alert1 show];
//            double delaySeconds = 10.0;
//            
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delaySeconds * NSEC_PER_SEC);
//            dispatch_after(popTime, dispatch_get_main_queue(), ^{
//                sendVerifyCodeBtn.enabled = YES;
//            });
            [self resetSmsVerifyCodeTimer:sendVerifyCodeBtn];
            
        }else if ([[dic valueForKey:@"return"] integerValue]==100){
//            double delaySeconds = 60.0;
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delaySeconds * NSEC_PER_SEC);
//            dispatch_after(popTime, dispatch_get_main_queue(), ^{
//                sendVerifyCodeBtn.enabled = YES;
//            });
            [self resetSmsVerifyCodeTimer1:sendVerifyCodeBtn];
        }

    }];
    
}


- (IBAction)signUpSend:(id)sender {
    NSString *veriCode = verigyCodeTF.text;
    NSInteger digit = [veriCode length];
    NSString *phoneNum = mobileNumberTF.text;
    NSInteger digitPhone = [phoneNum length];
    if (digit!=4) {
        UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:@"Please Enter 4 digit verify code!"
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        alert2.tag = 2;
        [alert2 show];
        
    }else if (digitPhone == 0 ){
        UIAlertView *alert3 = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:@"Mobile Number couldn't be empty!"
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        alert3.tag = 3;
        [alert3 show];

    }else{
    
        NSString *mobileNum = [NSString stringWithFormat:@"%@",mobileNumberTF.text];
        NSString *ctyNum =[NSString stringWithFormat:@"%@",countryCodeTF.text];
        NSString *ctyStr = [ctyNum substringFromIndex:1];
        NSString *verCode = [NSString stringWithFormat:@"%@",verigyCodeTF.text];
        NSString *deviceCode = [[NSUserDefaults standardUserDefaults] valueForKey:deviceId];
        
        [self m_GetApiResponsePhone:mobileNum andCountryCode:ctyStr andTableData:tableData andVerifyCode:verCode andDeviceCode:deviceCode onCompletion:^(NSDictionary * json) {
            NSDictionary *dic = (NSDictionary *)json;
            NSLog(@"jsonData(SignUp test) %@",dic);
            
            if ([[json objectForKey:@"result"] isEqualToString:@"error"]) {
                UIAlertView *alert4 = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                 message:@"Verify Code is incorrect!Plese try again!"
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                alert4.tag = 4;
                [alert4 show];

            }else{
                [[NSUserDefaults standardUserDefaults]setValue:[[json objectForKey:@"data"] valueForKey: @"userid"] forKey:@"userid"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                DLog(@"");
                
                [SVProgressHUD showSuccessWithStatus: NSLocalizedString(@"Done",nil)];
                [[NSUserDefaults standardUserDefaults] setValue:[[json valueForKey:@"data"] valueForKey:@"userid"] forKey:userId];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loginDone"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[PAppDelegate sharedAppDelegate] m_LoadHomeView];

            }
            
            
        }];
    
    }
    
}


@end
