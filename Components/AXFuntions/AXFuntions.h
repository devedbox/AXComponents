//
//  AXFuntions.h
//  AXSwift2OC
//
//  Created by ai on 15/9/4.
//  Copyright © 2015年 ai. All rights reserved.
//

#import <Foundation/Foundation.h>

void EXECUTE(dispatch_block_t block);
void EXECUTE_ON_MAIN_THREAD(dispatch_block_t block);
void FILE_PATH(NSString **storage, NSString *bundleName, NSString *fileName);