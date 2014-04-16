//
//  CustomTabBarViewController.m
//  CustomTabBar
//
//  Created by Peter Boctor on 1/2/11.
//
// Copyright (c) 2011 Peter Boctor
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE
//

#import "CustomTabBarViewController.h"
#import "FirstViewController.h"

#define SELECTED_VIEW_CONTROLLER_TAG 98456345

static NSArray* tabBarItems = nil;
const CGFloat tabbarHeight = 45.0;

@implementation CustomTabBarViewController
@synthesize tabBar;

- (void) awakeFromNib
{
  // Set up some fake view controllers each with a different background color so we can visually see the controllers getting swapped around
  FirstViewController *detailController1 = [[[FirstViewController alloc] init] autorelease];
  detailController1.view.backgroundColor = [UIColor redColor];
    UINavigationController *detailNavController1 = [[UINavigationController alloc] initWithRootViewController:detailController1];
    detailNavController1.delegate = self;

  FirstViewController *detailController2 = [[[FirstViewController alloc] init] autorelease];
  detailController2.view.backgroundColor = [UIColor greenColor];
    UINavigationController *detailNavController2 = [[UINavigationController alloc] initWithRootViewController:detailController2];
    detailNavController2.delegate = self;

  FirstViewController *detailController3 = [[[FirstViewController alloc] init] autorelease];
  detailController3.view.backgroundColor = [UIColor blueColor];
    UINavigationController *detailNavController3 = [[UINavigationController alloc] initWithRootViewController:detailController3];
    detailNavController3.delegate = self;

  FirstViewController *detailController4 = [[[FirstViewController alloc] init] autorelease];
  detailController4.view.backgroundColor = [UIColor cyanColor];
    UINavigationController *detailNavController4 = [[UINavigationController alloc] initWithRootViewController:detailController4];
    detailNavController4.delegate = self;

  FirstViewController *detailController5 = [[[FirstViewController alloc] init] autorelease];
  detailController5.view.backgroundColor = [UIColor purpleColor];
    UINavigationController *detailNavController5 = [[UINavigationController alloc] initWithRootViewController:detailController5];
    detailNavController5.delegate = self;

  tabBarItems = [[NSArray arrayWithObjects:
              [NSDictionary dictionaryWithObjectsAndKeys:@"home_tab_icon_1.png", @"image", detailNavController1, @"viewController", nil],
              [NSDictionary dictionaryWithObjectsAndKeys:@"home_tab_icon_2.png", @"image", detailNavController2, @"viewController", nil],
              [NSDictionary dictionaryWithObjectsAndKeys:@"home_tab_icon_3.png", @"image", detailNavController3, @"viewController", nil],
              [NSDictionary dictionaryWithObjectsAndKeys:@"home_tab_icon_4.png", @"image", detailNavController4, @"viewController", nil],
              [NSDictionary dictionaryWithObjectsAndKeys:@"home_tab_icon_5.png", @"image", detailNavController5, @"viewController", nil], nil] retain];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
    tabBarIsShow = YES;
  // Use the TabBarGradient image to figure out the tab bar's height (22x2=44)
//  UIImage* tabBarGradient = [UIImage imageNamed:@"TabBarGradient.png"];
  
  // Create a custom tab bar passing in the number of items, the size of each item and setting ourself as the delegate
  self.tabBar = [[[CustomTabBar alloc] initWithItemCount:tabBarItems.count itemSize:CGSizeMake(self.view.frame.size.width/tabBarItems.count, tabbarHeight) tag:0 delegate:self] autorelease];
  
  // Place the tab bar at the bottom of our view
  tabBar.frame = CGRectMake(0,self.view.frame.size.height-tabbarHeight,self.view.frame.size.width, tabbarHeight);
  [self.view addSubview:tabBar];
  
  // Select the first tab
  [tabBar selectItemAtIndex:0];
  [self touchDownAtItemAtIndex:0];
}

#pragma mark -

- (void)navigationController:(UINavigationController *)navController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController.hidesBottomBarWhenPushed)
    {
        [self hideTabBar];
    }
    else
    {
        [self showTabBar];
    }
    
}

- (void)hideTabBar {
    if (!tabBarIsShow)
    { //is hidden
        return;
    }
    [UIView animateWithDuration:0.35
                     animations:^{
                         CGRect tabFrame = tabBar.frame;
                         //tabFrame.origin.y = CGRectGetMaxY(window.bounds);
                         tabFrame.origin.x = 0 - tabFrame.size.width;
                         tabBar.frame = tabFrame;
                     }];
    tabBarIsShow = NO;
}


- (void)showTabBar {
    if (tabBarIsShow)
    { // is showing
        return;
    }
    [UIView animateWithDuration:0.35
                     animations:^{
                         CGRect tabFrame = tabBar.frame;
                         //tabFrame.origin.y = CGRectGetMaxY(window.bounds) - CGRectGetHeight(tabBar.frame);
                         tabFrame.origin.x = CGRectGetWidth(tabFrame) + CGRectGetMinX(tabFrame);
                         tabBar.frame = tabFrame;
                     }];
    tabBarIsShow = YES;
}
#pragma mark CustomTabBarDelegate

