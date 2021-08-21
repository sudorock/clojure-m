//
// Created by Sunil KS on 20/08/21.
//

#import <Foundation/Foundation.h>
#import "IFn.h"


NSArray *_read(NSValue *source, Boolean eofIsError, NSObject *eofValue, char returnOn, NSObject *returnOnValue);


@interface Constants : NSObject
+ (NSObject *)readEOF;

+ (NSObject *)readFinished;

+ (NSRegularExpression *)intPattern;

+ (NSRegularExpression *)floatPattern;

+ (NSRegularExpression *)symbolPattern;
@end


@interface ListReader : NSObject <IFn>
- (NSArray *)invoke:(NSValue *)pendingForms;
@end


@interface UnmatchedDelimiterReader : NSObject <IFn>
- (NSArray *)invoke:(NSValue *)pendingForms;
@end


@interface ReaderMacros : NSObject
+ (NSObject <IFn> *)getMacro:(char)ch;

+ (Boolean)isMacro:(char)ch;
@end


@interface LispReader : NSObject
+ (NSObject *)read:(char *)source;
@end