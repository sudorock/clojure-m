//
// Created by Sunil KS on 21/08/21.
//

#import "Compiler.h"
#import "RT.h"
#import "Symbol.h"
#import "PersistentList.h"
#import "ISeq.h"


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

+ (id)boolean:(BOOL)boolean {
    return [[self alloc] initWithBoolean:boolean];
}


- (id)initWithBoolean:(BOOL)boolean {
    self = [super init];
    _val = boolean;
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

+ (id)number:(NSNumber *)number {
    return [[self alloc] initWithNumber:number];
}


- (id)initWithNumber:(NSNumber *)number {
    self = [super init];
    _val = number;
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

+ (id)var:(NSObject *)var {
    return [[self alloc] initWithVar:var];
}


- (id)initWithVar:(NSObject *)var {
    self = [super init];
    _val = var;
    return self;
}


- (id)val {
    return _val;
}


- (id)eval {
    return [self val];
}

@end


@implementation InvokeExpr {
    NSObject *_val;
}

+ (id)fexpr:(NSObject *)fexpr args:(NSObject *)args {
    return [[self alloc] initWithFexpr:fexpr args:args];
}


- (id)initWithFexpr:(NSObject *)fexpr args:(NSObject *)args {
    self = [super init];
    _val = fexpr;
    return self;
}


+ (id)parse:(id <ISeq>)form {
    id <Expr> fexpr = [Compiler analyze:[form first]];

    return nil;
}


- (id)eval {
    return nil;
}

@end


@implementation Compiler

+ (id <Expr>)analyze:(id)form {
    if (form == [NSNull null]) return [[NilExpr alloc] init];

    if ([form isEqual:@([RT T])]) return [BooleanExpr boolean:true];

    if ([form isEqual:@([RT F])]) return [BooleanExpr boolean:false];

    if ([form isKindOfClass:[NSNumber class]]) return [NumberExpr number:form];

    if ([form isKindOfClass:[Symbol class]]) return [self analyzeSymbol:form];

    if ([form isKindOfClass:[PersistentList class]]) return [self analyzeSeq:form];

    return nil;
}


+ (id <Expr>)resolve:(Symbol *)form {
    return [VarExpr var:[[NSObject alloc] init]];
}


+ (id <Expr>)analyzeSeq:(id)form {
    return [InvokeExpr parse:form];
}


+ (id <Expr>)analyzeSymbol:(id)form {
    return [self resolve:form];
}


+ (id)eval:(id)form {
    id <Expr> expr = [self analyze:form];
    return [expr eval];
}

@end
