//
// Created by Sunil KS on 21/08/21.
//

#import <Foundation/Foundation.h>


@protocol ISeq;


@interface Bool : NSObject
+ (instancetype)T;

+ (instancetype)F;
@end


@interface RT : NSObject
+ (id)second:(id)x;

+ (id)third:(id)x;

+ (id)first:(id)x;

+ (id)next:(id)x;

+ (id <ISeq>)seq:(id)coll;
@end