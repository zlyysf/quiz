//
//  LZGamingViewController.m
//  QuizGame
//
//  Created by liu miao on 2/1/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZGamingViewController.h"
#import <QuartzCore/QuartzCore.h>
#define kTotalOptionCount 3
@interface LZGamingViewController ()<LZPlayViewDelegate>
@property(nonatomic,strong)NSArray *quizArray;
@property(nonatomic,assign)int currentQuizIndex;
@property(nonatomic,assign)int totalQuizCount;
@property(nonatomic,assign)int answeredRightCount;
@property(nonatomic,assign)int answeredWrongCount;
@property(nonatomic,strong)NSMutableArray *orderArray;
@property(nonatomic,strong)NSMutableArray *currentOptionArray;
@property(nonatomic,strong)UIImageView *rightIconImageView;
@property(nonatomic,strong)UIImageView *wrongIconImageView;
@end

@implementation LZGamingViewController
@synthesize playView1;
@synthesize playView2;
@synthesize quizArray;
@synthesize currentQuizIndex;
@synthesize totalQuizCount;
@synthesize answeredRightCount;
@synthesize answeredWrongCount;
@synthesize orderArray;
@synthesize currentOptionArray;
@synthesize rightIconImageView;
@synthesize wrongIconImageView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.topNavView.topNavType = TopNavTypeGaming;
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    CGRect playFrame = CGRectMake(0, self.topNavView.frame.origin.y+self.topNavView.frame.size.height, screenSize.width, screenSize.height-self.topNavView.frame.size.height-50);
    currentQuizIndex = 0;
    answeredWrongCount = 0;
    answeredRightCount = 0;
    playView1 = [[LZPlayView alloc]initWithFrame:playFrame];
    playView1.delegate = self;
    
    playView2 = [[LZPlayView alloc]initWithFrame:playFrame];
    playView2.delegate = self;
    self.currentOptionArray = [[NSMutableArray alloc]initWithCapacity:1+kTotalOptionCount];
    NSArray *option1 = [[NSArray alloc]initWithObjects:@"icon_2.jpg",@"icon_3.jpg",@"icon_4.jpg", nil];
    NSDictionary *quiz1 = [[NSDictionary alloc]initWithObjectsAndKeys:@"松子",@"questionWord", @"icon_1.jpg",@"answerPic",option1,@"options", nil];
    NSArray *option2 = [[NSArray alloc]initWithObjects:@"icon_1.jpg",@"icon_3.jpg",@"icon_4.jpg", nil];
    NSDictionary *quiz2 = [[NSDictionary alloc]initWithObjectsAndKeys:@"阿迪达斯",@"questionWord",@"icon_2.jpg",@"answerPic",option2,@"options", nil];
    NSArray *option3 = [[NSArray alloc]initWithObjects:@"icon_2.jpg",@"icon_1.jpg",@"icon_4.jpg", nil];
    NSDictionary *quiz3 = [[NSDictionary alloc]initWithObjectsAndKeys:@"老鹰",@"questionWord", @"icon_3.jpg",@"answerPic",option3,@"options",nil];
    NSArray *option4 = [[NSArray alloc]initWithObjects:@"icon_2.jpg",@"icon_3.jpg",@"icon_1.jpg", nil];
    NSDictionary *quiz4 = [[NSDictionary alloc]initWithObjectsAndKeys:@"柠檬",@"questionWord", @"icon_4.jpg",@"answerPic",option4,@"options",nil];
    self.quizArray = [[NSArray alloc]initWithObjects:quiz1,quiz2,quiz3, quiz4,nil];
    NSLog(@"quizArray %@",[self.quizArray description]);
    //-(FMResultSet *) getGroupQuiz:(NSString *)grpkey;
    totalQuizCount = [self.quizArray count];
    [self initializeOrderArray:totalQuizCount];
    [self displayGameView:currentQuizIndex];
    self.rightIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kAnswerButtonSideLength, kAnswerButtonSideLength)];
    [self.rightIconImageView setImage:[UIImage imageNamed:@"correct.png"]];
    self.wrongIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kAnswerButtonSideLength, kAnswerButtonSideLength)];
    [self.wrongIconImageView setImage:[UIImage imageNamed:@"wrong.png"]];
    
    
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initializeOrderArray:(int)length
{
    if (length <= 0)
    {
        return;
    }
    self.orderArray = [[NSMutableArray alloc]initWithCapacity:length];
    for (int i=0; i<length; i++)
    {
        [self.orderArray insertObject:[NSNumber numberWithInt:i] atIndex:i];

    }
    NSLog(@"orderArray %@",[self.orderArray description]);
    for(int i=1;i<length;i++)
    {
        int j=rand()%(i+1);
        [self.orderArray exchangeObjectAtIndex:j withObjectAtIndex:i];;
    }
    NSLog(@"orderArray %@",[self.orderArray description]);
}
/*
 乱序洗牌
 void swap(int& a,int& b)
 {
 int temp=b;
 b=a;
 a=temp;
 }
 
 void randomShuffle(int array[], int len)
 {
 
 for(int i=1;i<len;i++)
 {
 int j=rand()%(i+1);
 swap(array[i],array[j]);
 }
 }

 */