- (UIImage*) imageFor:(CustomTabBar*)tabBar atIndex:(NSUInteger)itemIndex
{
  // Get the right data
  NSDictionary* data = [tabBarItems objectAtIndex:itemIndex];
  // Return the image for this tab bar item
  return [UIImage imageNamed:[data objectForKey:@"image"]];
}

- (UIImage*) backgroundImage
{
#if 0
  // The tab bar's width is the same as our width
  CGFloat width = self.view.frame.size.width;
  // Get the image that will form the top of the background
  UIImage* topImage = [UIImage imageNamed:@"TabBarGradient.png"];
  
  // Create a new image context
  UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, topImage.size.height*2), NO, 0.0);
  
  // Create a stretchable image for the top of the background and draw it
  UIImage* stretchedTopImage = [topImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
  [stretchedTopImage drawInRect:CGRectMake(0, 0, width, topImage.size.height)];
  
  // Draw a solid black color for the bottom of the background
  [[UIColor blackColor] set];
  CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, topImage.size.height, width, topImage.size.height));
  
  // Generate a new image
  UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return resultImage;
#endif
    
    UIImage* topImage = [UIImage imageNamed:@"mask_navbar.png"];
    return topImage;
}

// This is the blue background shown for selected tab bar items
- (UIImage*) selectedItemBackgroundImage
{
  return [UIImage imageNamed:@"TabBarItemSelectedBackground.png"];
}

// This is the glow image shown at the bottom of a tab bar to indicate there are new items
- (UIImage*) glowImage
{
#if 0
  UIImage* tabBarGlow = [UIImage imageNamed:@"TabBarGlow.png"];
  
  // Create a new image using the TabBarGlow image but offset 4 pixels down
  UIGraphicsBeginImageContextWithOptions(CGSizeMake(tabBarGlow.size.width, tabBarGlow.size.height-4.0), NO, 0.0);

  // Draw the image
  [tabBarGlow drawAtPoint:CGPointZero];

  // Generate a new image
  UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return resultImage;
#endif
}

// This is the embossed-like image shown around a selected tab bar item
- (UIImage*) selectedItemImage
{
    UIImage* topImage = [UIImage imageNamed:@"home_bottom_tab_arrow.png"];
    return topImage;
#if 0
  // Use the TabBarGradient image to figure out the tab bar's height (22x2=44)
  UIImage* tabBarGradient = [UIImage imageNamed:@"TabBarGradient.png"];
  CGSize tabBarItemSize = CGSizeMake(self.view.frame.size.width/tabBarItems.count, tabBarGradient.size.height*2);
  UIGraphicsBeginImageContextWithOptions(tabBarItemSize, NO, 0.0);

  // Create a stretchable image using the TabBarSelection image but offset 4 pixels down
  [[[UIImage imageNamed:@"TabBarSelection.png"] stretchableImageWithLeftCapWidth:4.0 topCapHeight:0] drawInRect:CGRectMake(0, 4.0, tabBarItemSize.width, tabBarItemSize.height-4.0)];  

  // Generate a new image
  UIImage* selectedItemImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return selectedItemImage;
#endif
}

- (UIImage*) tabBarArrowImage
{
  return [UIImage imageNamed:@"TabBarNipple.png"];
}

- (void) touchDownAtItemAtIndex:(NSUInteger)itemIndex
{
  // Remove the current view controller's view
  UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
  [currentView removeFromSuperview];
  
  // Get the right view controller
  NSDictionary* data = [tabBarItems objectAtIndex:itemIndex];
  FirstViewController* viewController = [data objectForKey:@"viewController"];

  // Use the TabBarGradient image to figure out the tab bar's height (22x2=44)
//  UIImage* tabBarGradient = [UIImage imageNamed:@"TabBarGradient.png"];

  // Set the view controller's frame to account for the tab bar
  viewController.view.frame = CGRectMake(0,0,self.view.bounds.size.width, self.view.bounds.size.height-tabbarHeight);

  // Se the tag so we can find it later
  viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
  
  // Add the new view controller's view
  [self.view insertSubview:viewController.view belowSubview:tabBar];
  
  // In 1 second glow the selected tab
//  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(addGlowTimerFireMethod:) userInfo:[NSNumber numberWithInteger:itemIndex] repeats:NO];
  
}

- (void)addGlowTimerFireMethod:(NSTimer*)theTimer
{
    return;
  // Remove the glow from all tab bar items
  for (NSUInteger i = 0 ; i < tabBarItems.count ; i++)
  {
    [tabBar removeGlowAtIndex:i];
  }
  
  // Then add it to this tab bar item
  [tabBar glowItemAtIndex:[[theTimer userInfo] integerValue]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
  // Let the tab bar that we're about to rotate
  [tabBar willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

  // Adjust the current view in prepartion for the new orientation
  UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
  UIImage* tabBarGradient = [UIImage imageNamed:@"TabBarGradient.png"];

  CGFloat width = 0, height = 0;
  if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
  {
    width = self.view.window.frame.size.width;
    height = self.view.window.frame.size.height;
  }
  else
  {
    width = self.view.window.frame.size.height;
    height = self.view.window.frame.size.width;
  }

  currentView.frame = CGRectMake(0,0,width, height-(tabBarGradient.size.height*2));
}

- (void)dealloc
{
  [super dealloc];
  [tabBar release];
}

@end
