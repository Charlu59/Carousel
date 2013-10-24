//
//  Carousel.m
//  Carousel
//
//  Created by Charles-Hubert Basuiau on 23/10/13.
//  Copyright (c) 2013 Charles-Hubert Basuiau. All rights reserved.
//

#import "Carousel.h"

@interface Carousel () <UIScrollViewDelegate> {
    UIScrollView *scrollviewTop;
    UIScrollView *scrollviewBack;
    UIView *viewContentBack;
    NSInteger nbPages;
    NSMutableDictionary *viewsTopManager;
    NSMutableDictionary *viewsBackManager;
    
    BOOL hasPageControl;
    BOOL hasBackCoverflow;
    BOOL isLooping;
    BOOL isCaching;

    NSInteger offsetLooping;
    CGFloat myPeriod;
    
    NSInteger initialIndex;
}

@end

@implementation Carousel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        nbPages = 0;
        viewsTopManager = [[NSMutableDictionary alloc] init];
        viewsBackManager = [[NSMutableDictionary alloc] init];
        hasPageControl = NO;
        hasBackCoverflow = NO;
        isLooping = NO;
        isCaching=NO;
        myPeriod = 0.0;
        offsetLooping = 0;
        initialIndex = 0;

        scrollviewTop = [[UIScrollView alloc] initWithFrame:self.bounds];
        [scrollviewTop setPagingEnabled:YES];
        scrollviewTop.delegate = self;
        [scrollviewTop setBackgroundColor:[UIColor clearColor]];
        [self addSubview:scrollviewTop];
        self.hidden = YES;
    }
    return self;
}

-(void)show {
    NSAssert([_dataSource respondsToSelector:@selector(carouselNumberOfPages:)],@"You have to set the Carousel dataSource");
    if ([_dataSource respondsToSelector:@selector(carouselNumberOfPages:)]) {
        self.hidden = NO;
        nbPages = [_dataSource carouselNumberOfPages:self];
        [scrollviewTop setContentSize:CGSizeMake(self.frame.size.width*(nbPages+2*offsetLooping), self.frame.size.height)];
        
        if (hasBackCoverflow) {
            if ([_dataSource respondsToSelector:@selector(carouselViewSeparator:)]) {
                UIView *viewSeparator = [_dataSource carouselViewSeparator:self];
                [self insertSubview:viewSeparator atIndex:0];
            }
            
            scrollviewBack = [[UIScrollView alloc] initWithFrame:self.bounds];
            scrollviewBack.showsHorizontalScrollIndicator = NO;
            [scrollviewBack setBackgroundColor:[UIColor clearColor]];
            
            viewContentBack =[[UIView alloc] initWithFrame:scrollviewBack.frame];
            [viewContentBack addSubview:scrollviewBack];
            [self insertSubview:viewContentBack atIndex:0];
        }
        
        [self loadTopViewAIndex:initialIndex-1];
        [self loadTopViewAIndex:initialIndex];
        [self loadTopViewAIndex:initialIndex+1];
        [self loadBackViewAIndex:initialIndex];
        [self loadBackViewAIndex:initialIndex-1];
        [self loadBackViewAIndex:initialIndex-2];
        [self loadBackViewAIndex:initialIndex-3];
        if ([_delegate respondsToSelector:@selector(carousel:focusOnIndex:)]) {
            [_delegate carousel:self focusOnIndex:initialIndex];
        }
        
        
        
        if (myPeriod != 0.0) {
            isLooping = YES;
            offsetLooping = 1;
            [NSTimer scheduledTimerWithTimeInterval:myPeriod target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        }
        if(isLooping) {
            [scrollviewTop scrollRectToVisible:CGRectMake(scrollviewTop.frame.size.width*(initialIndex+1),0,scrollviewTop.frame.size.width,scrollviewTop.frame.size.height) animated:NO];
        } else {
            [scrollviewTop scrollRectToVisible:CGRectMake(scrollviewTop.frame.size.width*initialIndex,0,scrollviewTop.frame.size.width,scrollviewTop.frame.size.height) animated:NO];
        }
    }
}

#pragma mark -
#pragma mark View Management

- (void)loadTopViewAIndex:(NSInteger)index {
    NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)index];
    BOOL contains = [[viewsTopManager allKeys] containsObject:indexStr];
    if (([_dataSource respondsToSelector:@selector(carousel:viewForPageAtIndex:)] && nbPages!=0 && !contains) && (isLooping || (index>=0 && index<nbPages))) {
        UIView *page = [_dataSource carousel:self viewForPageAtIndex:(index+nbPages)%nbPages];
        CGRect tmpFrame = page.frame;
        tmpFrame.origin.x += (index+offsetLooping)*self.frame.size.width;
        [page setFrame:tmpFrame];
        [viewsTopManager setObject:page forKey:indexStr];
        [scrollviewTop insertSubview:page atIndex:0];
    }
}

