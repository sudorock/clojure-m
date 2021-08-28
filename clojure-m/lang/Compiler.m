//
// Created by Sunil KS on 21/08/21.
//

#import "Compiler.h"
#import "RT.h"
#import "Symbol.h"
#import "PersistentList.h"
#import "ISeq.h"
#import "PersistentVector.h"
#import "Var.h"
#import "IFn.h"


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
    return _val ? [Bool T] : [Bool F];
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
    Var *_var;
}

+ (id)var:(Var *)var {
    return [[self alloc] initWithVar:var];
}


- (id)initWithVar:(Var *)var {
    self = [super init];
    _var = var;
    return self;
}


- (id)eval {
    return nil;
}


@end


@implementation InvokeExpr {
    id <Expr> _fexpr;
    PersistentVector *_args;
}

+ (id)fexpr:(id <Expr>)fexpr args:(PersistentVector *)args {
    return [[self alloc] initWithFexpr:fexpr args:args];
}


+ (id)parse:(id <ISeq>)form {
    id <Expr> fexpr = [Compiler analyze:[form first]];
    PersistentVector *args = [PersistentVector vector];
    id <ISeq> s = [form next];

    while (s != (id <ISeq>) [NSNull null]) {
        args = [args cons:[Compiler analyze:[s first]]];
        s = [s next];
    }

    return [self fexpr:fexpr args:args];
}


- (id)initWithFexpr:(id <Expr>)fexpr args:(PersistentVector *)args {
    self = [super init];
    _fexpr = fexpr;
    _args = args;

    return self;
}


- (id)eval {
    id <IFn> fn = [_fexpr eval];
    PersistentVector *argvs = [PersistentVector vector];

    for (NSUInteger i = 0; i < [_args count]; i++) {
        [argvs cons:[[_args nth:i] eval]];
    }

    return [fn applyTo:[RT seq:argvs]];
}

@end


@implementation DefExpr {
    Var *_var;
    id <Expr> _expr;
}

+ (id)var:(Var *)var expr:(id <Expr>)expr {
    return [[self alloc] initWithVar:var expr:expr];
}


- (id)initWithVar:(Var *)var expr:(id <Expr>)expr {
    self = [super init];
    _var = var;
    _expr = expr;
    return self;
}


- (id)eval {
    [_var bindRoot:[_expr eval]];
    return _var;
}


@end


@implementation DefExprParser
- (id <Expr>)parse:(PersistentList *)form {
    Symbol *sym = [RT second:form];

    // TODO lookup var
    Var *v = [Var name:[sym getName]];

    return [DefExpr var:v expr:[Compiler analyze:[RT third:form]]];
}

@end


@implementation Compiler

static NSDictionary *specialFormParsers;


+ (id <IParser>)getSpecialFormParser:(Symbol *)op {
    static dispatch_once_t onceToken;
    // TODO Think of whether this should be done using Persistent hashmaps like the JVM
    dispatch_once(&onceToken, ^{
        specialFormParsers = @{
                @"def": [[DefExprParser alloc] init]
        };
    });

    return specialFormParsers[[op getName]];
}


+ (id <Expr>)analyze:(id)form {
    if (form == [NSNull null]) return [[NilExpr alloc] init];

    if ([form isEqual:[Bool T]]) return [BooleanExpr boolean:true];

    if ([form isEqual:[Bool T]]) return [BooleanExpr boolean:false];

    if ([form isKindOfClass:[NSNumber class]]) return [NumberExpr number:form];

    if ([form isKindOfClass:[Symbol class]]) return [self analyzeSymbol:form];

    if ([form isKindOfClass:[PersistentList class]]) return [self analyzeSeq:form];

    return nil;
}


+ (id <Expr>)resolve:(Symbol *)form {
    return [VarExpr var:[[NSObject alloc] init]];
}


+ (id <Expr>)analyzeSeq:(PersistentList *)form {

    id op = [form first];

    id <IParser> p = [self getSpecialFormParser:op];
    if (p != nil) return [p parse:form];

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
