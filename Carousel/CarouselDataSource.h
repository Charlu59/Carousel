//
//  CarouselDataSource.h
//  Carousel
//
//  Created by Charles-Hubert Basuiau on 23/10/13.
//  Copyright (c) 2013 Charles-Hubert Basuiau. All rights reserved.
//

@class Carousel;

@protocol CarouselDataSource<NSObject>

@required
- (NSInteger)carouselNumberOfPages:(Carousel *)carousel;
- (UIView *)carousel:(Carousel *)carousel viewForPageAtIndex:(NSInteger)index;

@optional
- (UIView *)carouselViewSeparator:(Carousel *)carousel;

@end
