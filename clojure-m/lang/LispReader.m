//
// Created by Sunil KS on 20/08/21.
//

#import "Symbol.h"
#import "LispReader.h"
#import "PersistentList.h"
#import "RT.h"


@implementation Constants

+ (NSObject *)readEOF {
    static NSObject *readEOF;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        readEOF = [[NSObject alloc] init];
    });
    return readEOF;
}


+ (NSObject *)readFinished {
    static NSObject *readFinished;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        readFinished = [[NSObject alloc] init];
    });
    return readFinished;
}


+ (NSRegularExpression *)intPattern {
    static NSRegularExpression *intPattern;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        intPattern = [NSRegularExpression regularExpressionWithPattern:@"^[0-9]+$" options:0 error:nil];
    });
    return intPattern;
}


+ (NSRegularExpression *)floatPattern {
    static NSRegularExpression *floatPattern;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        floatPattern = [NSRegularExpression regularExpressionWithPattern:@"^[0-9]+\\.[0-9]*$" options:0 error:nil];
    });
    return floatPattern;
}


+ (NSRegularExpression *)symbolPattern {
    static NSRegularExpression *symbolPattern;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        symbolPattern = [NSRegularExpression regularExpressionWithPattern:@"^\\D" options:0 error:nil];
    });
    return symbolPattern;
}
@end


NSArray *readDelimitedList(char delim, NSValue *pendingForms) {
    NSObject *form;
    NSMutableArray *list = [[NSMutableArray alloc] init];

    while (true) {
        NSArray *res = _read(pendingForms, true, [Constants readEOF], delim, [Constants readFinished]);

        form = res[0];
        pendingForms = res[1];

        if (form == [Constants readFinished]) return @[list, pendingForms];

        [list addObject:form];
    }
}


@implementation ListReader
- (NSArray *)invoke:(NSValue *)pendingForms {
    NSArray *res = readDelimitedList(')', pendingForms);

    PersistentList *l = [PersistentList arrayWithArray:res[0]];

    return @[l, res[1]];
}
@end


@implementation UnmatchedDelimiterReader
- (NSArray *)invoke:(NSValue *)pendingForms {
    @throw[NSException exceptionWithName:@"Unmatched Delimiter" reason:@"Unmatched Delimiter" userInfo:nil];
}
@end


@implementation ReaderMacros : NSObject
static NSObject <IFn> *macros[256];


+ (NSObject <IFn> *)getMacro:(char)ch {
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        macros['('] = [[ListReader alloc] init];
        macros[')'] = [[UnmatchedDelimiterReader alloc] init];
    });

    return macros[ch];
}


+ (Boolean)isMacro:(char)ch {
    return [self getMacro:ch] != nil;
}
@end


int iseof(char ch) {
//    return ch != NULL && *ch != '\0';
    return ch == '\0';
}


int isWhitespace(char ch) {
    return isspace(ch) || ch == ',';
}


NSNumber *matchNumber(NSString *s) {
    NSRange range = NSMakeRange(0, [s length]);

    NSRegularExpression *floatPattern = [Constants floatPattern];

    if ([floatPattern numberOfMatchesInString:s options:0 range:range] > 0) return @([s doubleValue]);

    NSRegularExpression *intPattern = [Constants intPattern];

    if ([intPattern numberOfMatchesInString:s options:0 range:range] > 0) return @([s longLongValue]);

    return nil;
}


NSArray *readNumber(NSValue *pendingForms) {
    char *ch = [pendingForms pointerValue];
    NSMutableString *s = [NSMutableString string];

    while (true) {
        [s appendFormat:@"%c", *ch];

        ch++;

        if (iseof(*ch) || isWhitespace(*ch) || [ReaderMacros isMacro:*ch]) {
            NSNumber *number = matchNumber(s);
            if (number == nil) {
                @throw[NSException exceptionWithName:@"InvalidNumber" reason:@"Invalid Number" userInfo:nil];
            }
            return @[number, [NSValue valueWithPointer:ch]];
        }

    }
}


NSObject *matchSymbol(NSString *s) {
    NSRange range = NSMakeRange(0, [s length]);
    NSRegularExpression *symbolPattern = [Constants symbolPattern];

    if ([symbolPattern numberOfMatchesInString:s options:0 range:range] > 0) return [Symbol intern:s];

    return nil;
}


NSObject *interpretToken(NSString *s) {
    if ([s isEqualToString:@"nil"]) return [NSNull null];
    if ([s isEqualToString:@"true"]) return @([RT T]);
    if ([s isEqualToString:@"false"]) return @([RT F]);

    return matchSymbol(s);
}


NSArray *readToken(NSValue *pendingForms) {
    char *ch = [pendingForms pointerValue];
    NSMutableString *s = [NSMutableString string];

    while (true) {
        [s appendFormat:@"%c", *ch];

        ch++;

        if (iseof(*ch) || isWhitespace(*ch) || [ReaderMacros isMacro:*ch]) {
            NSObject *token = interpretToken(s);
            if (token == nil) {
                @throw[NSException exceptionWithName:@"InvalidToken" reason:@"Invalid token" userInfo:nil];
            }
            return @[token, [NSValue valueWithPointer:ch]];
        }
    }
}


NSArray *_read(NSValue *source, Boolean eofIsError, NSObject *eofValue, char returnOn, NSObject *returnOnValue) {
    char *ch = [source pointerValue];

    while (isWhitespace(*ch)) ++ch;

    if (iseof(*ch)) {
        if (eofIsError) @throw[NSException exceptionWithName:@"EOF while reading" reason:@"EOF while reading" userInfo:nil];

        return @[eofValue, [NSValue valueWithPointer:ch]];
    };

    if (*ch == returnOn) return @[returnOnValue, [NSValue valueWithPointer:++ch]];

    if (isdigit(*ch)) return readNumber([NSValue valueWithPointer:ch]);

    NSObject <IFn> *readerMacro = [ReaderMacros getMacro:*ch];

    if (readerMacro != nil) {
        ++ch;
        return [readerMacro invoke:[NSValue valueWithPointer:ch]];
    }

    return readToken([NSValue valueWithPointer:ch]);
}


@implementation LispReader

+ (NSObject *)read:(char *)source {
    NSArray *r = _read([NSValue valueWithPointer:source], true, nil, nil, nil);
    char *remaining = [r[1] pointerValue];

    while (isWhitespace(*remaining)) ++remaining;

    if (!iseof(*remaining)) @throw[NSException exceptionWithName:@"EOF" reason:@"EOF" userInfo:nil];

    NSObject *result = r[0];

    return result;
}

@end