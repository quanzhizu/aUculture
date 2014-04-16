//
//  FirstViewController.m
//  CustomTabBar
//
//  Created by Pheylix on 13-8-5.
//
//

#import "FirstViewController.h"
#import "SecondViewController.h"
@interface FirstViewController ()

@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 100, 30)];
    [btn setTitle:@"Press me" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor grayColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btn release];
	// Do any additional setup after loadin the view.
}


- (void)btnPressed:(id)sender
{
    SecondViewController *viewController = [[SecondViewController alloc] init];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
