//
//  Carousel.h
//  Carousel
//
//  Created by Charles-Hubert Basuiau on 23/10/13.
//  Copyright (c) 2013 Charles-Hubert Basuiau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarouselDataSource.h"
#import "CarouselDelegate.h"

@interface Carousel : UIView

@property (nonatomic, assign) id <CarouselDelegate> delegate;
@property (nonatomic, assign) id <CarouselDataSource> dataSource;

-(void)setPageControl:(BOOL)opt;
-(void)setBackCoverflow:(BOOL)opt;
-(void)setInifiniteLoop:(BOOL)opt;
-(void)setActiveCache:(BOOL)opt;
-(void)animateWithPeriod:(CGFloat)period;
-(void)setInitialPage:(NSInteger)firstIndex;

-(void)show;

@end