-(void)displayGameView:(int)index
{
    if (index >=0 && index <[self.orderArray count])
    {
        NSNumber *current= [self.orderArray objectAtIndex:index];
        NSDictionary *quiz = [self.quizArray objectAtIndex:[current integerValue]];
        NSLog(@"quiz content %@",quiz);
        NSString *answerPic = [quiz objectForKey:@"answerPic"];
        NSArray *option = [quiz objectForKey:@"options"];
        [self.currentOptionArray removeAllObjects];
        [self.currentOptionArray insertObject:answerPic atIndex:0];
        
        for (int i=0; i<kTotalOptionCount; i++)
        {
            NSString *pic = [option objectAtIndex:i];
            [self.currentOptionArray addObject:pic];
            //[self.currentOptionArray addObject:pic];
        }
        NSLog(@"before random currentOptionArray %@",[self.currentOptionArray description]);
        for(int i=1;i<[self.currentOptionArray count];i++)
        {
            int j=rand()%(i+1);
            [self.currentOptionArray exchangeObjectAtIndex:j withObjectAtIndex:i];;
        }
        NSLog(@"after random currentOptionArray %@",[self.currentOptionArray description]);
        if (self.rightIconImageView.superview) {
            [self.rightIconImageView removeFromSuperview];
            
        }
        if (self.wrongIconImageView.superview)
        {
            [self.wrongIconImageView removeFromSuperview];
        }
        if (index%2 == 0)//set play1
        {
            //[self setPlayViewContent:playView1];
            self.playView1.progressLabel.text = [NSString stringWithFormat:@"%d / %d",currentQuizIndex+1,totalQuizCount];
            self.playView1.questionLabel.text = [quiz objectForKey:@"questionWord"];
            UIButton *helpButton = (UIButton*)[self.playView1 viewWithTag:kCutWrongButtonTag];
            [helpButton setEnabled:YES];
            for (int i=0;i<[self.currentOptionArray count];i++)
            {
                NSString *optionPic = [self.currentOptionArray objectAtIndex:i];
                //[[NSBundle mainBundle] bundlePath]
                UIImage *iconImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",optionPic]];
                UIButton *answerButton = (UIButton*)[playView1 viewWithTag:200+i];
                [answerButton setBackgroundImage:iconImage forState:UIControlStateNormal];
                answerButton.hidden = NO;
            }
            
        }
        else//set play2
        {
            self.playView2.progressLabel.text = [NSString stringWithFormat:@"%d / %d",currentQuizIndex+1,totalQuizCount];
            self.playView2.questionLabel.text = [quiz objectForKey:@"questionWord"];
            UIButton *helpButton = (UIButton*)[self.playView2 viewWithTag:kCutWrongButtonTag];
            [helpButton setEnabled:YES];
            
            for (int i=0;i<[self.currentOptionArray count];i++)
            {
                NSString *optionPic = [self.currentOptionArray objectAtIndex:i];
                //[[NSBundle mainBundle] bundlePath]
                UIImage *iconImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",optionPic]];
                UIButton *answerButton = (UIButton*)[playView2 viewWithTag:200+i];
                [answerButton setBackgroundImage:iconImage forState:UIControlStateNormal];
                answerButton.hidden = NO;

            }
        }
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
        if (index%2 == 0) {
            [playView2 removeFromSuperview];
            [self.view addSubview:playView1];
        }
        else
        {
            [playView1 removeFromSuperview];
            [self.view addSubview:playView2];
        }
        [UIView commitAnimations];

    }
}

