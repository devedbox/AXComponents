//
//  AXFuntions.m
//  AXSwift2OC
//
//  Created by ai on 15/9/4.
//  Copyright © 2015年 ai. All rights reserved.
//

#import "AXFuntions.h"

void EXECUTE(dispatch_block_t block) {
    block();
}

void EXECUTE_ON_MAIN_THREAD(dispatch_block_t block) {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

void FILE_PATH(NSString **storage, NSString *bundleName, NSString *fileName) {
    *storage = [NSString stringWithFormat:@"%@.bundle/%@", bundleName, fileName];
}