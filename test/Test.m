//
//  Test.m
//  test
//
//  Created by apple on 23/07/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "Test.h"

@interface Test ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constHeight;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property NSMutableArray *viewArray;
@end

@implementation Test

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    float x= 17;
    float y = 27;
    float width = 287;
    float height = 181;
    float mainview_height = 568;
    float x_spacer = 0;
    float y_spacer = 0;
    float width_spacer = 320;
    float height_spacer = 27;
    
    float falseY = 27;
    int numberOfSubViews = 1;
    
    //this is for calculating the whole height after adding the subviews to make the mainview bigger
    for (int k =0;k<numberOfSubViews;k++) {
        if (k == numberOfSubViews - 1) {
            falseY = falseY + height_spacer;
        }else{
            falseY = falseY + height + height_spacer;
        }
    }
    
    if (falseY + height > mainview_height) {
        mainview_height = falseY + height;
    }
    self.constHeight.constant = mainview_height;
    
    [self.mainView layoutIfNeeded];
    
    //we are doing those things after increasing height of main view because the constraints added will be taking aspect ratio of height of main view and we need to increase this main view before those constraints added.
    self.viewArray = [[NSMutableArray alloc]init];
    [self.scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.mainView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    for(int k =0;k<numberOfSubViews;k++)
    {
        UIView *view_spacer = [[UIView alloc]initWithFrame:CGRectMake(x_spacer, y_spacer, width_spacer, height_spacer)];
        [view_spacer setBackgroundColor:[UIColor clearColor]];
        [view_spacer setTranslatesAutoresizingMaskIntoConstraints: NO];
        [self.mainView addSubview:view_spacer];
        
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(x, y, width, height)];
        [view1 setBackgroundColor:[UIColor blueColor]];
        [view1 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.mainView addSubview:view1];
        [self.viewArray addObject:view1];
        if(k==0)
        {
            [self setSpaceViewConstraints:view_spacer :height_spacer :width_spacer :mainview_height:self.mainView];
        }
        else
        {
            UIView *previousView = [self.viewArray objectAtIndex:(k-1)];
            [self setViewConstraints:view_spacer :height_spacer :width_spacer :mainview_height :previousView :self.mainView];
        }
        [self setViewConstraints:view1 :height :width :mainview_height :view_spacer :self.mainView];
        
        //i changed like this because for the last item the height will not be added again. This will remove the space at the bottom.
        if (k == numberOfSubViews - 1) {
            y = y + height_spacer;
        }else{
            y = y + height + height_spacer;
        }
        y_spacer = y_spacer + height_spacer + height;
    }
    [self.mainView layoutIfNeeded];
    int final_height = y + height;
    NSLog(@"%f",y);
    
    [self.scrollView setContentSize:(CGSizeMake(self.scrollView.frame.size.width,final_height))];
}

-(void)setSpaceViewConstraints:(UIView *)view3 : (int)height : (int)width :(int)mainview_height : (UIView *)mainView1
{
    float view_ratio = (float)width/(float)height;
    float main_ratio = (float)width/(float)mainview_height;
    [view3 addConstraint:[NSLayoutConstraint constraintWithItem:view3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view3 attribute:NSLayoutAttributeHeight multiplier:view_ratio constant:0.0f]];
    [mainView1 addConstraint:[NSLayoutConstraint constraintWithItem:view3 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:mainView1 attribute:NSLayoutAttributeTop multiplier:1 constant:0.0f]];
    [mainView1 addConstraint:[NSLayoutConstraint constraintWithItem:view3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:mainView1 attribute:NSLayoutAttributeHeight multiplier:main_ratio constant:0.0f]];
    [mainView1 addConstraint:[NSLayoutConstraint constraintWithItem:view3 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:mainView1 attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}

-(void)setViewConstraints:(UIView *)view2 :(int)height :(int)width : (int)mainview_height : (UIView *) view_spacer2 : (UIView *)mainView2
{
    //[super updateViewConstraints];
    float view_ratio = (float)width/(float)height;
    float main_ratio = (float)width/(float)mainview_height;
    [mainView2 addConstraint:[NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view_spacer2 attribute:NSLayoutAttributeBottom multiplier:1 constant:0.0f]];
    [view2 addConstraint:[NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeHeight multiplier:view_ratio constant:0.0f]];
    [mainView2 addConstraint:[NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:mainView2 attribute:NSLayoutAttributeHeight multiplier:main_ratio constant:0.0f]];
    [mainView2 addConstraint:[NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:mainView2 attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
