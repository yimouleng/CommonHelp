//
//  CommonHelp.m
//  HaierJiaDian
//
//  Created by yimouleng on 14-4-28.
//
//

#import "CommonHelp.h"
#import "KeychainItemWrapper.h"

#define UUIDIdentifier @"UUIDIdentifier"

@implementation CommonHelp

+(NSString *)roundUp:(float)number afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:number];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

+ (NSString *)getStringFromNetWorKString:(id)networkString
{
    NSString *value = nil;
    if ([networkString isKindOfClass:[NSNumber class]]) {
        value = [networkString stringValue];
    }else if([networkString isKindOfClass:[NSNull class]]){
        value = nil;
    }else{
        value = networkString;
    }
    if (!value || ![value length]) {
        value = @"";
    }
    return value;
}

#define aMinute 60
#define aHour 3600
#define aDay 86400
#define aWeek  (86400*7)
#define aMouth 86400* 30
#define aYear 60 * 60 * 24 * 365

+ (CGSize)getSizeFromString:(NSString *)string WithFont:(UIFont *)font withSize:(CGSize)size
{
    if (!string || ![string length]) {
        return CGSizeZero;
        
    }
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000      //(IOS 7以上用这个方法，以下用else方法)
    if (IOS_VERSION_CODE >= 7) {
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
        CGRect frame = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDictionary context:nil];
        CGSize titleSize = CGSizeMake(frame.size.width,frame.size.height);
        
        return titleSize;
        
    }else{
        CGSize titleSize = [string sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        return titleSize;
    }
#else
    CGSize titleSize = [string sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    return titleSize;
#endif
    
}


+ (BOOL)isValidValue:(NSString*)value
{
    if (value && [value length] > 0) {
        return YES;
    }
    return NO;
}

/*车牌号验证 MODIFIED BY HELENSONG*/
+ (BOOL) validateCarNo:(NSString *)carNo
{
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}


#pragma mark - 根据尺寸压缩图片
+(UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  提示框
 *
 *  @param string 提示的内容
 */
+ (void)showMessageString:(NSString *)string
{
    if (!string || ![string length]) {
        return;
    }
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}



#pragma mark --- UUID

#pragma mark 使用KeyChain保存和获取UDID
+(NSString*)getUUID {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
//    NSString * result = (NSString *)CFStringCreateCopy( NULL, uuidString);
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}


+ (NSString *)getUUIDFromKeychainItemWrapper
{
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:UUIDIdentifier accessGroup:nil];
    //从keychain里取出帐号密码
    NSString * uuidString = [wrapper objectForKey:(__bridge id)kSecValueData];
    if (!uuidString || ![uuidString length]) {
         uuidString = [CommonHelp getUUID];
        [wrapper setObject:uuidString forKey:(__bridge id)kSecValueData];
    }
    return uuidString;
}

/*
 截屏
 */
+ (UIImage *)screenShotsWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.framewidth, view.frameheight), YES, 0);
    //设置截屏大小
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

///提示信息
+ (void)promptMessage:(NSString *)message withCancelStr:(NSString *)cancelStr withConfirmStr:(NSString *)confirmStr
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:cancelStr otherButtonTitles:confirmStr, nil];
    [alert show];
}

+ (NSString *)getDateTimeString
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString *timeString = [NSString stringWithFormat:@"%ld", (long)[dat timeIntervalSince1970]];
    return timeString;
}

+(NSString *)randomStringWithLength:(int)len
{
    NSString *letters = @"0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    
    return randomString;
}



+(UIImage*)getImageByName:(NSString*)imageName{
    NSString * path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    UIImage * image = [[UIImage alloc] initWithContentsOfFile:path];
    return image;
}
+ (NSString *)getTimeFromTimestamp:(NSString *)datetime
{
    if (datetime) {
        NSTimeInterval  timeInterVal = [[NSDate date] timeIntervalSince1970];
        double publicTime = [datetime doubleValue];
        if (timeInterVal - publicTime < aMinute) {
            return @"刚刚";
        }else if (timeInterVal- publicTime < aHour){
            int minuteNum = (timeInterVal - publicTime)/aMinute;
            return [NSString stringWithFormat:@"%d分钟前",minuteNum];
        }else if(timeInterVal - publicTime < aDay){
            int hourNum = (timeInterVal - publicTime)/aHour;
            return [NSString stringWithFormat:@"%d小时前",hourNum];
        }else if(timeInterVal - publicTime < aWeek){
            int dayNum = (timeInterVal - publicTime)/aDay;
            return [NSString stringWithFormat:@"%d天前",dayNum];
        }else if(timeInterVal - publicTime < aMouth){
            int MouthNum = (timeInterVal - publicTime)/aWeek;
            return [NSString stringWithFormat:@"%d周前",MouthNum];
        }else{
            NSString *string;
            
            NSDateFormatter *dateFormatter = nil;
            if (dateFormatter == nil) {
                dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            }
            string = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:([datetime doubleValue])]];
            return string;
        }    }
    return @"";
    
}


