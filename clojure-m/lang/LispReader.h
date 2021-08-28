//
// Created by Sunil KS on 20/08/21.
//

#import <Foundation/Foundation.h>
#import "IFn.h"


NSArray *_read(NSValue *source, Boolean eofIsError, NSObject *eofValue, char returnOn, NSObject *returnOnValue);


@interface ListReader : NSObject <IFn>
- (NSArray *)invoke:(NSValue *)pendingForms;
@end


@interface UnmatchedDelimiterReader : NSObject <IFn>
- (NSArray *)invoke:(NSValue *)pendingForms;
@end


@interface LispReader : NSObject
+ (NSObject *)READ_EOF;

+ (NSObject *)READ_FINISHED;

+ (NSRegularExpression *)INT_PATTERN;

+ (NSRegularExpression *)FLOAT_PATTERN;

+ (NSRegularExpression *)SYMBOL_PATTERN;

+ (NSObject <IFn> *)getMacro:(char)ch;

+ (BOOL)isMacro:(char)ch;

+ (NSObject *)read:(char *)source;
@end