- (void)loadBackViewAIndex:(NSInteger)index {
    if (hasBackCoverflow) {
        NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)index];
        BOOL contains = [[viewsBackManager allKeys] containsObject:indexStr];
        if (([_dataSource respondsToSelector:@selector(carousel:viewForPageAtIndex:)] && nbPages!=0 && !contains) && (isLooping || (index>=0 && index<nbPages))) {
            CGRect frame2;
            frame2.origin.x = scrollviewBack.frame.size.width * (1.5 - index -3 - offsetLooping) /2.0;
            frame2.origin.y = 0;
            frame2.size = scrollviewBack.frame.size;
            
            UIView *page2 = [_dataSource carousel:self viewForPageAtIndex:[indexStr integerValue]];
            
            //Vue2
            UIView *subview2 = [[UIView alloc] initWithFrame:frame2];
            CGAffineTransform tr = CGAffineTransformScale(subview2.transform, -0.5, 0.5);
            [subview2 setTransform:tr];
            [subview2 addSubview:page2];
            [viewsBackManager setObject:subview2 forKey:indexStr];
            [scrollviewBack insertSubview:subview2 atIndex:0];
        }
    }
}

- (void)unloadTopViewAIndex:(NSInteger)index {
    if (!isCaching) {
        NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)index];
        if ([[viewsTopManager allKeys] containsObject:indexStr]) {
            UIView *tmpPage = [viewsTopManager objectForKey:indexStr];
            [tmpPage removeFromSuperview];
            [viewsTopManager removeObjectForKey:indexStr];
        }
    }
}

- (void)unloadBackViewAIndex:(NSInteger)index {
    if (!isCaching) {
        NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)index];
        if ([[viewsBackManager allKeys] containsObject:indexStr]) {
            UIView *tmpPage = [viewsBackManager objectForKey:indexStr];
            [tmpPage removeFromSuperview];
            [viewsBackManager removeObjectForKey:indexStr];
        }
    }
}

