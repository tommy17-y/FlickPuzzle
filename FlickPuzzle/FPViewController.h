//
//  FPViewController.h
//  FlickPuzzle
//
//  Created by Yuki Tomiyoshi on 2014/05/26.
//  Copyright (c) 2014年 yuki tomiyoshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FPViewController : UIViewController {
    IBOutletCollection(UIView) NSArray* panels;
    IBOutlet UIView *baseView;
    IBOutlet UILabel *scoreLabel;
    IBOutlet UILabel *gameoverLabel;
    IBOutlet UIButton *retryButton;
    
    float startX, startY;
    float endX, endY;
    int startTag;
    int score;
    int length;
    int totalPanel;
}

- (IBAction)tappedRetryButton;

@end
