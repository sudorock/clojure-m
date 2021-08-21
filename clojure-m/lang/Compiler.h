//
// Created by Sunil KS on 21/08/21.
//

#import <Foundation/Foundation.h>

@protocol Expr
- (id)eval;
@end


@protocol LiteralExpr <Expr>
- (id)val;
@end


@interface NilExpr : NSObject <LiteralExpr>
- (id)val;

- (id)eval;
@end

@interface BooleanExpr : NSObject <LiteralExpr>
+ (id)boolean:(BOOL)val;

- (id)initWithBoolean:(BOOL)val;

- (id)val;

- (id)eval;
@end


@interface Compiler : NSObject
+ (id <Expr>)analyze:(id)form;

+ (id)eval:(id)form;
@end