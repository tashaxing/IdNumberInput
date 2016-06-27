//
//  NumberKeyboardView.h
//  IdNumberInput
//
//  Created by yxhe on 16/5/9.
//  Copyright © 2016年 yxhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class NumberKeyboardView;

//the defined numberPad delegate
@protocol NumberKeyBoardViewDelegate<NSObject>

@optional
// delegate function to press keyboard button
- (void)keyboard:(NumberKeyboardView *)keyboard didClickButton:(UIButton *)textBtn withFieldString:(NSMutableString *)string;

@end


// numberPad view
@interface NumberKeyboardView:UIView

@property (nonatomic, assign) id<NumberKeyBoardViewDelegate> delegate;
@property (nonatomic, strong) NSMutableString *string; //the keyboard related string



@end
