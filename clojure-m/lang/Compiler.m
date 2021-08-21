//
// Created by Sunil KS on 21/08/21.
//

#import "Compiler.h"
#import "RT.h"


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


@implementation Compiler

+ (id <Expr>)analyze:(id)form {
    if (form == [NSNull null]) return [[NilExpr alloc] init];
    if ([form isEqual:@([RT T])]) return [BooleanExpr boolean:true];
    if ([form isEqual:@([RT F])]) return [BooleanExpr boolean:false];
    return nil;
}

+ (id)eval:(id)form {
    id <Expr> expr = [self analyze:form];
    return [expr eval];
}

@end
