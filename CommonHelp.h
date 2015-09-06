//
//  CommonHelp.h
//  HaierJiaDian
//
//  Created by yimouleng on 14-4-28.
//
//

#import <Foundation/Foundation.h>

@interface CommonHelp : NSObject

/**
 *  当前时间戳
 *
 *  @return 时间戳
 */
+ (NSString *)getDateTimeString;

/**
 *  随机数字
 *
 *  @param len 长度
 *
 *  @return 随机数
 */
+ (NSString *)randomStringWithLength:(int)len;

+ (NSString *)getStringFromNetWorKString:(id)networkString; //从接口得到的数据转换

+ (BOOL)isValidValue:(NSString*)value;
///截屏
+ (UIImage *)screenShotsWithView:(UIView *)view;

/*车牌号验证 MODIFIED BY HELENSONG*/
+ (BOOL) validateCarNo:(NSString *)carNo;
/*!
 @class
 @abstract 对图片按尺寸尽心压缩
 */
+(UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize) size;
/*!
 @class
 @abstract 消息提示框，没有代理的
 */
+ (void)showMessageString:(NSString *)string;

/*!
 @class
 @abstract 用钥匙串存储UUID和获得UUID
 */
+ (NSString *)getUUIDFromKeychainItemWrapper;

/**
 *  提示信息
 *
 *  @param message    内容
 *  @param cancelStr  取消按钮
 *  @param confirmStr 确定按钮
 */
+ (void)promptMessage:(NSString *)message withCancelStr:(NSString *)cancelStr withConfirmStr:(NSString *)confirmStr;

+(UIImage*)getImageByName:(NSString*)imageName;


+ (NSString *)getTimeFromTimestamp:(NSString *)datetime;  //根据时间戳返回几分钟
+ (NSString *)getSinceTimeFromTimestamp:(NSString *)datetime;//根据时间戳返回几分钟之前
+ (CGSize)getSizeFromString:(NSString *)string WithFont:(UIFont *)font withSize:(CGSize)size;//算出适合此文字放得大小

+ (BOOL)isvalidateMobile:(NSString *)mobile;//判断是否是有效的电话号码

//身份证号
+ (BOOL)checkUserIdCard: (NSString *) idCard;

+ (BOOL)validateIDCardNumber:(NSString *)value;
/**
 *
 *
 *  @param dietimeString 接口返回秒
 *
 *  @return 返回几天几小时
 */
+ (NSString *)getMMWishDeadLineTimeFromDieTime:(NSString *)dietimeString;

/*邮箱验证 MODIFIED BY HELENSONG*/
+(BOOL)validateEmail:(NSString *)email;

/**
 *  字符串是NSNull类型的情况
 */
+ (NSString *)changeStr:(NSString *)string;


@end