#pragma mark -
#pragma mark Moves management

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == scrollviewTop) {
        NSInteger numOfPage = scrollviewTop.contentOffset.x / self.frame.size.width - offsetLooping;
        if ((numOfPage<0 || numOfPage>=nbPages) && isLooping) {  //isLooping is a security
            [self unloadTopViewAIndex:numOfPage];
            [self unloadBackViewAIndex:numOfPage-1];
            [self unloadBackViewAIndex:numOfPage-2];
            if (numOfPage<0) {
                [self unloadTopViewAIndex:numOfPage+1];
                [self unloadTopViewAIndex:numOfPage+2];
                [self unloadBackViewAIndex:numOfPage+1];
                [self unloadBackViewAIndex:numOfPage];
                numOfPage = nbPages-1;
                [self loadTopViewAIndex:numOfPage-1];
                [self loadTopViewAIndex:numOfPage+1];
                [self loadBackViewAIndex:numOfPage];
                [self loadBackViewAIndex:numOfPage-3];
            } else if (numOfPage>=nbPages) {
                [self unloadTopViewAIndex:numOfPage-1];
                [self unloadTopViewAIndex:numOfPage-2];
                [self unloadBackViewAIndex:numOfPage-3];
                [self unloadBackViewAIndex:numOfPage-4];
                numOfPage = 0;
                [self loadTopViewAIndex:numOfPage+1];
                [self loadTopViewAIndex:numOfPage-1];
                [self loadBackViewAIndex:numOfPage];
                [self loadBackViewAIndex:numOfPage-3];
            }
            [scrollviewTop scrollRectToVisible:CGRectMake(scrollviewTop.frame.size.width*(numOfPage+1),0,scrollviewTop.frame.size.width,scrollviewTop.frame.size.height) animated:NO];
            [scrollviewBack setContentOffset:CGPointMake(-scrollviewTop.contentOffset.x/2.0, scrollviewTop.contentOffset.y) animated:NO];
        } else {
            [self unloadTopViewAIndex:numOfPage-2];
            [self unloadTopViewAIndex:numOfPage+2];
            [self unloadBackViewAIndex:numOfPage-4];
            [self unloadBackViewAIndex:numOfPage+4];
            [self loadTopViewAIndex:numOfPage-1];
            [self loadTopViewAIndex:numOfPage+1];
            [self loadBackViewAIndex:numOfPage];
        }
        //In Case of not focusing next or previous page
        [self loadTopViewAIndex:numOfPage];
        [self loadBackViewAIndex:numOfPage-1];
        [self loadBackViewAIndex:numOfPage-2];
        if ([_delegate respondsToSelector:@selector(carousel:focusOnIndex:)]) {
            [_delegate carousel:self focusOnIndex:numOfPage];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (hasBackCoverflow) {
        [scrollviewBack setContentOffset:CGPointMake(-scrollviewTop.contentOffset.x/2.0, scrollviewTop.contentOffset.y) animated:NO];
    }
}


- (void) nextPage {
    NSInteger numOfPage = scrollviewTop.contentOffset.x / self.frame.size.width - offsetLooping;
    if (numOfPage>=nbPages) {
        [self unloadTopViewAIndex:numOfPage];
        [self unloadTopViewAIndex:numOfPage-1];
        [self unloadTopViewAIndex:numOfPage-2];
        [self unloadBackViewAIndex:numOfPage-1];
        [self unloadBackViewAIndex:numOfPage-2];
        [self unloadBackViewAIndex:numOfPage-3];
        [self unloadBackViewAIndex:numOfPage-4];
        numOfPage = 0;
        [self loadTopViewAIndex:numOfPage+1];
        [self loadTopViewAIndex:numOfPage];
        [self loadTopViewAIndex:numOfPage-1];
        [self loadBackViewAIndex:numOfPage];
        [self loadBackViewAIndex:numOfPage-1];
        [self loadBackViewAIndex:numOfPage-2];
        [self loadBackViewAIndex:numOfPage-3];
        [scrollviewTop scrollRectToVisible:CGRectMake(scrollviewTop.frame.size.width,0,scrollviewTop.frame.size.width,scrollviewTop.frame.size.height) animated:NO];
    } else {
        [self unloadTopViewAIndex:numOfPage-2];
        [self unloadTopViewAIndex:numOfPage+2];
        [self unloadBackViewAIndex:numOfPage-4];
        [self unloadBackViewAIndex:numOfPage+4];
        [self loadTopViewAIndex:numOfPage-1];
        [self loadTopViewAIndex:numOfPage+1];
        [self loadBackViewAIndex:numOfPage];
    }
    numOfPage++;
    [scrollviewTop scrollRectToVisible:CGRectMake(scrollviewTop.frame.size.width*(numOfPage+offsetLooping),0,scrollviewTop.frame.size.width,scrollviewTop.frame.size.height) animated:YES];
    if ([_delegate respondsToSelector:@selector(carousel:focusOnIndex:)]) {
        [_delegate carousel:self focusOnIndex:numOfPage%nbPages];
    }
}

#pragma mark -
#pragma mark Options

-(void)setPageControl:(BOOL)opt {
    hasPageControl = opt;
}

-(void)setBackCoverflow:(BOOL)opt {
    hasBackCoverflow = opt;
}

-(void)setInifiniteLoop:(BOOL)opt {
    isLooping = opt;
    offsetLooping = opt ? 1 : 0;
}

-(void)animateWithPeriod:(CGFloat)period {
    myPeriod = period;
}

-(void)setActiveCache:(BOOL)opt {
    isCaching = opt;
}

-(void)setInitialPage:(NSInteger)firstIndex {
    initialIndex = firstIndex;
}

-(void)setUserInteractionEnabled:(BOOL)opt {
    [scrollviewTop setUserInteractionEnabled:opt];
}

@end
