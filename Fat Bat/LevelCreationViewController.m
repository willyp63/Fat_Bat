//
//  LevelCreationViewController.m
//  Fat Bat
//
//  Created by Wil Pirino on 12/19/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import "LevelCreationViewController.h"

@implementation LevelCreationViewController{
    UITextView *_textView;
    NSString *_text;
}

-(id)initWithText:(NSString *)text{
    self = [super init];
    if(self){
        _text = text;
    }
    return  self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set bg color
    self.view.backgroundColor = [UIColor colorWithRed:UI_2_RED green:UI_2_GREEN blue:UI_2_BLUE alpha:1.0];
    
    //init text view with text
    _textView = [[UITextView alloc] initWithFrame:self.view.bounds textContainer:nil];
    _textView.autocorrectionType = UITextAutocorrectionTypeNo;
    _textView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _textView.backgroundColor = [UIColor colorWithRed:UI_2_RED green:UI_2_GREEN blue:UI_2_BLUE alpha:1.0];
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.textColor = [UIColor blackColor];
    _textView.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
    _textView.text = _text;
    _textView.delegate = self;
    [self.view addSubview:_textView];
    
    //listen for text view events
    [_textView becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardIsUp:) name:UIKeyboardDidShowNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //show navigation bar and set title
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Edit File";
    
    //configure navigation bar back button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"save" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
}

- (void)scrollToCaretInTextView:(UITextView *)textView animated:(BOOL)animated{
    //scroll text view to caret
    CGRect rect = [textView caretRectForPosition:textView.selectedTextRange.end];
    rect.size.height += textView.textContainerInset.bottom;
    [textView scrollRectToVisible:rect animated:animated];
}

- (void)keyboardIsUp:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    UIEdgeInsets inset = _textView.contentInset;
    inset.bottom = keyboardRect.size.height;
    _textView.contentInset = inset;
    _textView.scrollIndicatorInsets = inset;
    
    [self scrollToCaretInTextView:_textView animated:YES];
}

- (void)textViewDidChange:(UITextView *)textView{
    if ([textView.text hasSuffix:@"\n"]) {
        [CATransaction setCompletionBlock:^{
            [self scrollToCaretInTextView:textView animated:NO];
        }];
        
    } else {
        [self scrollToCaretInTextView:textView animated:NO];
    }
}

-(void)save{
    //get lines from text view
    NSArray *lines = [_textView.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    //get level name from first line
    NSString *levelName = lines[0];
    
    //copy remaining string
    NSString *levelFile = @"";
    for (int i = 1; i < lines.count; i++) {
        levelFile = [levelFile stringByAppendingString:lines[i]];
        
        //return if not the last line
        if (i < lines.count - 1) {levelFile = [levelFile stringByAppendingString:@"\r"];}
    }
    
    //get error message for level file
    NSString *message = [LevelFileHandler isValidLevelFile:levelFile];
    
    //check if there is no errors and level name is empty
    if ([message isEqualToString:@""] && levelName.length == 0) {
        message = @"invalid level name";
    }
    
    //check if there is no errors and level name contains spaces
    if ([message isEqualToString:@""] && [levelName containsString:@" "]) {
        message = @"level name contains spaces";
    }
    
    //check if there is no error
    if ([message isEqualToString:@""]) {
        
        
        //write level file
        [LevelFileHandler writeLevelFile:levelFile withName:levelName];
        
        //pop view controller
        [self.navigationController popViewControllerAnimated:YES];
    }
    //there was an error
    else{
        UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"ERROR" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            //dismiss alert view
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
