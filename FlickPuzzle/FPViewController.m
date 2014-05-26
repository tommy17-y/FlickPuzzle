//
//  FPViewController.m
//  FlickPuzzle
//
//  Created by Yuki Tomiyoshi on 2014/05/26.
//  Copyright (c) 2014年 yuki tomiyoshi. All rights reserved.
//

#import "FPViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface FPViewController ()

@end

@implementation FPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    startX = 0;
    startY = 0;
    endX = 0;
    endY = 0;
    startTag = 0;
    score = 0;
    totalPanel = (int)[panels count];
    length = sqrt(totalPanel);
    
    retryButton.hidden = YES;
    gameoverLabel.hidden = YES;
    
    baseView.layer.cornerRadius = 5;
    baseView.clipsToBounds = true;
    
    [self initSetPanel];
}

- (void)initSetPanel {
    
    for (UIView* panel in panels) {
        [self changeColor:panel];
        panel.layer.cornerRadius = 5;
        panel.clipsToBounds = true;
        panel.userInteractionEnabled = YES;
    }
}

- (void)changeColor:(UIView*)panel {
    int rand = arc4random() % 5;
    
    if(rand == 0) {
        panel.backgroundColor = [UIColor redColor];
    } else if(rand == 1) {
        panel.backgroundColor = [UIColor blueColor];
    } else if(rand == 2) {
        panel.backgroundColor = [UIColor yellowColor];
    } else if(rand == 3) {
        panel.backgroundColor = [UIColor greenColor];
    } else if(rand == 4) {
        panel.backgroundColor = [UIColor orangeColor];
    }
    
    [self check];
}

- (BOOL)isEqualToColor:(UIView*)v1:(UIView*)v2 {
    CGFloat red1, green1, blue1, alpha1;
    CGFloat red2, green2, blue2, alpha2;
    
    [v1.backgroundColor getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
    [v2.backgroundColor getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
    
    if (red1 == red2 && green1 == green2 && blue1 == blue2) {
        return YES;
    } else {
        return NO;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    if (1 <= (int)touch.view.tag && (int)touch.view.tag <= totalPanel) {
        startTag = (int)touch.view.tag;
        CGPoint location = [touch locationInView:baseView];
        startX = location.x;
        startY = location.y;
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    if (1 <= startTag && startTag <= totalPanel) {
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:baseView];
        endX = location.x;
        endY = location.y;
        
        if (fabsf(endX - startX) > (fabsf(endY - startY))) {
            if ((endX - startX) > 0) {
                // 右フリック
                if(startTag % length != 0) {
                    UIView* view1 = [baseView viewWithTag:(startTag + 1)];
                    CGPoint point1 = view1.center;
                    UIView* view2 = [baseView viewWithTag:startTag];
                    CGPoint point2 = view2.center;
                    if ([self isEqualToColor:view1 :view2]) {
                        score++;

                        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            view2.center = point1;
                            
                        }completion:^(BOOL finished){
                            scoreLabel.text = [NSString stringWithFormat:@"スコア：%d", score];
                            view2.tag++;
                            view1.tag--;
                            view1.center = point2;
                            [self changeColor:view1];
                        }];
                    }
                    
                }
            } else {
                // 左フリック
                if(startTag % length != 1) {
                    UIView* view1 = [baseView viewWithTag:(startTag - 1)];
                    CGPoint point1 = view1.center;
                    UIView* view2 = [baseView viewWithTag:startTag];
                    CGPoint point2 = view2.center;
                    if ([self isEqualToColor:view1 :view2]) {
                        score++;
                        
                        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            view2.center = point1;
                            
                        }completion:^(BOOL finished){
                            scoreLabel.text = [NSString stringWithFormat:@"スコア：%d", score];
                            view2.tag--;
                            view1.tag++;
                            view1.center = point2;
                            [self changeColor:view1];
                        }];

                    }

                }
            }
            
        } else {
            if ((startY - endY) > 0) {
                // 上フリック
                if(startTag > length) {
                    UIView* view1 = [baseView viewWithTag:(startTag - length)];
                    CGPoint point1 = view1.center;
                    UIView* view2 = [baseView viewWithTag:startTag];
                    CGPoint point2 = view2.center;
                    if ([self isEqualToColor:view1 :view2]) {
                        score++;
                        
                        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            view2.center = point1;
                            
                        }completion:^(BOOL finished){
                            scoreLabel.text = [NSString stringWithFormat:@"スコア：%d", score];
                            view2.tag -= length;
                            view1.tag += length;
                            view1.center = point2;
                            [self changeColor:view1];
                        }];
                    }
                    
                }
            } else {
                // 下フリック
                if(startTag <= totalPanel - length) {
                    UIView* view1 = [baseView viewWithTag:(startTag + length)];
                    CGPoint point1 = view1.center;
                    UIView* view2 = [baseView viewWithTag:startTag];
                    CGPoint point2 = view2.center;
                    
                    if ([self isEqualToColor:view1 :view2]) {
                        score++;
                        
                        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            view2.center = point1;
                            
                        }completion:^(BOOL finished){
                            scoreLabel.text = [NSString stringWithFormat:@"スコア：%d", score];
                            view2.tag += length;
                            view1.tag -= length;
                            view1.center = point2;
                            [self changeColor:view1];
                        }];
                    }
                    
                }
            }
        }
    }
    
    startTag = 0;
    
}

