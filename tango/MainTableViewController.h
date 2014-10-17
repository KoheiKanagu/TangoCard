//
//  MainTableViewController.h
//  tango
//
//  Created by Kohei on 2014/10/07.
//  Copyright (c) 2014年 KoheiKanagu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSVLoader.h"
#import "DetailViewController.h"

@interface MainTableViewController : UITableViewController
{
    NSMutableArray *files;
    NSMutableArray *names;
    NSMutableArray *counts;
}
-(void)loadItems;

@end
