//
//  MainTableViewController.m
//  tango
//
//  Created by Kohei on 2014/10/07.
//  Copyright (c) 2014年 KoheiKanagu. All rights reserved.
//

#import "MainTableViewController.h"

@interface MainTableViewController ()

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadItems];
}

-(void)loadItems
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    files = [[NSMutableArray alloc]initWithArray:[ud objectForKey:@"files"]];
    names = [NSMutableArray new];
    counts = [NSMutableArray new];
    
    for(int i=0; i<files.count; i++){
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[ud objectForKey:files[i]]];
        [names addObject:[dic objectForKey:@"name"]];
        [counts addObject:[dic objectForKey:@"count"]];
    }
}

#pragma mark - Action
-(IBAction)longPress:(id)sender
{
    UILongPressGestureRecognizer *ges = (UILongPressGestureRecognizer *)sender;
    if(ges.state == UIGestureRecognizerStateBegan){
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:[ges locationInView:self.tableView]];
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"名称変更"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"キャンセル"
                                          otherButtonTitles:@"変更", nil];
        av.alertViewStyle = UIAlertViewStylePlainTextInput;
        av.tag = indexPath.row;
        [av show];
    }
}

-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *inputText = [[alertView textFieldAtIndex:0]text];
    if([inputText length]>=1){
        return YES;
    }else{
        return NO;
    }
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex){
        NSString *string = [[alertView textFieldAtIndex:0]text];
        names[alertView.tag] = string;
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *uuid = files[alertView.tag];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:[ud objectForKey:uuid]];
        [dic setObject:string
                forKey:@"name"];
        [ud setObject:dic
               forKey:uuid];
        [ud synchronize];
        
        
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:alertView.tag inSection:0]]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return names.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(names.count == 0){
        return @"別のアプリから.csvファイルを参照し、このアプリで開いてください。";
    }
    return @"";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier
                                                            forIndexPath:indexPath];
    cell.textLabel.text = names[indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", counts[indexPath.row]];
    return cell;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *uuid = files[indexPath.row];
    [files removeObjectAtIndex:indexPath.row];
    [names removeObjectAtIndex:indexPath.row];
    [counts removeObjectAtIndex:indexPath.row];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:files
           forKey:@"files"];
    [ud removeObjectForKey:uuid];
    [ud synchronize];
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [tableView beginUpdates];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationRight];
        
        [tableView endUpdates];
    }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewCell *selectedCell = (UITableViewCell *)sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:selectedCell];
    
    if([segue.identifier isEqualToString:@"show"]){
        DetailViewController *hoge = (DetailViewController *)[segue destinationViewController];
        hoge.uuid = files[indexPath.row];
        hoge.title = names[indexPath.row];
    }
}

@end