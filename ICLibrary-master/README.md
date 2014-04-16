ICLibrary
=========

an iOS library built on Cocoa and UIKit, include Network、UI、Caategory and Animation four parts;


Network
=========



UI
=========
Introduction to the use of commonly used controls

ICZoomableImageView

    ICZoomableImageView *zoomableImageView = [[ICZoomableImageView alloc] initwithImage:[UIImage imageNamed:@"test.jpg"] frame:self.view.bounds];
    zoomableImageView.zoomableImageDelegate = self;
    [self.view addSubview:zoomableImageView];
    [zoomableImageView release];

ICLabel

     ICLabel *icLabel = [[ICLabel alloc] initWithFrame:CGRectMake(20, 60, 280, 200)];
     [icLabel setFont:[UIFont fontWithName:@"Arial" size:24]];
     [icLabel setBackgroundColor:[UIColor clearColor]];
     icLabel.lineBreakMode = UILineBreakModeCharacterWrap;
     icLabel.textColor = [UIColor colorWithRed:159.0/255.5 green:159.0/255.0 blue:160.0/255.0 alpha:1.0];
     [icLabel setVerticalAlignment:VerticalAlignmentTop];
     icLabel.numberOfLines = 4;
     icLabel.text = @"ICLibrary is readlly an good ios library, it include a variety of commonly used controls.";
     [self.view addSubview:icLabel];
     [icLabel release];
     

Category
=========


Animation
=========




