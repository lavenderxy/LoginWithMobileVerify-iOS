//
//  PSmsLoginViewController.h
//  PaxiUser
//
//  Created by Xinyu Yan on 4/8/16.
//  Copyright © 2016 Deftsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSmsLoginViewController : UIViewController<UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *countryCodeTF;
@property (strong, nonatomic) IBOutlet UITextField *mobileNumberTF;
@property (strong, nonatomic) IBOutlet UITextField *verigyCodeTF;
@property (strong, nonatomic) IBOutlet UIButton *sendVerifyCodeBtn;
@property (strong, nonatomic) IBOutlet UIButton *signUpBtn;

- (IBAction)verifySend:(id)sender;
- (IBAction)signUpSend:(id)sender;

@end
