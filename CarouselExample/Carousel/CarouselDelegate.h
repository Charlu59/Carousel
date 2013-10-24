//
//  CarouselDelegate.h
//  Carousel
//
//  Created by Charles-Hubert Basuiau on 24/10/13.
//  Copyright (c) 2013 Charles-Hubert Basuiau. All rights reserved.
//

@class Carousel;

@protocol CarouselDelegate<NSObject>

@optional
-(void)carousel:(Carousel *)carousel focusOnIndex:(NSInteger)index;

@end
