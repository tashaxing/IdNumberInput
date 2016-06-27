//
//  NumberKeyboardView.m
//  IdNumberInput
//
//  Created by yxhe on 16/5/9.
//  Copyright © 2016年 yxhe. All rights reserved.
//

#import "NumberKeyboardView.h"
#import "UPViewController.h"

#define KEYBOARD_HEIGHT 216

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

@implementation NumberKeyboardView

//custom the view init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.frame = CGRectMake(0, SCREEN_SIZE.height - KEYBOARD_HEIGHT, SCREEN_SIZE.width, KEYBOARD_HEIGHT);
        self.string = [NSMutableString string];
        self.backgroundColor = [UIColor grayColor];
     
        //initialize the keyboard
        [self createButtons];
        
    }
    return self;
}

//add button to the defined keyboard view
- (UIButton *)addButtonWithTitle:(NSString *)title frame:(CGRect)frame_rect image:(UIImage *)normal_image highImage:(UIImage *)high_image
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame_rect];
//    button.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundImage:normal_image forState:UIControlStateNormal];
    [button setBackgroundImage:high_image forState:UIControlStateHighlighted];
    
    return button;
}

//create all the buttons
- (void)createButtons
{
    //set the key titles
    NSArray *titleArray = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"X", @"0", @"delete", nil];
    
    //design the keyboard
    int index = 0;
    float button_width = (SCREEN_SIZE.width - 30) / 3;
    float button_height = (KEYBOARD_HEIGHT - 40) / 4;
    
    
    for(int i = 0; i < 4; i++)
    {
        for(int j = 0; j < 3; j++)
        {
            float x = 5 + j*(button_width + 10);
            float y = 5 + i*(button_height + 10);
            
            UIButton *button = [self addButtonWithTitle:titleArray[index] frame:CGRectMake(x, y, button_width, button_height) image:nil highImage:[UIImage imageNamed:@"bgcolor.png"]];
            [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundColor:[UIColor whiteColor]];
            [self addSubview:button];
            
            //increase index
            index++;
        }
    }
    
}

//button callback
- (void)onClick:(UIButton *)button
{
    //respond to local button events
    if([button.currentTitle isEqualToString:@"delete"] && self.string > 0)
    {
        [self.string deleteCharactersInRange:NSMakeRange(self.string.length-1, 1)];
    }
    else
    {
        [self.string appendString:button.currentTitle];
    }
    
    //call the delegate, first make sure it can respond to selector, then do the delegate method
    if ([self.delegate respondsToSelector:@selector(keyboard:didClickButton:withFieldString:)])
    {
        [self.delegate keyboard:self didClickButton:button withFieldString:self.string];

    }
    
}

@end
