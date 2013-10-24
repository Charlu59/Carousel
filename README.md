Carousel
========
Carousel dynamique with many options

## DataSource
<blockquote>
<p>@protocol CarouselDataSource<NSObject></p>
<p>@required</p>
<p>-(NSInteger)carouselNumberOfPages:(Carousel *)carousel;</p>
<p>-(UIView *)carousel:(Carousel *)carousel viewForPageAtIndex:(NSInteger)index;</p>
<p>@optional</p>
<p>-(UIView *)carouselViewSeparator:(Carousel *)carousel;</p>
<p>@end</p>
</blockquote>

## Delegate
<blockquote>
<p>@protocol CarouselDelegate<NSObject></p>
<p>@optional</p>
<p>-(void)carousel:(Carousel *)carousel focusOnIndex:(NSInteger)index;</p>
<p>@end</p>
</blockquote>

## Options
You have some options availabled defined in PPRevealSideOptions

* setBackCoverflow : Disable or enable the view going to the backgroundview
* setUserInteractionEnabled : Disable or enable gesture on Carousel
* setInifiniteLoop : Disable or enable the loop of the Carousel
* setActiveCache : Disable or enable caching view
* animateWithPeriod : Set a period to animate carousel automatically without gesture.
* setInitialPage : Set the initial page if you want to start to another index than 0.

