//
//  menuViewController.m
//  Virtual Travel
//
//  Created by Steve-Mac on 2014. 11. 28..
//  Copyright (c) 2014년 InciteStudio. All rights reserved.
//

#import "menuViewController.h"

@interface menuViewController (){
    NSInteger _previouslySelectedRow;
}
@end

@implementation menuViewController
@synthesize mainVC;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    menuArray = [[NSArray alloc] initWithObjects:@"Quick Start",@"Path List" ,nil];
    menuTable = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 180.0f, 548.0f)];
    menuTable.delegate = self;
    menuTable.dataSource = self;
    [self.view addSubview:menuTable];
    [menuTable selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    
    // button position
    /*
    int xMargin = 30;
    int marginBottom = 25;
    CGFloat btnWidth = self.view.frame.size.width - xMargin * 2;
    int btnHeight = 42;
    
    UIButton* kakaoLoginButton
    = [[KOLoginButton alloc] initWithFrame:CGRectMake(xMargin, self.view.frame.size.height-btnHeight-marginBottom, btnWidth, btnHeight)];
    kakaoLoginButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [kakaoLoginButton addTarget:self
                         action:@selector(invokeLoginWithTarget)
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:kakaoLoginButton];
     */
}
-(void) invokeLoginWithTarget
{
    [[KOSession sharedSession] close];
    
    [[KOSession sharedSession] openWithCompletionHandler:^(NSError *error) {
        if ([[KOSession sharedSession] isOpen]) {
            // login success
            NSLog(@"login succeeded.");
        } else {
            // failed
            NSLog(@"login failed.");
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [menuArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [menuArray objectAtIndex:indexPath.row];
    return cell;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWRevealViewController *revealController = self.revealViewController;
    
    NSInteger row = indexPath.row;
    
    if ( row == _previouslySelectedRow )
    {
        [revealController revealToggleAnimated:YES];
        return;
    }
    _previouslySelectedRow = row;
    [(mainViewController *)mainVC setFrontViewWithIndex:(int)row];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
