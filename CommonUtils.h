//
//  CommonUtils.h
//  LingQ
//
//  Created by yimouleng on 8/23/11.
//  Copyright 2011 yimouleng. All rights reserved.
//

#include <ifaddrs.h>
#include <arpa/inet.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#import <Foundation/Foundation.h>


@interface CommonUtils : NSObject
/**
 *  根据颜色生成image
 *
 *  @param color 颜色
 *
 *  @return UIImage
 */
+ (UIImage *)imageFromColor:(UIColor *)color;

/**
 *  将数组中的元素转成字符串
 *
 *  @param array array
 *
 *  @return NSString
 */
+ (NSString *)convertArrayToString:(NSArray *)array;

/**
 * 字符串变成数组
 *
 *  @param string 字符串
 *
 *  @return 数组
 */
+ (NSArray *)convertStringToArray:(NSString *)string;

/**
 *  得到文件夹的大小
 *
 *  @param folderName 路径
 *
 *  @return 大小
 */
+ (long)getDocumentSize:(NSString *)folderName;

/**
 *  得到小写字母
 *
 *  @return
 */
+ (NSArray *)getLetters;

/**
 *  得到大写字母
 *
 *  @return
 */
+ (NSArray *)getUpperLetters;

/**
 *  得到IP地址
 *
 *  @return
 */
+ (NSString *)getIPAddress;

+ (NSString *)getFreeMemory;

+ (NSString *)getDiskUsed;

/**
 *  能否在指定的位置创建目录
 *
 *  @param path 目录路径
 *
 *  @return 
 */
+ (BOOL)createDirectorysAtPath:(NSString *)path;

+ (NSString*)getDirectoryPathByFilePath:(NSString *)filepath;
@end
