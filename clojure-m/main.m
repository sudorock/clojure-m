#import <Foundation/Foundation.h>

NSArray *_read(NSValue *sourceValPointer, NSObject *eofValue, char returnOn, NSObject *returnOnValue);

@interface Constants : NSObject
+ (NSObject *)readEOF;

+ (NSObject *)readFinished;

+ (NSRegularExpression *)intPattern;

+ (NSRegularExpression *)floatPattern;

+ (NSRegularExpression *)symbolPattern;
@end

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


@interface Symbol : NSObject
@property NSString *name;

+ (id)intern:(NSString *)name;

- (instancetype)initWithName:(NSString *)name;
@end

@implementation Symbol

+ (id)intern:(NSString *)name {
    return [[self alloc] initWithName:name];
}

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (!self) return nil;

    self.name = name;
    return self;
}
@end

@protocol IFn <NSObject>
- (id)invoke:(id)arg1;

+ (id)alloc;
@end

@interface ListReader : NSObject <IFn>
- (NSArray *)invoke:(NSValue *)chPointerVal;
@end

@implementation ListReader
- (NSArray *)invoke:(NSValue *)chPointerVal {
    NSObject *form;
    NSValue *pendingForms = chPointerVal;
    NSMutableArray *list = [[NSMutableArray alloc] init];

    while (true) {
        NSArray *result = _read(pendingForms, [Constants readEOF], ')', [Constants readFinished]);

        form = result[0];
        pendingForms = result[1];

        if (form == [Constants readFinished]) return @[list, pendingForms];

        [list addObject:form];
    }
}
@end

@interface ReaderMacros : NSObject
+ (NSObject <IFn> *)getMacro:(char)ch;

+ (Boolean)isMacro:(char)ch;
@end

@implementation ReaderMacros : NSObject
static NSObject <IFn> *macros[256];

+ (NSObject <IFn> *)getMacro:(char)ch {
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        macros['('] = [[ListReader alloc] init];
        macros[')'] = [[NSObject alloc] init];
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

NSArray *readNumber(NSValue *chValPointer) {
    char *ch = [chValPointer pointerValue];
    NSMutableString *s = [NSMutableString string];

    while (true) {
        [s appendFormat:@"%c", *ch];

        ch++;

        if (iseof(*ch) || isWhitespace(*ch) || [ReaderMacros isMacro:*ch]) {
            NSObject *number = matchNumber(s);
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
    if ([s isEqualToString:@"true"]) return @(true);
    if ([s isEqualToString:@"false"]) return @(false);

    return matchSymbol(s);
}

NSArray *readToken(NSValue *chValPointer) {
    char *ch = [chValPointer pointerValue];
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


NSArray *_read(NSValue *sourceValPointer, NSObject *eofValue, char returnOn, NSObject *returnOnValue) {
    char *source = [sourceValPointer pointerValue];

    if (iseof(*source)) return @[eofValue, [NSValue valueWithPointer:source]];

    if (*source == returnOn) return @[returnOnValue, [NSValue valueWithPointer:++source]];

    while (isWhitespace(*source)) ++source;

    if (isdigit(*source)) return readNumber([NSValue valueWithPointer:source]);

    NSObject <IFn> *readerMacro = [ReaderMacros getMacro:*source];

    if (readerMacro != nil) {
        ++source;
        return [readerMacro invoke:[NSValue valueWithPointer:source]];
    }

    return readToken([NSValue valueWithPointer:source]);
}

NSObject *readString(char *source) {
    NSArray *r = _read([NSValue valueWithPointer:source], nil, nil, nil);
    char *remaining = [r[1] pointerValue];

    while (isWhitespace(*remaining)) ++remaining;

    if (!iseof(*remaining)) @throw[NSException exceptionWithName:@"EOF" reason:@"EOF" userInfo:nil];

    NSObject *result = r[0];

    return result;
}

int main() {
//    char *source = "  (false 1.25 2 sunil 3 (9 10 false 5.))       ";
    char *source = "  (false 1.25 2 sunil 3 (9 10 false 5.))       ";

    NSObject *k = readString(source);


    return 0;
}


/*
 TODO
 reader macros
  Start with list

 token

 Separate reading as a separate function


 */


//@interface Reader : NSObject
//+ (NSObject *)getMacro:(char)ch;
//@end

//@implementation Reader
//+ (NSObject *)getMacro:(char)ch {
//    static NSDictionary *macros = nil;
//    static dispatch_once_t onceToken;
//
//    dispatch_once(&onceToken, ^{
//        macros = @{
//                @'(': [ListReader alloc]
//        };
//    });
//
//    return macros[ch];
//}
//@end


//NSObject *readList(char **ch) {
//    NSMutableArray *list = [[NSMutableArray alloc] init];
//    while (true) {
//        NSObject *form = READ(*ch, READ_EOF, ')', READ_FINISHED);
//
//        if (form == READ_FINISHED) return list;
//
//        [list addObject:form];
//    }
//}




//static NSDictionary *macros = @{
//        @"(": [Reader alloc]
//};


//NSObject *readMacros(char **ch) {
//    switch (**ch) {
//        case '(':
//            ++*ch;
//            return [ListReader class];
//        default:
//            return [NSValue valueWithPointer:ch];
//    }
//
//}

//
//NSObject *getMacro(char ch) {
//    switch (ch) {
//        case '(':
//            return [NSValue valueWithPointer:readList];
//        default:
//            return nil;
//    }
//}

//NSObject *readDelimited(char **ch) {
//
//}


//@interface PushbackReader : NSObject
//- (PushbackReader *)initWithPointer:(NSObject *)ptr;
//- (PushbackReader *)read;
//- (PushbackReader *)unread;
//@end
//
//
//@implementation PushbackReader
//
//@end

/*
 * TODO
 * Check whether you can read from file
 * Check read number match symbol
 */