//
//  LZGamingViewController.m
//  QuizGame
//
//  Created by liu miao on 2/1/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZGamingViewController.h"
#import "SHKFacebook.h"
#import "SHKTwitter.h"
#import <QuartzCore/QuartzCore.h>
#import "LZSoundManager.h"
#import "LZTapjoyHelper.h"


#define kLockPakStartIndex 2
#define kTotalOptionCount 3
#define kSelectedAnswerInterval 0.5
#define kDirectAnswerInterval 1.0
#define kSwitchNextQuestionInterval 0.5
#define kDirectWinCost 5
#define kDirectWinConstDelta -5
#define kCutWrongCost 2
#define kCutWrongCostDelta -2
#define kAskAlertTag 22
@interface LZGamingViewController ()<LZPlayViewDelegate,UIAlertViewDelegate>
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
@synthesize currentGroupKey;
@synthesize currentPackageKey;
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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"package_bg@2x" ofType:@"jpg"];
    [self.controllerBackImageView setImage:[UIImage imageWithContentsOfFile:path]];
    playView1 = [[LZPlayView alloc]initWithFrame:playFrame];
    playView1.delegate = self;
    
    playView2 = [[LZPlayView alloc]initWithFrame:playFrame];
    playView2.delegate = self;
    
    self.currentOptionArray = [[NSMutableArray alloc]initWithCapacity:1+kTotalOptionCount];
    self.quizArray = [[LZDataAccess singleton] getGroupQuizzes:currentGroupKey];
    NSLog(@"quizArray %@",[self.quizArray description]);

    totalQuizCount = [self.quizArray count];
    [self initializeOrderArray:totalQuizCount];
    [self displayGameView:currentQuizIndex];
    self.rightIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kAnswerButtonSideLength, kAnswerButtonSideLength)];
    [self.rightIconImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"selected_right@2x" ofType:@"png"]]];
    self.rightIconImageView.contentMode = UIViewContentModeScaleToFill;
    self.wrongIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kAnswerButtonSideLength, kAnswerButtonSideLength)];
    [self.wrongIconImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"selected_wrong@2x" ofType:@"png"]]];
    self.wrongIconImageView.contentMode = UIViewContentModeScaleToFill;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"LZGamingViewController viewWillAppear enter");
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:@"IAPHelperProductPurchasedNotification" object:nil];
    
