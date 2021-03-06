Carousel
========
Carousel dynamique with many options

## DataSource

You can custom your views as you want and optionally add a seperator if you put the backgroundview option
    
    @protocol CarouselDataSource<NSObject>
    @required
    -(NSInteger)carouselNumberOfPages:(Carousel *)carousel;
    -(UIView *)carousel:(Carousel *)carousel viewForPageAtIndex:(NSInteger)index;
    @optional
    -(UIView *)carouselViewSeparator:(Carousel *)carousel;
    @end

## Delegate

You are noticed when carousel focus on a page
    
    @protocol CarouselDelegate<NSObject>
    @optional
    -(void)carousel:(Carousel *)carousel focusOnIndex:(NSInteger)index;
    @end




## Options
You have some options availabled defined in PPRevealSideOptions

* setBackCoverflow : Disable or enable the view going to the backgroundview
* setUserInteractionEnabled : Disable or enable gesture on Carousel
* setInifiniteLoop : Disable or enable the loop of the Carousel
* setActiveCache : Disable or enable caching view
* animateWithPeriod : Set a period to animate carousel automatically without gesture.
* setInitialPage : Set the initial page if you want to start to another index than 0.

