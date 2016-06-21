//
//  ViewController.m
//  IdNumberInput
//
//  Created by yxhe on 16/5/6.
//  Copyright © 2016年 yxhe. All rights reserved.
//

#import "UPViewController.h"
#import "NumberKeyboardView.h"

#define KEY_WIDTH 106
#define KEY_HEIGHT 53

#define XBUTTON_MODIFY_TAG 8


@interface UPViewController ()<UITextFieldDelegate, NumberKeyBoardViewDelegate>

@property UITextField *idCardNumberSystemModify; //keyboard modified from system keyboard
@property UITextField *idCardNumberSelfDefine;   //keyboard defined all by myself
@property NumberKeyboardView *numberKeyboard;    //the defined numberPad

@property UIButton *submitBtn;                   //the button to submit id number and hide keyboard

@end

@implementation UPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //initalize the first textField
    self.idCardNumberSystemModify = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 140, 100, 280, 30)];
    [_idCardNumberSystemModify setBorderStyle:UITextBorderStyleRoundedRect];
    [_idCardNumberSystemModify setKeyboardType:UIKeyboardTypeNumberPad];
    [_idCardNumberSystemModify setTextAlignment:NSTextAlignmentLeft];
    [_idCardNumberSystemModify setPlaceholder:@"input ID with modified keyboard"];
    [_idCardNumberSystemModify setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.view addSubview:self.idCardNumberSystemModify];
    [_idCardNumberSystemModify setDelegate:self];
    
    //initalize the second textField
    _idCardNumberSelfDefine = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 140, 200, 280, 30)];
    [_idCardNumberSelfDefine setBorderStyle:UITextBorderStyleRoundedRect];
    [_idCardNumberSelfDefine setTextAlignment:NSTextAlignmentLeft];
    [_idCardNumberSelfDefine setPlaceholder:@"input ID with defined keyboard"];
    [_idCardNumberSelfDefine setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.view addSubview:_idCardNumberSelfDefine];
    [_idCardNumberSelfDefine setDelegate:self];
    
    //intialize the defined keyboardview
    self.numberKeyboard = [[NumberKeyboardView alloc] init];
    self.numberKeyboard.delegate = self;
    
    //replace the input keyboard with selfdefined keypad
    _idCardNumberSelfDefine.inputView = self.numberKeyboard;
    
    //initialize the submit button
    self.submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, 150, 100, 20)];
    [_submitBtn setTitle:@"submit" forState:UIControlStateNormal];
    [_submitBtn setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:_submitBtn];
    [self.submitBtn addTarget:self action:@selector(onSubmitBtnClicked) forControlEvents:UIControlEventTouchUpInside];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - textField delegate functions

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"keyboard begin edit");
    
    //choose which keyboard
    if(textField == _idCardNumberSystemModify)
    {
        //delay some seconds because button appears after the keyboard, this method works but not well T_T
        [self performSelector:@selector(addXButtonToKeyboard) withObject:nil afterDelay:0.1];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //when the keyboard hide, remove the Xbutton
    NSLog(@"keyboard end edit");
    if(textField == _idCardNumberSystemModify)
    {
        [self removeXButtonFromKeyBoard];
    }
}

#pragma mark - modify method:add button and callback

- (void)addXButtonToKeyboard
{
    [self addXButtonToKeyboardWithSelector:@selector(onXButtonClicked)
                     normalImg:[UIImage imageNamed:@"Xbutton_normal.png"]
                  highlightImg:[UIImage imageNamed:@"Xbutton_highlight.png"]];
}

- (void)addXButtonToKeyboardWithSelector:(SEL)button_callback normalImg:(UIImage *)normal_icon highlightImg:(UIImage *)highlight_icon
{
    //create the XButton
    UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
    xButton.tag = XBUTTON_MODIFY_TAG;
    xButton.frame = CGRectMake(0, 0, KEY_WIDTH, KEY_HEIGHT); //the half size of the original image
    xButton.adjustsImageWhenDisabled = NO;
    
    [xButton setImage:normal_icon forState:UIControlStateNormal];
    [xButton setImage:highlight_icon forState:UIControlStateHighlighted];
    [xButton addTarget:self action:button_callback forControlEvents:UIControlEventTouchUpInside];
    
    //add to keyboard
    int cnt = [[UIApplication sharedApplication] windows].count;
    UIWindow *keyboardWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:cnt - 1];
    xButton.frame = CGRectMake(0, keyboardWindow.frame.size.height - KEY_HEIGHT, KEY_WIDTH, KEY_HEIGHT);
    [keyboardWindow addSubview:xButton];
    
}

//when XButton clicked, textField add 'X' char
- (void)onXButtonClicked
{
    self.idCardNumberSystemModify.text = [_idCardNumberSystemModify.text stringByAppendingString:@"X"];
}

//remove XButton from keyboard when the keyboard hide
- (void)removeXButtonFromKeyBoard
{
    int cnt = [[UIApplication sharedApplication] windows].count;
    UIWindow *keyboardWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:cnt - 1];
    [[keyboardWindow viewWithTag:XBUTTON_MODIFY_TAG] removeFromSuperview];
}

#pragma mark - define method: callbacks
- (void)keyboard:(NumberKeyboardView *)keyboard didClickButton:(UIButton *)textBtn withFieldString:(NSMutableString *)string
{
    _idCardNumberSelfDefine.text = string;
    NSLog(@"defined keyboard button clicked");
}

#pragma mark - submit button event
- (void)onSubmitBtnClicked
{
    NSLog(@"cardnumber system modify: %@", _idCardNumberSystemModify.text);
    NSLog(@"cardnumber self define: %@", _idCardNumberSelfDefine.text);
    [self.idCardNumberSystemModify resignFirstResponder];
    [self.idCardNumberSelfDefine resignFirstResponder];
}

@end