//    if (! [[NSUserDefaults standardUserDefaults]boolForKey:@"LZAdsOff"]){
//        [[LZTapjoyHelper singleton] showFullScreenAd];
//        //[[LZTapjoyHelper singleton]showFullScreenAdWithViewController : self];
//    }
}
- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"LZGamingViewController viewWillDisappear enter");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
//    if (! [[NSUserDefaults standardUserDefaults]boolForKey:@"LZAdsOff"]){
//        [[LZTapjoyHelper singleton] showFullScreenAd];
//        //[[LZTapjoyHelper singleton]showFullScreenAdWithViewController : self];
//    }
}
- (void)productPurchased:(NSNotification *)notification
{
    NSString * productIdentifier = notification.object;
    NSLog(@"purchased product %@",productIdentifier);
    /*1 user purchased remove ads
     */
    [self refreshGold];
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
            NSString *pic = [[option objectAtIndex:i] objectForKey:@"answerPic"];
            [self.currentOptionArray addObject:pic];
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
            self.playView1.progressLabel.text = [NSString stringWithFormat:@"%d/%d",currentQuizIndex+1,totalQuizCount];
            self.playView1.questionLabel.text = [self getQuetionStringForString:[quiz objectForKey:@"questionWord"]];
            CGSize descriptionSize = [self.playView1.questionLabel.text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:33]constrainedToSize:CGSizeMake(250, 9999) lineBreakMode:UILineBreakModeWordWrap];
            self.playView1.questionLabel.frame = CGRectMake(self.playView1.progressLabel.frame.origin.x,self.playView1.progressLabel.frame.origin.y+self.playView1.progressLabel.frame.size.height + 5, descriptionSize.width, descriptionSize.height);
            self.playView1.questionLabel.lineBreakMode = UILineBreakModeWordWrap;
            UIButton *helpButton = (UIButton*)[self.playView1 viewWithTag:kCutWrongButtonTag];
            [helpButton setEnabled:YES];
            for (int i=0;i<[self.currentOptionArray count];i++)
            {
                NSString *optionPic = [self.currentOptionArray objectAtIndex:i];
                UIImage *iconImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/quizicons/%@",[[NSBundle mainBundle] bundlePath],optionPic]];
                UIButton *answerButton = (UIButton*)[playView1 viewWithTag:200+i];
                [answerButton setBackgroundImage:iconImage forState:UIControlStateNormal];
                answerButton.hidden = NO;
            }
            
        }
        else//set play2
        {
            self.playView2.progressLabel.text = [NSString stringWithFormat:@"%d/%d",currentQuizIndex+1,totalQuizCount];
            self.playView2.questionLabel.text = [self getQuetionStringForString:[quiz objectForKey:@"questionWord"]];
            CGSize descriptionSize = [self.playView2.questionLabel.text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:33]constrainedToSize:CGSizeMake(250, 9999) lineBreakMode:UILineBreakModeWordWrap];
            self.playView2.questionLabel.frame = CGRectMake(self.playView2.progressLabel.frame.origin.x,self.playView2.progressLabel.frame.origin.y+self.playView2.progressLabel.frame.size.height + 5, descriptionSize.width, descriptionSize.height);
            self.playView2.questionLabel.lineBreakMode = UILineBreakModeWordWrap;
            UIButton *helpButton = (UIButton*)[self.playView2 viewWithTag:kCutWrongButtonTag];
            [helpButton setEnabled:YES];
            for (int i=0;i<[self.currentOptionArray count];i++)
            {
                NSString *optionPic = [self.currentOptionArray objectAtIndex:i];
                UIImage *iconImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/quizicons/%@",[[NSBundle mainBundle] bundlePath],optionPic]];
                UIButton *answerButton = (UIButton*)[playView2 viewWithTag:200+i];
                [answerButton setBackgroundImage:iconImage forState:UIControlStateNormal];
                answerButton.hidden = NO;

            }
        }
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:kSwitchNextQuestionInterval];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
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
- (void)animationDidStop:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context
{
    [self.playView1 setUserInteractionEnabled:YES];
    [self.playView2 setUserInteractionEnabled:YES];
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
            NSDictionary *userInfo = [[LZDataAccess singleton]getUserTotalScore];
            int userGold = [[userInfo objectForKey:@"totalCoin"] integerValue];
            if (userGold < kDirectWinCost)
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Not Enough Coin" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                return;
            }
            [[LZDataAccess singleton]updateUserTotalCoinByDelta:kDirectWinConstDelta];
            NSNumber *current= [self.orderArray objectAtIndex:currentQuizIndex];
            NSDictionary *quiz = [self.quizArray objectAtIndex:[current integerValue]];
            NSString *answerPic = [quiz objectForKey:@"answerPic"];
            for(int i = 0 ;i<[self.currentOptionArray count];i++)
            {
                NSString *aOption = [self.currentOptionArray objectAtIndex:i];
                if ([aOption isEqualToString:answerPic])
                {
                    if (currentQuizIndex%2 == 0)//set play1
                    {
                        UIButton *button = (UIButton*)[self.playView1 viewWithTag:200+i];
                        [self.playView1 addSubview:self.rightIconImageView];
                        rightIconImageView.center = button.center;
                    }
                    else
                    {
                        UIButton *button = (UIButton *)[self.playView2 viewWithTag:200+i];
                        [self.playView2 addSubview:self.rightIconImageView];
                        rightIconImageView.center = button.center;
                        
                    }
                break;

                }
            }
            answeredRightCount++;
            [[LZSoundManager SharedInstance]playCorrectSound];
            NSString *quizkey = [quiz objectForKey:@"quizkey"];

            NSDictionary *updateResult = [[LZDataAccess singleton]obtainQuizAward:quizkey];
            NSLog(@"%@",updateResult);
            NSDictionary *newUserInfo = [[LZDataAccess singleton]getUserTotalScore];
            int newUserGold = [[newUserInfo objectForKey:@"totalCoin"] integerValue];
            self.topNavView.goldCountLabel.text = [NSString stringWithFormat:@"%d",newUserGold];
            NSLog(@"%@",updateResult);
            self.topNavView.correctCountLabel.text = [NSString stringWithFormat:@"%d",answeredRightCount];
            self.topNavView.correctCountLabel.text = [NSString stringWithFormat:@"%d",answeredRightCount];
            [self.playView1 setUserInteractionEnabled:NO];
            [self.playView2 setUserInteractionEnabled:NO];
            [self performSelector:@selector(displayNext) withObject:nil afterDelay:kDirectAnswerInterval];

        }
        if(tag == kCutWrongButtonTag)
        {
            NSDictionary *userInfo = [[LZDataAccess singleton]getUserTotalScore];
            int userGold = [[userInfo objectForKey:@"totalCoin"] integerValue];
            if (userGold < kCutWrongCost)
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Not Enough Coin" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                return;
            }
            [[LZDataAccess singleton]updateUserTotalCoinByDelta:kCutWrongCostDelta];
            NSDictionary *newUserInfo = [[LZDataAccess singleton]getUserTotalScore];
            int newUserGold = [[newUserInfo objectForKey:@"totalCoin"] integerValue];
            self.topNavView.goldCountLabel.text = [NSString stringWithFormat:@"%d",newUserGold];
            int remainOption = rand()%kTotalOptionCount;
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
            NSString *remainOptionKey = [[option objectAtIndex:remainOption] objectForKey:@"answerPic"];
            for(int i = 0 ;i<[self.currentOptionArray count];i++)
            {
                NSString *aOption = [self.currentOptionArray objectAtIndex:i];
                if (![aOption isEqualToString:right]&&![aOption isEqualToString:remainOptionKey])
                {
                    if (currentQuizIndex%2 == 0)//set play1
                    {
                        UIButton *button = (UIButton*)[self.playView1 viewWithTag:200+i];
                        button.hidden = YES;
                    }
                    else
                    {
                        UIButton *button = (UIButton *)[self.playView2 viewWithTag:200+i];
                        button.hidden = YES;
                    }
                    
                }
            }

        }
        if(tag == kAskFriendsButtonTag)
        {
//            UIImage *questionImage = [self imageFromView:self.view atFrame:[[UIScreen mainScreen] bounds]];
//            SHKItem *item = [SHKItem image:questionImage title:@"Any one know the answer?"];
//            
//            // Get the ShareKit action sheet
//            SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
//            
//            // ShareKit detects top view controller (the one intended to present ShareKit UI) automatically,
//            // but sometimes it may not find one. To be safe, set it explicitly
//            [SHK setRootViewController:self];
//            
//            // Display the action sheet
//            [actionSheet showInView:self.view];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Ask Friends" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Facebook",@"Twitter", nil];
            alert.tag = kAskAlertTag;
            [alert show];
           
            
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
        NSString *answerPic = [quiz objectForKey:@"answerPic"];
        if([selectedPic isEqualToString:answerPic])
        {
            [[LZSoundManager SharedInstance]playCorrectSound];
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
            answeredRightCount++;
            NSString *quizkey = [quiz objectForKey:@"quizkey"];
            NSDictionary *updateResult = [[LZDataAccess singleton]obtainQuizAward:quizkey];
            NSDictionary *userInfo = [[LZDataAccess singleton]getUserTotalScore];
            int userGold = [[userInfo objectForKey:@"totalCoin"] integerValue];
            self.topNavView.goldCountLabel.text = [NSString stringWithFormat:@"%d",userGold];
            NSLog(@"%@",updateResult);
            self.topNavView.correctCountLabel.text = [NSString stringWithFormat:@"%d",answeredRightCount];
        }
        else
        {
            [[LZSoundManager SharedInstance]playWrongSound];
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
            answeredWrongCount++;
            self.topNavView.wrongCountLabel.text = [NSString stringWithFormat:@"%d",answeredWrongCount];
        }
        [self.playView1 setUserInteractionEnabled:NO];
        [self.playView2 setUserInteractionEnabled:NO];
        [self performSelector:@selector(displayNext) withObject:nil afterDelay:kSelectedAnswerInterval];
    }
}
- (void)displayNext
{

    if (currentQuizIndex == totalQuizCount-1)//unswered last quiz
    {
        //display end view then get back to the group list view
        //lock or not lock the next level or next package
        [[LZDataAccess singleton] updateGroupScoreAndRightQuizAmount:self.currentGroupKey andScore:answeredRightCount*100 andRightQuizAmount:answeredRightCount];
        NSArray *groupArray = [[LZDataAccess singleton]getPackageGroups:self.currentPackageKey];
        int groupIndex;
        int passRate;
        NSString *unlockKey;
        for (NSDictionary * group in groupArray)
        {
            if ([[group objectForKey:@"grpkey"]isEqualToString:self.currentGroupKey])
            {
                groupIndex = [groupArray indexOfObject:group];
                passRate = [[group objectForKey:@"passRate"] integerValue];
                break;
            }
        }
        if (answeredRightCount >= passRate)//pass this group
        {
            if (groupIndex == [groupArray count]-1)//last group in this package
            {
                //unlock next package
                NSArray *packageArray = [[LZDataAccess singleton]getPackages];
                int packageIndex;
                for (NSDictionary * package in packageArray)
                {
                    if ([[package objectForKey:@"name"]isEqualToString:self.currentPackageKey])
                    {
                        packageIndex = [packageArray indexOfObject:package];
                        break;
                    }
                }
                if (packageIndex < kLockPakStartIndex)//special package need all package before unlocked
                {
                    if ([self didAllPackPassedBeforeIndex:kLockPakStartIndex])//all before package passed
                    {
                        [self unlockPackage:kLockPakStartIndex];
                    }
                    else//some package before still not passed
                    {
                        NSString *message = [NSString stringWithFormat:@"total quiz : %d  right : %d  wrong : %d",totalQuizCount,answeredRightCount,answeredWrongCount];
                        UIAlertView *endAlert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [endAlert show];
                    }
                }
                else//normal package case
                {
                    if (packageIndex < [packageArray count]-1)
                    {
                        [self unlockPackage:packageIndex+1];
                    }
                    else if (packageIndex == [packageArray count]-1)
                    {
                        //finished all games!!!!
                        NSString *message = [NSString stringWithFormat:@"total quiz : %d  right : %d  wrong : %d",totalQuizCount,answeredRightCount,answeredWrongCount];
                        NSString *title = @"You finished all the quiz!";
                        UIAlertView *endAlert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [endAlert show];

                    }
                }

            }
            else if (groupIndex < [groupArray count]-1) //not last group in this package
            {
                //unlock next group
                NSDictionary *unlockGroup = [groupArray objectAtIndex:groupIndex+1];
                int lockstate = [[unlockGroup objectForKey:@"locked"]integerValue];
                if (lockstate == 1) //next group not unlocked
                {
                    unlockKey = [unlockGroup objectForKey:@"grpkey"];
                    [[LZDataAccess singleton]updateGroupLockState:unlockKey andLocked:0];
                    NSString *message = [NSString stringWithFormat:@"total quiz : %d  right : %d  wrong : %d",totalQuizCount,answeredRightCount,answeredWrongCount];
                    NSString *title = [NSString stringWithFormat:@"group %d unlocked!",groupIndex+2];
                    UIAlertView *endAlert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [endAlert show];
                }
                else // next group already unlocked
                {
                    NSString *message = [NSString stringWithFormat:@"total quiz : %d  right : %d  wrong : %d",totalQuizCount,answeredRightCount,answeredWrongCount];
                    //NSString *title = [NSString stringWithFormat:@"package %@ unlocked!",unlockKey];
                    UIAlertView *endAlert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [endAlert show];
                }
            }

        }
        else //not pass this group
        {
            NSString *message = [NSString stringWithFormat:@"total quiz : %d  right : %d  wrong : %d",totalQuizCount,answeredRightCount,answeredWrongCount];
            //NSString *title = [NSString stringWithFormat:@"package %@ unlocked!",unlockKey];
            UIAlertView *endAlert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [endAlert show];
 
        }
    }
    else if(currentQuizIndex < totalQuizCount-1)
    {
        currentQuizIndex++;
        [self displayGameView:currentQuizIndex];
    }

}
-(BOOL)didAllPackPassedBeforeIndex:(int)packageIndex
{
    NSArray *packageArray = [[LZDataAccess singleton]getPackagesInfoForPass];
    BOOL passed = YES;
    for(int i= 0;i<packageIndex;i++)
    {
        NSDictionary *aPackage = [packageArray objectAtIndex:i];
        int lockstate = [[aPackage objectForKey:@"passed"]integerValue];
        if (lockstate == 0)
        {
            passed = NO;
            break;
        }
    }
    return passed;
}
-(void)unlockPackage:(int)packageIndex
{
    NSArray *packageArray = [[LZDataAccess singleton]getPackages];
    NSDictionary *unlockPackage = [packageArray objectAtIndex:packageIndex];
    int lockstate = [[unlockPackage objectForKey:@"locked"]integerValue];
    if (lockstate == 1)
    {
       NSString* unlockKey = [unlockPackage objectForKey:@"name"];
        [[LZDataAccess singleton]updatePackageLockState:unlockKey andLocked:0];
        NSString *message = [NSString stringWithFormat:@"total quiz : %d  right : %d  wrong : %d",totalQuizCount,answeredRightCount,answeredWrongCount];
        NSString *title = [NSString stringWithFormat:@"package %@ unlocked!",unlockKey];
        UIAlertView *endAlert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [endAlert show];  
    }
    else
    {
        NSString *message = [NSString stringWithFormat:@"total quiz : %d  right : %d  wrong : %d",totalQuizCount,answeredRightCount,answeredWrongCount];
        UIAlertView *endAlert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [endAlert show];
    }

}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kAskAlertTag)
    {
        if (buttonIndex == 1)
        {
            UIImage *questionImage = [self imageFromView:self.view atFrame:[[UIScreen mainScreen] bounds]];
            SHKItem *item = [SHKItem image:questionImage title:@"Any one know the answer?"];
            [SHKFacebook shareItem:item];
        }
        else if (buttonIndex == 2)
        {
            UIImage *questionImage = [self imageFromView:self.view atFrame:[[UIScreen mainScreen] bounds]];
            SHKItem *item = [SHKItem image:questionImage title:@"Any one know the answer?"];
            [SHKTwitter shareItem:item];
        }
    }
    else if (buttonIndex == alertView.cancelButtonIndex)
    {
        [self backButtonTapped];
    }

}
- (NSString *)getQuetionStringForString:(NSString *)originStr
{
    int length = [originStr length];
    int sum = 0;
    for (int i = 0;i< length;i++)
    {
        unichar c = [originStr characterAtIndex:i];
        //        NSLog(@"%d",c);
        sum += c;
    }
    //    NSLog(@"sum %d",sum);
    int index = sum % length;
    //    NSLog(@"index %d",index);
    unichar c = [originStr characterAtIndex:index];
    if(c == 32)
    {
        index--;
    };
    NSMutableString *questionString = [NSMutableString stringWithString:originStr];
    NSRange range = NSMakeRange(index, 1);
    [questionString replaceCharactersInRange:range withString:@"?"];
    return questionString;
}
- (UIImage *)imageFromView: (UIView *) theView   atFrame:(CGRect)r
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  theImage;//[self getImageAreaFromImage:theImage atFrame:r];
}
@end
