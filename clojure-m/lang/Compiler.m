//
// Created by Sunil KS on 21/08/21.
//

#import "Compiler.h"


//TODO Check if you need to instantiate [NSNull null] only once
@implementation NilExpr
- (id)val {
    return [NSNull null];
}

- (id)eval {
    return [self val];
}

@end


@implementation Compiler

+ (id <Expr>)analyze:(id)form {
    if (form == [NSNull null]) return [[NilExpr alloc] init];
    return nil;
}

+ (id)eval:(id)form {
    id <Expr> expr = [self analyze:form];
    return [expr eval];
}

@end