+ (NSString *)getSinceTimeFromTimestamp:(NSString *)datetime
{
    if (datetime) {
        NSTimeInterval  timeInterVal = [[NSDate date] timeIntervalSince1970];
        double publicTime = [datetime doubleValue];
        if (timeInterVal - publicTime < aMinute) {
            return @"刚刚";
        }else if (timeInterVal- publicTime < aHour){
            int minuteNum = (timeInterVal - publicTime)/aMinute;
            return [NSString stringWithFormat:@"%d分钟前",minuteNum];
        }else if(timeInterVal - publicTime < aDay){
            int hourNum = (timeInterVal - publicTime)/aHour;
            return [NSString stringWithFormat:@"%d小时前",hourNum];
        }else if(timeInterVal - publicTime < aWeek){
            int dayNum = (timeInterVal - publicTime)/aDay;
            return [NSString stringWithFormat:@"%d天前",dayNum];
        }else if(timeInterVal - publicTime < aMouth){
            int MouthNum = (timeInterVal - publicTime)/aWeek;
            return [NSString stringWithFormat:@"%d周前",MouthNum];
        }else{
            NSString *string;
            
            NSDateFormatter *dateFormatter = nil;
            if (dateFormatter == nil) {
                dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy.MM.dd"];
            }
            string = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:([datetime doubleValue])]];
            return string;
        }    }
    return @"";
    
}
+ (NSString *)getTimeFromTimestampset:(NSString *)datetime
{
    
    if (datetime) {
            NSString *string;
            
            NSDateFormatter *dateFormatter = nil;
            if (dateFormatter == nil) {
                dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy.MM.dd"];
            }
            string = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:([datetime doubleValue]/1000)]];
            return string;
           }
    return @"";
    
}


+ (NSString *)getMMWishDeadLineTimeFromDieTime:(NSString *)dietimeString
{
    NSInteger dietime = dietimeString.intValue;
    NSString *dayString = [NSString stringWithFormat:@"%d",(int)dietime/(3600*24)];
    NSString *hourString = [NSString stringWithFormat:@"%d",(int)dietime%(3600*24)/3600];
    NSString *minuteString = [NSString stringWithFormat:@"%d",(int)dietime/60];
    if ([dietimeString isEqualToString:@"0"]) {
        dayString = @"";
        hourString = @"";
        minuteString = @"0分钟";
    } else {
        if (dayString.intValue == 0 && hourString.intValue == 0) {
            dayString = @"";
            if (minuteString.integerValue == 0) {
                minuteString = @"1分钟";
            } else if (minuteString.integerValue == 59) {
                hourString = @"1小时";
                minuteString = @"";
            } else {
                hourString = @"";
                minuteString = [NSString stringWithFormat:@"%@分钟",minuteString];
            }
        } else {
            if (dayString.integerValue == 0) {
                dayString = @"";
            } else {
                dayString = [NSString stringWithFormat:@"%@天",dayString];
            }
            if (hourString.integerValue == 0) {
                hourString = @"";
            } else if (hourString.integerValue == 23) {
                dayString = [NSString stringWithFormat:@"%d天",(int)dayString.integerValue + 1];
                hourString = @"";
            } else {
                hourString = [NSString stringWithFormat:@"%@小时",hourString];
            }
            minuteString = @"";
        }
    }
    return [NSString stringWithFormat:@"%@%@%@",dayString,hourString,minuteString];
}

/*!
 @class
 @abstract 判断是不是手机号
 */


+ (BOOL)isvalidateMobile:(NSString *)mobile
{
    NSString *regex = @"^[1][\\d]{10}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:mobile];
    return isMatch;
}

+ (BOOL)isValidValueOrMobile:(NSString *)mobile
{
    if (mobile == nil || [mobile length] == 0 ) {
        [self showMessageString:@"手机号不能为空"];
        return NO;
    }
    
    if (![self isvalidateMobile:mobile]) {
        [self showMessageString:@"请输入正确的手机号"];
        return NO;
    }
    
    return YES;
}

#pragma 正则匹配用户身份证号15或18位
+ (BOOL)validateIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    int length =0;
    if (!value) {
        return NO;
    }else {
        length = (int)value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                              options:NSMatchingReportProgress
                                                                range:NSMakeRange(0, value.length)];
            
//            [regularExpression release];
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                              options:NSMatchingReportProgress
                                                                range:NSMakeRange(0, value.length)];
            
//            [regularExpression release];
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return false;
    }
}
#pragma 正则匹配用户身份证号15或18位
+ (BOOL)checkUserIdCard: (NSString *) idCard
{
    BOOL flag;
    if (idCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:idCard];
}
///*!
// @class
// @abstract 判断2个UserID是否相等
// */
//+(BOOL)judgeUserId:(NSString *)userId;
//{
//    if ([userId isEqualToString:DATA_USERID]) {
//        return YES;
//    }else{
//        return NO;
//    }
//}


/*邮箱验证 MODIFIED BY HELENSONG*/
+(BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/**
 *  字符串是NSNull类型的情况
 */
+ (NSString *)changeStr:(NSString *)string
{
    if ([string isKindOfClass:[NSNull class]]) {
        return @"";
    }
        return string;
}

/**
 *  计算文字宽高
 */

//获取字符串高度
+ (CGFloat)getZSCTextHight:(NSString *)textStr andWidth:(CGFloat)width andTextFontSize:(NSInteger)fontSize
{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [textStr boundingRectWithSize:CGSizeMake(width, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size.height;
}

//获取字符串宽度
+ (CGFloat)getZSCTextWidth:(NSString *)textStr andHeight:(CGFloat)height andTextFontSize:(NSInteger)fontSize
{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [textStr boundingRectWithSize:CGSizeMake(0, height) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size.width;
}
//设置字体和颜色
+ (void)setZSCLabelFontAndColorWithLabel:(UILabel *)label andTextFontSize:(NSInteger)fontSize andColor:(UIColor *)color andRange:(NSRange)range
{
    NSMutableAttributedString*attributedString=[[NSMutableAttributedString alloc]initWithString: label.text];
    NSDictionary*dic=@{
                       NSForegroundColorAttributeName:color,
                       NSFontAttributeName:[UIFont systemFontOfSize:fontSize]
                       };
    [attributedString addAttributes:dic range:range];
    [label setAttributedText:attributedString];
}

@end
