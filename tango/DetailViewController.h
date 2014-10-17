//
//  DetailViewController.h
//  tango
//
//  Created by KanaguKohei on 2014/10/07.
//  Copyright (c) 2014年 KoheiKanagu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface DetailViewController : UITableViewController
{
    NSMutableDictionary *item;
    NSArray *jpns;
    NSArray *engs;
    NSMutableArray *showingWordsCountList;
    
    NSTimeInterval timeInterval;
    NSDate *startTime;
    
    UIRefreshControl *refreshControl;
}

@property NSString *title;
@property NSString *uuid;

@end
