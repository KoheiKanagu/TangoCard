//
//  DetailViewController.m
//  tango
//
//  Created by KanaguKohei on 2014/10/07.
//  Copyright (c) 2014年 KoheiKanagu. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    item = [[NSMutableDictionary alloc]initWithDictionary:[ud objectForKey:self.uuid]];
    jpns = [item objectForKey:@"jpn"];
    engs = [item objectForKey:@"eng"];
    
    timeInterval = [[item objectForKey:@"time"] doubleValue];
    startTime = [NSDate date];
    
    showingWordsCountList = [NSMutableArray new];
    
    for(int i=0; i<jpns.count; i++){
        [showingWordsCountList addObject:@1];
    }
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    
    [self becomeFirstResponder];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(countTimerCycle:)
                                                    userInfo:nil
                                                     repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer
                              forMode:NSRunLoopCommonModes];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self
                       action:@selector(refreshControlTimeCycle:)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self addTimeInterval];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [item setObject:@(timeInterval)
             forKey:@"time"];
    [ud setObject:item
           forKey:self.uuid];
    [ud synchronize];
}

-(void)addTimeInterval
{
    timeInterval += [[NSDate date] timeIntervalSinceDate:startTime];
    startTime = [NSDate date];
}

-(NSString *)stringFromTimeInterval:(NSTimeInterval)interval
{
    NSInteger ti = (NSInteger)interval;
    NSInteger sec = ti % 60;
    NSInteger min = (ti / 60) % 60;
    NSInteger hour = (ti / 3600);
    
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hour, (long)min, (long)sec];
}

#pragma mark - Selector

-(void)countTimerCycle:(NSTimer *)timer
{
    [self addTimeInterval];
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:[self stringFromTimeInterval:timeInterval]];
}

-(void)refreshControlTimeCycle:(UIRefreshControl *)refCtrl
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSInteger count=0;
        
        while(count<2){
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            count++;
            [NSThread sleepForTimeInterval:0.5];
        }
        AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
    });
    [refCtrl endRefreshing];
}


#pragma mark - Gesture
-(BOOL)canBecomeFirstResponder
{
    return YES;
}
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"shake Begin");
}
-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"shake End");
    [self addTimeInterval];
    NSLog(@"%@",[self stringFromTimeInterval:timeInterval]);
    
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"経過時間", nil)
                                                message:[self stringFromTimeInterval:timeInterval]
                                               delegate:nil
                                      cancelButtonTitle:NSLocalizedString(@"閉じる", nil)
                                      otherButtonTitles:nil, nil];
    [av show];
}


#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return jpns.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [showingWordsCountList[section] integerValue];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(iOSVersion >= 8){
        return -1;
    }
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier
                                                            forIndexPath:indexPath];
    if(indexPath.row){
        cell.textLabel.text = engs[indexPath.section];
        cell.backgroundColor = [UIColor colorWithRed:0.959 green:0.987 blue:1.000 alpha:1.000];
    }else{
        cell.textLabel.text = jpns[indexPath.section];
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel sizeToFit];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 1){
        return;
    }
    
    if([showingWordsCountList[indexPath.section] isEqual:@1]){
        [showingWordsCountList replaceObjectAtIndex:indexPath.section
                                         withObject:@2];
        [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1
                                                               inSection:indexPath.section]]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
    }else{
        [showingWordsCountList replaceObjectAtIndex:indexPath.section
                                         withObject:@1];
        [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1
                                                               inSection:indexPath.section]]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
