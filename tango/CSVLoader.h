//
//  CSVLoader.h
//  tango
//
//  Created by Kohei on 2014/10/07.
//  Copyright (c) 2014年 KoheiKanagu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSVLoader : NSObject

+(NSError *)loadCSVfromURL:(NSURL *)url;

@end
