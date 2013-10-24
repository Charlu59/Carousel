//
//  RootViewController.h
//  Carousel
//
//  Created by Charles-Hubert Basuiau on 23/10/13.
//  Copyright (c) 2013 Charles-Hubert Basuiau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Carousel.h"

@interface RootViewController : UIViewController<CarouselDataSource, CarouselDelegate> {
    Carousel *myCarousel;
    UIImageView *blurView;
}

@end