#pragma -mark LZPlay View Delegate
- (void)playViewButtonClicked:(UIButton*)button
{
    /*case1 help button
     1.direct win same to case 2 right answer kWinButtonTag
     2.cut two wrong answer kCutWrongButtonTag
     3.facebook/ twitter kAskFriendsButtonTag
     UI update
    */

    int tag = button.tag;
    if (tag == kWinButtonTag || tag == kCutWrongButtonTag || tag == kAskFriendsButtonTag)
    {
        if(tag == kWinButtonTag)
        {
            NSString *message = [NSString stringWithFormat:@"正确 tapped button tag %d",button.tag];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            answeredRightCount++;
            self.topNavView.correctCountLabel.text = [NSString stringWithFormat:@"%d",answeredRightCount];
            /*reach the answer the last question*/
            if (currentQuizIndex == totalQuizCount-1)
            {
                //display end view then get back to the group list view
                //lock or not lock the next level or next package
            }

            else if(currentQuizIndex < totalQuizCount-1)
            {
                currentQuizIndex++;
                [self displayGameView:currentQuizIndex];
            }
        }
        if(tag == kCutWrongButtonTag)
        {
            
            int remainOption = rand()%kTotalOptionCount;
            //NSNumber *current= [self.orderArray objectAtIndex:index];
            NSNumber *current= [self.orderArray objectAtIndex:currentQuizIndex];
            NSDictionary *quiz = [self.quizArray objectAtIndex:[current integerValue]];
            if (currentQuizIndex%2 == 0)
            {
                UIButton *helpButton = (UIButton*)[self.playView1 viewWithTag:kCutWrongButtonTag];
                [helpButton setEnabled:NO];
            }
            else{
                UIButton *helpButton = (UIButton*)[self.playView2 viewWithTag:kCutWrongButtonTag];
                [helpButton setEnabled:NO];

            }
            NSString *right = [quiz objectForKey:@"answerPic"];
            NSArray *option = [quiz objectForKey:@"options"];
            NSString *remainOptionKey = [option objectAtIndex:remainOption];
            for(int i = 0 ;i<[self.currentOptionArray count];i++)
            {
                NSString *aOption = [self.currentOptionArray objectAtIndex:i];
                if (![aOption isEqualToString:right]&&![aOption isEqualToString:remainOptionKey])
                {
                    if (currentQuizIndex%2 == 0)//set play1
                    {
                        UIButton *button = (UIButton*)[self.playView1 viewWithTag:200+i];
                        //[self.playView1 viewWithTag:kCutWrongButtonTag]
                        button.hidden = YES;
                    }
                    else
                    {
                        UIButton *button = (UIButton *)[self.playView2 viewWithTag:200+i];
                        button.hidden = YES;
                    }
                    
                }
            }
            //[self.currentOptionArray removeAllObjects];

        }
        if(tag == kAskFriendsButtonTag)
        {
            
        }
    }
    else
    {
    
    /*case2 select an answer kAnswerUp(Down)Left(Right)ButtonTag
     1.right answer
     2.wrong answer
     update gold quiz answerright
     topbar progress
     */
        int selected = tag-200;
        NSString *selectedPic = [self.currentOptionArray objectAtIndex:selected];
        NSNumber *current= [self.orderArray objectAtIndex:currentQuizIndex];
        NSDictionary *quiz = [self.quizArray objectAtIndex:[current integerValue]];
        //NSLog(@"quiz content %@",quiz);
        NSString *answerPic = [quiz objectForKey:@"answerPic"];
        if([selectedPic isEqualToString:answerPic])
        {
            NSString *message = [NSString stringWithFormat:@"正确 tapped button tag %d",button.tag];
            if (currentQuizIndex%2 == 0)//set play1
            {
                UIButton *button = (UIButton*)[self.playView1 viewWithTag:tag];
                //[self.playView1 viewWithTag:kCutWrongButtonTag]
                [self.playView1 addSubview:self.rightIconImageView];
                rightIconImageView.center = button.center;
            }
            else
            {
                UIButton *button = (UIButton *)[self.playView2 viewWithTag:tag];
                [self.playView2 addSubview:self.rightIconImageView];
                rightIconImageView.center = button.center;
                
            }

            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            answeredRightCount++;
            self.topNavView.correctCountLabel.text = [NSString stringWithFormat:@"%d",answeredRightCount];
        }
        else
        {
            NSString *message = [NSString stringWithFormat:@"错误 tapped button tag %d",button.tag];
            if (currentQuizIndex%2 == 0)//set play1
            {
                UIButton *button = (UIButton*)[self.playView1 viewWithTag:tag];
                //[self.playView1 viewWithTag:kCutWrongButtonTag]
                [self.playView1 addSubview:self.wrongIconImageView];
                wrongIconImageView.center = button.center;
            }
            else
            {
                UIButton *button = (UIButton *)[self.playView2 viewWithTag:tag];
                [self.playView2 addSubview:self.wrongIconImageView];
                wrongIconImageView.center = button.center;
                
            }
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            answeredWrongCount++;
            self.topNavView.wrongCountLabel.text = [NSString stringWithFormat:@"%d",answeredWrongCount];
        }
        /*reach the answer the last question*/
        [self performSelector:@selector(displayNext) withObject:nil afterDelay:0.5];
    }
}
- (void)displayNext
{
    if (currentQuizIndex == totalQuizCount-1)
    {
        //display end view then get back to the group list view
        //lock or not lock the next level or next package
    }
    else if(currentQuizIndex < totalQuizCount-1)
    {
        currentQuizIndex++;
        [self displayGameView:currentQuizIndex];
    }

}

@end