- (void)checkGameOver {

}

- (void)check {

    for (UIView* panel in panels) {
        if (panel.tag <= length) {
            if (panel.tag % length == 1) {
                UIView* view1 = [baseView viewWithTag:(panel.tag + 1)];
                UIView* view2 = [baseView viewWithTag:(panel.tag + length)];
                if ([self isEqualToColor:panel :view1] || [self isEqualToColor:panel :view2]) {
                    return;
                }
            } else if (panel.tag % length == 0) {
                UIView* view1 = [baseView viewWithTag:(panel.tag - 1)];
                UIView* view2 = [baseView viewWithTag:(panel.tag + length)];
                if ([self isEqualToColor:panel :view1] || [self isEqualToColor:panel :view2]) {
                    return;
                }
            } else {
                UIView* view1 = [baseView viewWithTag:(panel.tag + 1)];
                UIView* view2 = [baseView viewWithTag:(panel.tag - 1)];
                UIView* view3 = [baseView viewWithTag:(panel.tag + length)];
                if ([self isEqualToColor:panel :view1] || [self isEqualToColor:panel :view2] || [self isEqualToColor:panel :view3]) {
                    return;
                }
            }
        } else if (panel.tag > totalPanel - length) {
            if (panel.tag % length == 1) {
                UIView* view1 = [baseView viewWithTag:(panel.tag + 1)];
                UIView* view2 = [baseView viewWithTag:(panel.tag - length)];
                if ([self isEqualToColor:panel :view1] || [self isEqualToColor:panel :view2]) {
                    return;
                }
            } else if (panel.tag % length == 0) {
                UIView* view1 = [baseView viewWithTag:(panel.tag - 1)];
                UIView* view2 = [baseView viewWithTag:(panel.tag - length)];
                if ([self isEqualToColor:panel :view1] || [self isEqualToColor:panel :view2]) {
                    return;
                }
            } else {
                UIView* view1 = [baseView viewWithTag:(panel.tag + 1)];
                UIView* view2 = [baseView viewWithTag:(panel.tag - 1)];
                UIView* view3 = [baseView viewWithTag:(panel.tag - length)];
                if ([self isEqualToColor:panel :view1] || [self isEqualToColor:panel :view2] || [self isEqualToColor:panel :view3]) {
                    return;
                }
            }
        } else {
            if (panel.tag % length == 1) {
                UIView* view1 = [baseView viewWithTag:(panel.tag + 1)];
                UIView* view2 = [baseView viewWithTag:(panel.tag - length)];
                UIView* view3 = [baseView viewWithTag:(panel.tag + length)];
                if ([self isEqualToColor:panel :view1] || [self isEqualToColor:panel :view2] || [self isEqualToColor:panel :view3]) {
                    return;
                }
            } else if (panel.tag % length == 0) {
                UIView* view1 = [baseView viewWithTag:(panel.tag - 1)];
                UIView* view2 = [baseView viewWithTag:(panel.tag - length)];
                UIView* view3 = [baseView viewWithTag:(panel.tag + length)];
                if ([self isEqualToColor:panel :view1] || [self isEqualToColor:panel :view2] || [self isEqualToColor:panel :view3]) {
                    return;
                }
            } else {
                UIView* view1 = [baseView viewWithTag:(panel.tag + 1)];
                UIView* view2 = [baseView viewWithTag:(panel.tag - 1)];
                UIView* view3 = [baseView viewWithTag:(panel.tag + length)];
                UIView* view4 = [baseView viewWithTag:(panel.tag - length)];
                if ([self isEqualToColor:panel :view1] || [self isEqualToColor:panel :view2] || [self isEqualToColor:panel :view3] || [self isEqualToColor:panel :view4]) {
                    return;
                }
            }
        }
    }
    
    retryButton.hidden = NO;
    gameoverLabel.hidden = NO;
    
    for (UIView* panel in panels) {
        panel.backgroundColor = [UIColor grayColor];
        panel.userInteractionEnabled = NO;
    }
    
}

- (IBAction)tappedRetryButton {
    retryButton.hidden = YES;
    gameoverLabel.hidden = YES;
    
    [self initSetPanel];
    
    score = 0;
    scoreLabel.text = [NSString stringWithFormat:@"スコア：%d", score];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
