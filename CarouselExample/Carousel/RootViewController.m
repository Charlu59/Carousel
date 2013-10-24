//
//  RootViewController.m
//  Carousel
//
//  Created by Charles-Hubert Basuiau on 23/10/13.
//  Copyright (c) 2013 Charles-Hubert Basuiau. All rights reserved.
//

#import "RootViewController.h"


@interface RootViewController () <UIScrollViewDelegate> {
}

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *footer = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5.0*self.view.frame.size.height/6.0, self.view.frame.size.width, self.view.frame.size.height/6.0)];
    [footer setImage:[UIImage imageNamed:@"logo-applinnov.png"]];
    [self.view addSubview:footer];

    myCarousel = [[Carousel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - footer.frame.size.height)];
    myCarousel.dataSource = self;
    myCarousel.delegate = self;
    [myCarousel setInifiniteLoop:YES];
    [myCarousel animateWithPeriod:3];
    [myCarousel setBackCoverflow:YES];
    [myCarousel setUserInteractionEnabled:NO];
    [myCarousel setInitialPage:5];
    [myCarousel show];
    [self.view addSubview:myCarousel];
}

-(UIView *)carousel:(Carousel *)carousel viewForPageAtIndex:(NSInteger)index {
    UIView *pageView = [[UIView alloc] initWithFrame:CGRectMake(myCarousel.frame.size.width/4.0, myCarousel.frame.size.height/4.0, myCarousel.frame.size.width/2.0, myCarousel.frame.size.height/2.0)];
    UILabel *lbl2 = [[UILabel alloc] initWithFrame:pageView.bounds];
    [lbl2 setTextAlignment:NSTextAlignmentRight];
    [lbl2 setText:[NSString stringWithFormat:@"%ld",(long)index]];
    [pageView addSubview:lbl2];
    UILabel *lbl = [[UILabel alloc] initWithFrame:pageView.bounds];
    [lbl setText:[NSString stringWithFormat:@"%ld",(long)index]];
    [pageView addSubview:lbl];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, myCarousel.frame.size.width/2.0-20, myCarousel.frame.size.height/2.0-20)];
    [imgView setImage:[UIImage imageNamed:@"moi.jpg"]];
    [pageView addSubview:imgView];
    if (index%2) {
        [pageView setBackgroundColor:[UIColor redColor]];
    } else {
        [pageView setBackgroundColor:[UIColor cyanColor]];
    }
    return pageView;
}

-(NSInteger)carouselNumberOfPages:(Carousel *)carousel {
    return 10;
}

-(UIView *)carouselViewSeparator:(Carousel *)carousel {
    UIView *separator = [[UIView alloc] initWithFrame:myCarousel.bounds];
    [separator setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.7]];
    return separator;
}

-(void)carousel:(Carousel *)carousel focusOnIndex:(NSInteger)index {
    NSLog(@"FOCUS on %d",index);
}

@end
