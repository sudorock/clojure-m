//
// Created by Sunil KS on 21/08/21.
//

#import "Compiler.h"
#import "RT.h"
#import "Symbol.h"


//TODO Check if you need to instantiate [NSNull null] only once
@implementation NilExpr
- (id)val {
    return [NSNull null];
}


- (id)eval {
    return [self val];
}

@end


@implementation BooleanExpr {
    BOOL _val;
}

+ (id)boolean:(BOOL)val {
    return [[self alloc] initWithBoolean:val];
}


- (id)initWithBoolean:(BOOL)val {
    self = [super init];
    _val = val;
    return self;
}


- (id)val {
    return @(_val ? [RT T] : [RT F]);
}


- (id)eval {
    return [self val];
}

@end


@implementation NumberExpr {
    NSNumber *_val;
}

+ (id)number:(NSNumber *)val {
    return [[self alloc] initWithNumber:val];
}


- (id)initWithNumber:(NSNumber *)val {
    self = [super init];
    _val = val;
    return self;
}


- (id)val {
    return _val;
}


- (id)eval {
    return [self val];
}

@end


@implementation VarExpr {
    NSObject *_val;
}

+ (id)var:(NSObject *)val {
    return [[self alloc] initWithVar:val];
}


- (id)initWithVar:(NSObject *)val {
    self = [super init];
    _val = val;
    return self;
}


- (id)val {
    return _val;
}


- (id)eval {
    return [self val];
}

@end


@implementation Compiler

+ (id <Expr>)analyze:(id)form {
    if (form == [NSNull null]) return [[NilExpr alloc] init];

    if ([form isEqual:@([RT T])]) return [BooleanExpr boolean:true];

    if ([form isEqual:@([RT F])]) return [BooleanExpr boolean:false];

    if ([form isKindOfClass:[NSNumber class]]) return [NumberExpr number:form];

    if ([form isKindOfClass:[Symbol class]]) return [self analyzeSymbol:form];

    return nil;
}


+ (id <Expr>)resolve:(Symbol *)form {
    return [VarExpr var:[[NSObject alloc] init]];
}


+ (id <Expr>)analyzeSeq:(id)form {
    return nil;
}


+ (id <Expr>)analyzeSymbol:(id)form {
    return [self resolve:form];
}


+ (id)eval:(id)form {
    id <Expr> expr = [self analyze:form];
    return [expr eval];
}

@end
