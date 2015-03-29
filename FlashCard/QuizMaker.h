//
//  QuizMaker.h
//  FlashCard
//
//  Created by Rikin Desai on 7/5/14.
//  Copyright (c) 2014 Rikin. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface QuizMaker

-(IBAction) newQuizMaker: (UIButton *)sender;
-(IBAction) unwindToQuizMaker: (UIStoryboardSegue *)segue;
@property (nonatomic, weak) IBOutlet UIView *currentView
@property (nonatomic, weak) IBOutlet UILabel *infoLabel
@property (nonatomic, weak) IBOutlet UIButton *startNewQuiz

@end
