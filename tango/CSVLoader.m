//
//  CSVLoader.m
//  tango
//
//  Created by Kohei on 2014/10/07.
//  Copyright (c) 2014年 KoheiKanagu. All rights reserved.
//

#import "CSVLoader.h"

@implementation CSVLoader

//+(void)loadCSVfromLocalStorage
//{
//    NSString *fileURL = @"/Users/Kohei/Dropbox/part1.csv";
//    
//    NSError *error;
//    NSString *rawCSV = [NSString stringWithContentsOfFile:fileURL
//                                                 encoding:NSShiftJISStringEncoding
//                                                    error:&error];
//    if(error){
//        NSLog(@"%@", error.localizedDescription);
//        return;
//    }
//    NSString *fileName = [[fileURL lastPathComponent] stringByDeletingPathExtension];
//    [self convertPlistFromRawCSV:rawCSV
//                        fileName:fileName];
//}

+(NSError *)loadCSVfromURL:(NSURL *)url
{
    NSError *error;
    NSString *rawCSV = [NSString stringWithContentsOfURL:url
                                                encoding:NSShiftJISStringEncoding
                                                   error:&error];
    if(error){
        NSLog(@"%@", error.localizedDescription);
        return error;
    }
    NSString *fileName = [[url lastPathComponent] stringByDeletingPathExtension];
    [self convertPlistFromRawCSV:rawCSV
                        fileName:fileName];
    return nil;
}

+(void)convertPlistFromRawCSV:(NSString *)rawCSV fileName:(NSString *)fileName
{
    NSArray *line = [NSArray arrayWithArray:[rawCSV componentsSeparatedByString:@"\r"]];
    NSMutableArray *jpns = [NSMutableArray new];
    NSMutableArray *engs = [NSMutableArray new];
    
    for(int i=0; i<line.count; i++){
        NSArray *item = [line[i] componentsSeparatedByString:@","];
        [jpns addObject:item[0]];
        [engs addObject:item[1]];
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray *files = [[NSMutableArray alloc]initWithArray:[ud objectForKey:@"files"]];
    
    NSString *uuid = [[NSUUID UUID] UUIDString];
    [files addObject:uuid];
    [ud setObject:files
           forKey:@"files"];
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:jpns, @"jpn", engs, @"eng", fileName, @"name", @(jpns.count), @"count", nil];
    [ud setObject:dic
           forKey:uuid];
    
    [ud synchronize];

}


@end
