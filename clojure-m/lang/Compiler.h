//
// Created by Sunil KS on 21/08/21.
//

#import <Foundation/Foundation.h>


@class Symbol;
@protocol ISeq;


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
+ (id)boolean:(BOOL)boolean;

- (id)initWithBoolean:(BOOL)boolean;

- (id)val;

- (id)eval;
@end


@interface NumberExpr : NSObject <Expr>
+ (id)number:(NSNumber *)number;

- (id)initWithNumber:(NSNumber *)number;

- (id)val;

- (id)eval;

@end


@interface VarExpr : NSObject <Expr>

- (id)val;

- (id)eval;

@end


@interface InvokeExpr : NSObject <Expr>

+ (id)parse:(id <ISeq>)form;

- (id)eval;

@end


@interface Compiler : NSObject
+ (id <Expr>)analyze:(id)form;

+ (id <Expr>)resolve:(Symbol *)sym;

+ (id <Expr>)analyzeSeq:(id)form;

+ (id <Expr>)analyzeSymbol:(id)form;

+ (id)eval:(id)form;
@end